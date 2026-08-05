//
//  MakeMoveVecTransaction.swift
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
import SwiftyJSON

public struct MakeMoveVecTransaction: KeyProtocol, TransactionProtocol {
    /// An array of TransactionArguments representing objects involved in the transaction.
    public let objects: [TransactionArgument]

    /// Optional element TypeTag. Required for pure (non-object) elements such as `address`.
    public let typeTag: TypeTag?

    /// Initializes a new instance of `MakeMoveVecTransaction`.
    /// - Parameters:
    ///   - objects: An array of `TransactionArgument` representing objects in the transaction.
    ///   - type: A string TypeTag (`address`, `u64`, `0x2::coin::Coin<…>`, …).
    /// - Throws: If initialization fails due to type conversion.
    public init(objects: [TransactionArgument], type: String?) throws {
        self.objects = objects
        if let type = type {
            let trimmed = type.trimmingCharacters(in: .whitespacesAndNewlines)
            self.typeTag = trimmed.isEmpty ? nil : try TypeTag(stringValue: trimmed)
        } else {
            self.typeTag = nil
        }
    }

    /// Initializes a new instance of `MakeMoveVecTransaction`.
    /// - Parameters:
    ///   - objects: An array of `TransactionArgument` representing objects in the transaction.
    ///   - typeTag: An optional element `TypeTag`.
    public init(objects: [TransactionArgument], typeTag: TypeTag?) {
        self.objects = objects
        self.typeTag = typeTag
    }

    /// Initializes a new instance of `MakeMoveVecTransaction` from JSON.
    /// - Parameter input: The JSON object used for initialization.
    /// - Returns: An optional instance of `MakeMoveVecTransaction`.
    public init?(input: JSON) {
        let vec = input.arrayValue
        self.objects = vec[0].arrayValue.compactMap { TransactionArgument.fromJSON($0) }
        let typeString = vec.count > 1 ? vec[1].stringValue : ""
        if typeString.isEmpty {
            self.typeTag = nil
        } else {
            self.typeTag = try? TypeTag(stringValue: typeString)
        }
    }

    public func serialize(_ serializer: Serializer) throws {
        // BCS: MakeMoveVec { type: Option<TypeTag>, objects: Vec<Argument> }
        try serializer._optional(typeTag) { ser, tag in
            try Serializer._struct(ser, value: tag)
        }
        try serializer.sequence(objects, Serializer._struct)
    }

    public static func deserialize(
        from deserializer: Deserializer
    ) throws -> MakeMoveVecTransaction {
        let typeTag: TypeTag? = try deserializer._optional { try TypeTag.deserialize(from: $0) }
        return MakeMoveVecTransaction(
            objects: try deserializer.sequence(valueDecoder: Deserializer._struct),
            typeTag: typeTag
        )
    }
}
