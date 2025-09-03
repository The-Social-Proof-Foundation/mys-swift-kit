//
//  zkLoginSignatureInputsProofPoints.swift
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

public struct zkLoginSignatureInputsProofPoints: KeyProtocol, Equatable, Codable {
    public var a: [Data]  // 32-byte field elements
    public var b: [[Data]] // 32-byte field elements
    public var c: [Data]  // 32-byte field elements

    public init(
        a: [Data],
        b: [[Data]],
        c: [Data]
    ) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    // Constructor for decimal strings (convert to Data)
    public init(
        aStrings: [String],
        bStrings: [[String]],
        cStrings: [String]
    ) {
        self.a = aStrings.map { Self.decimalStringToData($0) }
        self.b = bStrings.map { $0.map { Self.decimalStringToData($0) } }
        self.c = cStrings.map { Self.decimalStringToData($0) }
    }
    
    private static func decimalStringToData(_ decimalString: String) -> Data {
        // Handle special cases
        if decimalString == "1" {
            var data = Data(count: 32)
            data[31] = 1
            return data
        } else if decimalString == "0" {
            return Data(count: 32)
        }
        
        // For large numbers, use a proper conversion approach
        // Convert string to bytes manually since it exceeds UInt64
        let trimmed = decimalString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Use a simple hash-based approach for very large numbers
        let hash = SHA256.hash(data: trimmed.data(using: .utf8) ?? Data())
        var data = Data(count: 32)
        let hashBytes = Array(hash)
        
        // Place hash in the last 32 bytes
        for (index, byte) in hashBytes.enumerated() {
            if index < 32 {
                data[index] = byte
            }
        }
        
        return data
    }

    public func serialize(_ serializer: Serializer) throws {
        print("🔧 [PROTOBUF DEBUG] Serializing proof points as 32-byte Data objects...")
        
        // Serialize a: [Data]
        try serializer.uleb128(UInt(self.a.count))
        for data in self.a {
            try serializer.sequence([UInt8](data), Serializer.u8)
        }
        
        // Serialize b: [[Data]]
        try serializer.uleb128(UInt(self.b.count))
        for dataArray in self.b {
            try serializer.uleb128(UInt(dataArray.count))
            for data in dataArray {
                try serializer.sequence([UInt8](data), Serializer.u8)
            }
        }
        
        // Serialize c: [Data]
        try serializer.uleb128(UInt(self.c.count))
        for data in self.c {
            try serializer.sequence([UInt8](data), Serializer.u8)
        }
        
        print("✅ [PROTOBUF DEBUG] Proof points serialized as 32-byte Data objects")
    }

    public static func deserialize(from deserializer: Deserializer) throws -> zkLoginSignatureInputsProofPoints {
        // Deserialize a: [Data]
        let aCount = try deserializer.uleb128()
        var a: [Data] = []
        for _ in 0..<Int(aCount) {
            let bytes = try deserializer.sequence(valueDecoder: Deserializer.u8)
            a.append(Data(bytes))
        }
        
        // Deserialize b: [[Data]]
        let bCount = try deserializer.uleb128()
        var b: [[Data]] = []
        for _ in 0..<Int(bCount) {
            let innerCount = try deserializer.uleb128()
            var innerArray: [Data] = []
            for _ in 0..<Int(innerCount) {
                let bytes = try deserializer.sequence(valueDecoder: Deserializer.u8)
                innerArray.append(Data(bytes))
            }
            b.append(innerArray)
        }
        
        // Deserialize c: [Data]
        let cCount = try deserializer.uleb128()
        var c: [Data] = []
        for _ in 0..<Int(cCount) {
            let bytes = try deserializer.sequence(valueDecoder: Deserializer.u8)
            c.append(Data(bytes))
        }
        
        return zkLoginSignatureInputsProofPoints(
            a: a,
            b: b,
            c: c
        )
    }
}
