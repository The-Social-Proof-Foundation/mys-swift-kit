//
//  zkLoginSignature.swift
//  MySoKit
//
//  Copyright (c) 2025 The Social Proof Foundation, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public struct zkLoginSignature: KeyProtocol, Equatable {
    public var inputs: zkLoginSignatureInputs
    public var maxEpoch: UInt64
    public var userSignature: [UInt8]

    public init(inputs: zkLoginSignatureInputs, maxEpoch: UInt64, userSignature: [UInt8]) {
        self.inputs = inputs
        self.maxEpoch = maxEpoch
        self.userSignature = userSignature
    }

    public init(serializedData: Data) throws {
        let der = Deserializer(data: serializedData)
        let result = try zkLoginSignature.deserialize(from: der)
        self.init(inputs: result.inputs, maxEpoch: result.maxEpoch, userSignature: result.userSignature)
    }

    public func getSignatureBytes(signature: String? = nil) throws -> Data {
        let ser = Serializer()

        // Serialize the entire zkLoginSignature struct
        try self.serialize(ser)
        return ser.output()
    }

    public func getSignature() throws -> String {
        let bytes = try self.getSignatureBytes()
        var signatureBytes = Data(count: bytes.count + 1)
        signatureBytes[0] = SignatureSchemeFlags.SIGNATURE_SCHEME_TO_FLAG["zkLogin"]!
        signatureBytes[1..<(bytes.count + 1)] = bytes
        return signatureBytes.base64EncodedString()
    }

    public func serialize(_ serializer: Serializer) throws {
        try Serializer._struct(serializer, value: self.inputs)
        try Serializer.u64(serializer, self.maxEpoch)
        try serializer.sequence(self.userSignature, Serializer.u8)
    }

    public static func deserialize(from deserializer: Deserializer) throws -> zkLoginSignature {
        return zkLoginSignature(
            inputs: try Deserializer._struct(deserializer),
            maxEpoch: try Deserializer.u64(deserializer),
            userSignature: [UInt8](try Deserializer.toBytes(deserializer))
        )
    }

    /// Serialize the zkLogin signature for transaction submission in MySocial protobuf format
    /// - Returns: Base64 encoded serialized signature
    public func serialize() -> String {
        let serializer = Serializer()
        do {
            print("🔧 [BLOCKCHAIN SUBMIT] Serializing zkLogin signature in MySocial protobuf format...")
            
            // Serialize proof points in MySocial protobuf format
            try serializeProtobufProofPoints(serializer, proofPoints: self.inputs.proofPoints)
            
            // Serialize issBase64Details
            try Serializer._struct(serializer, value: self.inputs.issBase64Details)
            
            // Serialize headerBase64
            try Serializer.str(serializer, self.inputs.headerBase64)
            
            // Serialize addressSeed as 32-byte protobuf field element
            try serializeProtobufAddressSeed(serializer, addressSeed: self.inputs.addressSeed)
            
            // Serialize maxEpoch
            try Serializer.u64(serializer, self.maxEpoch)
            
            // Serialize userSignature
            try serializer.sequence(self.userSignature, Serializer.u8)
            
            let bytes = serializer.output()
            print("✅ [BLOCKCHAIN SUBMIT] Successfully serialized in MySocial protobuf format")

            // Create result with signature scheme flag (0x05) as first byte
            var signatureBytes = Data(count: bytes.count + 1)
            signatureBytes[0] = SignatureSchemeFlags.SIGNATURE_SCHEME_TO_FLAG["zkLogin"]!
            signatureBytes[1..<(bytes.count + 1)] = bytes

            return signatureBytes.base64EncodedString()
            
        } catch {
            print("❌ [BLOCKCHAIN SUBMIT] Protobuf serialization failed: \(error)")
            return Data().base64EncodedString() // Return empty signature in case of error
        }
    }
    
    /// Serialize proof points in MySocial protobuf format (32-byte big-endian field elements)
    private func serializeProtobufProofPoints(_ serializer: Serializer, proofPoints: zkLoginSignatureInputsProofPoints) throws {
        print("🔧 [PROTOBUF] Converting proof points to 32-byte big-endian format...")
        
        // Serialize a points (CircomG1)
        for decimalString in proofPoints.a {
            let fieldElement = try decimalStringTo32ByteArray(decimalString)
            try serializer.sequence(fieldElement, Serializer.u8)
        }
        
        // Serialize b points (CircomG2) 
        for pointPair in proofPoints.b {
            for decimalString in pointPair {
                let fieldElement = try decimalStringTo32ByteArray(decimalString)
                try serializer.sequence(fieldElement, Serializer.u8)
            }
        }
        
        // Serialize c points (CircomG1)
        for decimalString in proofPoints.c {
            let fieldElement = try decimalStringTo32ByteArray(decimalString)
            try serializer.sequence(fieldElement, Serializer.u8)
        }
        
        print("✅ [PROTOBUF] Proof points converted to 32-byte format")
    }
    
    /// Serialize address seed in MySocial protobuf format (32-byte big-endian field element)
    private func serializeProtobufAddressSeed(_ serializer: Serializer, addressSeed: String) throws {
        print("🔧 [PROTOBUF] Converting address seed to 32-byte big-endian format...")
        let fieldElement = try decimalStringTo32ByteArray(addressSeed)
        try serializer.sequence(fieldElement, Serializer.u8)
        print("✅ [PROTOBUF] Address seed converted to 32-byte format")
    }
    
    /// Convert decimal string to 32-byte big-endian byte array
    private func decimalStringTo32ByteArray(_ decimalString: String) throws -> [UInt8] {
        // Handle the special case of "1" and "0"
        if decimalString == "1" {
            var bytes = [UInt8](repeating: 0, count: 32)
            bytes[31] = 1
            return bytes
        } else if decimalString == "0" {
            return [UInt8](repeating: 0, count: 32)
        }
        
        // For larger numbers, we need proper big integer conversion
        // For now, use a simplified approach for UInt64 range
        guard let value = UInt64(decimalString) else {
            throw MySoError.customError(message: "Cannot convert decimal string to UInt64: \(decimalString)")
        }
        
        var bytes = [UInt8](repeating: 0, count: 32)
        var tempValue = value
        
        // Fill bytes from right to left (big-endian)
        for i in (0..<8).reversed() {
            bytes[24 + i] = UInt8(tempValue & 0xFF)
            tempValue >>= 8
        }
        
        return bytes
    }

    /// Parse a serialized zkLogin signature string
    /// - Parameter serialized: Base64 encoded signature string
    /// - Returns: A zkLoginSignature instance
    public static func parse(serialized: String) throws -> zkLoginSignature {
        guard let data = Data(base64Encoded: serialized) else {
            throw MySoError.customError(message: "Failed to decode base64 signature")
        }

        // Verify signature prefix byte is correct (0x05 for zkLogin)
        guard data[0] == SignatureSchemeFlags.SIGNATURE_SCHEME_TO_FLAG["zkLogin"] else {
            throw MySoError.customError(message: "Invalid signature scheme flag")
        }

        // Skip the flag byte
        let signatureBytes = data.subdata(in: 1..<data.count)

        let deserializer = Deserializer(data: signatureBytes)

        // Deserialize the proof points structure
        let proofPoints = try zkLoginSignatureInputsProofPoints.deserialize(from: deserializer)

        // Deserialize issBase64Details
        let issBase64Details = try zkLoginSignatureInputsClaim.deserialize(from: deserializer)

        // Read headerBase64
        let headerBase64 = try Deserializer.string(deserializer)

        // Read addressSeed
        let addressSeed = try Deserializer.string(deserializer)

        // Create inputs struct
        let inputs = zkLoginSignatureInputs(
            proofPoints: proofPoints,
            issBase64Details: issBase64Details,
            headerBase64: headerBase64,
            addressSeed: addressSeed
        )

        // Read maxEpoch
        let maxEpoch = try Deserializer.u64(deserializer)

        // Read userSignature bytes
        let userSignature = try Deserializer.toBytes(deserializer)

        return zkLoginSignature(
            inputs: inputs,
            maxEpoch: maxEpoch,
            userSignature: [UInt8](userSignature)
        )
    }

    /// Verify this zkLogin signature against transaction data
    /// The verification must be performed externally as it requires GraphQL access
    /// - Parameters:
    ///   - transactionData: The transaction data to verify
    /// - Returns: True if verification can be initiated, but actual verification must be done externally
    public func verify(transactionData: [UInt8]) -> Bool {
        // This is just a placeholder - actual verification requires GraphQL
        // This simply confirms that we have all the necessary signature components
        return !self.serialize().isEmpty && !transactionData.isEmpty
    }

    /// Serialize a zkLogin signature to a string
    /// - Parameter signature: The signature to serialize
    /// - Returns: A serialized string representation
    public static func serialize(signature: zkLoginSignature) -> String {
        return signature.serialize()
    }
}

