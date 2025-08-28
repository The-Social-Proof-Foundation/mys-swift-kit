//
//  MySoMoveNormalizedStructType.swift
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

/// Represents a normalized MySoMove Struct Type, providing details about the struct including its address,
/// module, name, and type arguments.
public struct MySoMoveNormalizedStructType: Equatable, KeyProtocol, CustomStringConvertible {
    /// An `AccountAddress` representing the address of the struct.
    public let address: AccountAddress

    /// A `String` representing the module where the struct is defined.
    public let module: String

    /// A `String` representing the name of the struct.
    public let name: String

    /// An array of `MySoMoveNormalizedType` representing the type arguments of the struct.
    public let typeArguments: [MySoMoveNormalizedType]

    /// Initializes a new instance of `MySoMoveNormalizedStructType`.
    ///
    /// - Parameters:
    ///   - address: An `AccountAddress` representing the address of the struct.
    ///   - module: A `String` representing the module where the struct is defined.
    ///   - name: A `String` representing the name of the struct.
    ///   - typeArguments: An array of `MySoMoveNormalizedType` representing the type arguments of the struct.
    public init(
        address: AccountAddress,
        module: String,
        name: String,
        typeArguments: [MySoMoveNormalizedType]
    ) {
        self.address = address
        self.module = module
        self.name = name
        self.typeArguments = typeArguments
    }

    /// Initializes a new instance of `MySoMoveNormalizedStructType` from a string input.
    ///
    /// - Parameter input: A `String` representation of a `MySoMoveNormalizedStructType`.
    /// - Throws: An error if the initialization fails.
    public init(input: String) throws {
        let typeTag = try StructTag.fromStr(input)
        self.address = typeTag.value.address
        self.module = typeTag.value.module
        self.name = typeTag.value.name
        self.typeArguments = []
    }

    /// Initializes a new instance of `MySoMoveNormalizedStructType` from a JSON representation.
    /// Returns `nil` if there is an issue with the JSON input.
    ///
    /// - Parameter input: A JSON representation of a `MySoMoveNormalizedStructType`.
    public init?(input: JSON) {
        guard let address = try? AccountAddress.fromHex(
            input["address"].stringValue
        ) else { return nil }

        self.address = address
        self.module = input["module"].stringValue
        self.name = input["name"].stringValue
        self.typeArguments = input["typeArguments"].arrayValue.compactMap {
            MySoMoveNormalizedType.parseJSON($0)
        }
    }

    public init?(graphQLInput: JSON) {
        guard let address = try? AccountAddress.fromHex(
            graphQLInput["package"].stringValue
        ) else { return nil }

        self.address = address
        self.module = graphQLInput["module"].stringValue
        self.name = graphQLInput["type"].stringValue
        self.typeArguments = graphQLInput["typeParameters"].arrayValue.compactMap {
            MySoMoveNormalizedType.parseGraphQLInner(nil, $0)
        }
    }

    public var description: String {
        "\(self.address.hex())::\(self.module)::\(self.name)" + (self.typeArguments.isEmpty ? "" : "<\(self.typeArguments.map { "\($0), " })>")
    }

    public static func ==(lhs: MySoMoveNormalizedStructType, rhs: MySoMoveNormalizedStructType) -> Bool {
        return
            lhs.address == rhs.address &&
            lhs.module == rhs.module &&
            lhs.name == rhs.name &&
            lhs.typeArguments == rhs.typeArguments
    }

    /// Compares the current struct with another to determine if they are of the same struct.
    ///
    /// - Parameter rhs: The `any ResolvedProtocol` to compare the current struct with.
    /// - Returns: A `Bool` indicating whether the two structs are the same.
    public func isSameStruct(_ rhs: any ResolvedProtocol) -> Bool {
        guard let rhsAddress = try? Inputs.normalizeMySoAddress(
            value: rhs.address
        ) else { return false }
        return
            self.address.hex() == rhsAddress &&
            self.module == rhs.module &&
            self.name == rhs.name
    }

    public func serialize(_ serializer: Serializer) throws {
        try Serializer._struct(serializer, value: self.address)
        try Serializer.str(serializer, self.module)
        try Serializer.str(serializer, self.name)
        if !self.typeArguments.isEmpty {
            try serializer.sequence(
                self.typeArguments,
                Serializer._struct
            )
        }
    }

    public static func deserialize(
        from deserializer: Deserializer
    ) throws -> MySoMoveNormalizedStructType {
        return MySoMoveNormalizedStructType(
            address: try Deserializer._struct(deserializer),
            module: try Deserializer.string(deserializer),
            name: try Deserializer.string(deserializer),
            typeArguments: []
        )
    }
}
