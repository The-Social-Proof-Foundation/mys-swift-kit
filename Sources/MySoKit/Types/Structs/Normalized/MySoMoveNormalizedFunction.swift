//
//  MySoMoveNormalizedFunction.swift
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

/// Represents a normalized function within a MySoMove entity.
public struct MySoMoveNormalizedFunction: Equatable {
    /// Defines the visibility of the function (e.g. public, private).
    public let visibility: MySoMoveVisibility

    /// Indicates whether the function is an entry point to its containing entity.
    public let isEntry: Bool

    /// Holds the ability sets for the function's type parameters, detailing the capabilities of those types.
    public let typeParameters: [MySoMoveAbilitySet]

    /// Represents the types of the parameters that the function can receive.
    public let parameters: [MySoMoveNormalizedType]

    /// Represents the types of the values that the function can return.
    public let returnValues: [MySoMoveNormalizedType]

    public init?(graphql: GetNormalizedMoveFunctionQuery.Data) {
        let function = graphql.object!.asMovePackage!.module!.function!
        guard let visibility = MySoMoveVisibility.parseGraphQL(function.visibility) else { return nil }
        self.visibility = visibility
        self.isEntry = function.isEntry ?? false
        self.typeParameters = function.typeParameters != nil ? function.typeParameters!.compactMap { MySoMoveAbilitySet(graphql: $0) } : []
        self.parameters = function.parameters != nil ? function.parameters!.compactMap { MySoMoveNormalizedType.parseGraphQL($0.signature) } : []
        self.returnValues = function.return != nil ? function.return!.compactMap { MySoMoveNormalizedType.parseGraphQL($0.signature) } : []
    }

    public init?(function: RPC_MOVE_MODULE_FIELDS.Functions.Node) {
        guard let visibility = MySoMoveVisibility.parseGraphQL(function.visibility) else { return nil }
        self.visibility = visibility
        self.isEntry = function.isEntry ?? false
        self.typeParameters = function.typeParameters != nil ? function.typeParameters!.compactMap { MySoMoveAbilitySet(graphql: $0) } : []
        self.parameters = function.parameters != nil ? function.parameters!.compactMap { MySoMoveNormalizedType.parseGraphQL($0.signature) } : []
        self.returnValues = function.return != nil ? function.return!.compactMap { MySoMoveNormalizedType.parseGraphQL($0.signature) } : []
    }

    /// Initializes a new instance of `MySoMoveNormalizedFunction` with the provided parameters.
    ///
    /// - Parameters:
    ///   - visibility: The visibility of the function.
    ///   - isEntry: A boolean value indicating whether the function is an entry point.
    ///   - typeParameters: The ability sets for the type parameters of the function.
    ///   - parameters: The types of the parameters that the function can receive.
    ///   - returnValues: The types of the values that the function can return.
    public init(
        visibility: MySoMoveVisibility,
        isEntry: Bool,
        typeParameters: [MySoMoveAbilitySet],
        parameters: [MySoMoveNormalizedType],
        returnValues: [MySoMoveNormalizedType]
    ) {
        self.visibility = visibility
        self.isEntry = isEntry
        self.typeParameters = typeParameters
        self.parameters = parameters
        self.returnValues = returnValues
    }

    /// Initializes a new instance of `MySoMoveNormalizedFunction` from a JSON representation.
    /// Returns `nil` if there is an issue with the JSON input.
    ///
    /// - Parameter input: A JSON representation of a `MySoMoveNormalizedFunction`.
    public init?(input: JSON) {
        guard let visibility = MySoMoveVisibility.parseJSON(input["visibility"]) else { return nil }
        self.visibility = visibility
        self.isEntry = input["isEntry"].boolValue
        self.typeParameters = input["typeParameters"].arrayValue.map { MySoMoveAbilitySet(input: $0) }
        self.parameters = input["parameters"].arrayValue.compactMap { MySoMoveNormalizedType.parseJSON($0) }
        self.returnValues = input["return"].arrayValue.compactMap { MySoMoveNormalizedType.parseJSON($0) }
    }

    /// Determines if the function has transaction context.
    ///
    /// - Returns: A boolean value indicating whether the function has transaction context.
    /// - Throws: An error if there is an issue determining the transaction context.
    public func hasTxContext() throws -> Bool {
        guard !(self.parameters.isEmpty) else { return false }

        let possiblyTxContext = self.parameters.last!

        guard let structTag = possiblyTxContext.extractStructTag() else { return false }

        return
            try structTag.address.hex() == Inputs.normalizeMySoAddress(value: "0x2") &&
            structTag.module == "tx_context" &&
            structTag.name == "TxContext"
    }
}