/// Default implementation of GraphQLClient
public class MySoGraphQLClient: GraphQLClientProtocol {
    private let url: URL
    private let session: URLSession

    public init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    public func verifyZkLoginSignature(
        bytes: String,
        signature: String,
        intentScope: ZkLoginIntentScope,
        author: String
    ) async throws -> ZkLoginVerifyResult {
        // Construct GraphQL query matching the schema
        let query = """
        query verifyZkLoginSignature($bytes: Base64!, $signature: Base64!, $intentScope: ZkLoginIntentScope!, $author: MysAddress!) {
          verifyZkloginSignature(
            bytes: $bytes,
            signature: $signature,
            intentScope: $intentScope,
            author: $author
          ) {
            success
            errors
          }
        }
        """

        // Create variables for the query
        let variables: [String: Any] = [
            "bytes": bytes,
            "signature": signature,
            "intentScope": intentScope.rawValue,
            "author": author
        ]

        // Create request body
        let requestBody: [String: Any] = [
            "query": query,
            "variables": variables
        ]

        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        // Send request
        let (data, response) = try await session.data(for: request)

        // Check response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MySoError.customError(message: "GraphQL request failed")
        }

        // Parse response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw MySoError.customError(message: "Invalid JSON response")
        }

        // Check for GraphQL errors first
        if let errors = json["errors"] as? [[String: Any]], !errors.isEmpty {
            let errorMessages = errors.compactMap { $0["message"] as? String }
            throw MySoError.customError(message: "GraphQL errors: \(errorMessages.joined(separator: ", "))")
        }

        // Extract verification result
        guard let dataJson = json["data"] as? [String: Any],
              let verifyResult = dataJson["verifyZkloginSignature"] as? [String: Any],
              let success = verifyResult["success"] as? Bool else {
            throw MySoError.customError(message: "Invalid GraphQL response format")
        }

        let errors = (verifyResult["errors"] as? [String]) ?? []

        return ZkLoginVerifyResult(success: success, errors: errors)
    }
}
