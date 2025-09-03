//
//  zkLoginSignatureInputs.swift
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
import CryptoKit

/// Represents the inputs for a zkLogin signature
public struct zkLoginSignatureInputs: KeyProtocol, Equatable, Codable {
    public var proofPoints: zkLoginSignatureInputsProofPoints
    public var issBase64Details: zkLoginSignatureInputsClaim
    public var headerBase64: String
    public var addressSeed: Data  // Changed from String to Data for large numbers

    public init(
        proofPoints: zkLoginSignatureInputsProofPoints,
        issBase64Details: zkLoginSignatureInputsClaim,
        headerBase64: String,
        addressSeed: Data
    ) {
        self.proofPoints = proofPoints
        self.issBase64Details = issBase64Details
        self.headerBase64 = headerBase64
        self.addressSeed = addressSeed
    }
    
    // Constructor for string addressSeed (convert to Data)
    public init(
        proofPoints: zkLoginSignatureInputsProofPoints,
        issBase64Details: zkLoginSignatureInputsClaim,
        headerBase64: String,
        addressSeedString: String
    ) {
        self.proofPoints = proofPoints
        self.issBase64Details = issBase64Details
        self.headerBase64 = headerBase64
        self.addressSeed = Self.addressSeedStringToData(addressSeedString)
    }
    
    private static func addressSeedStringToData(_ addressSeed: String) -> Data {
        // Convert large decimal string to 32-byte Data using hash
        let hash = SHA256.hash(data: addressSeed.data(using: .utf8) ?? Data())
        var data = Data(count: 32)
        let hashBytes = Array(hash)
        
        for (index, byte) in hashBytes.enumerated() {
            if index < 32 {
                data[index] = byte
            }
        }
        
        return data
    }

    public func serialize(_ serializer: Serializer) throws {
        print("🔧 [INPUTS DEBUG] zkLoginSignatureInputs.serialize() called")
        print("🔧 [INPUTS DEBUG] About to serialize proof points...")
        try Serializer._struct(serializer, value: self.proofPoints)
        print("✅ [INPUTS DEBUG] Proof points serialized")
        
        print("🔧 [INPUTS DEBUG] About to serialize issBase64Details...")
        try Serializer._struct(serializer, value: self.issBase64Details)
        print("✅ [INPUTS DEBUG] issBase64Details serialized")
        
        print("🔧 [INPUTS DEBUG] About to serialize headerBase64...")
        try Serializer.str(serializer, self.headerBase64)
        print("✅ [INPUTS DEBUG] headerBase64 serialized")
        
        print("🔧 [INPUTS DEBUG] About to serialize addressSeed as 32-byte Data...")
        // Serialize addressSeed as 32-byte Data directly
        try serializer.sequence([UInt8](self.addressSeed), Serializer.u8)
        print("✅ [INPUTS DEBUG] addressSeed serialized as 32-byte Data")
        print("✅ [INPUTS DEBUG] zkLoginSignatureInputs.serialize() completed")
    }

    public static func deserialize(from deserializer: Deserializer) throws -> zkLoginSignatureInputs {
        let proofPoints = try zkLoginSignatureInputsProofPoints.deserialize(from: deserializer)
        let issBase64Details = try zkLoginSignatureInputsClaim.deserialize(from: deserializer)
        let headerBase64 = try Deserializer.string(deserializer)
        let addressSeedBytes = try deserializer.sequence(valueDecoder: Deserializer.u8)
        let addressSeed = Data(addressSeedBytes)
        
        return zkLoginSignatureInputs(
            proofPoints: proofPoints,
            issBase64Details: issBase64Details,
            headerBase64: headerBase64,
            addressSeed: addressSeed
        )
    }
}
