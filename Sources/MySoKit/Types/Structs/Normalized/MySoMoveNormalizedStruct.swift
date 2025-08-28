//
//  MySoMoveNormalizedStruct.swift
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

/// Represents a normalized MySoMove Struct, containing details about the struct including its abilities,
/// type parameters, and fields.
public struct MySoMoveNormalizedStruct: Equatable {
    /// A `MySoMoveAbilitySet` representing the abilities of the struct.
    public let abilities: MySoMoveAbilitySet

    /// An array of `MySoMoveStructTypeParameter` representing the type parameters of the struct.
    public let typeParameters: [MySoMoveStructTypeParameter]

    /// An array of `MySoMoveNormalizedField` representing the fields within the struct.
    public let fields: [MySoMoveNormalizedField]

    public init(structure: GetNormalizedMoveStructQuery.Data.Object.AsMovePackage.Module.Struct) {
        self.abilities = structure.abilities != nil ?
            MySoMoveAbilitySet(abilities: structure.abilities!.compactMap { $0.value?.rawValue }) :
            MySoMoveAbilitySet(abilities: [])

        self.typeParameters = structure.typeParameters != nil ?
            structure.typeParameters!.map {
                MySoMoveStructTypeParameter(
                    constraints: MySoMoveAbilitySet(abilities: $0.constraints.compactMap { $0.value?.rawValue }),
                    isPhantom: $0.isPhantom
                )
            } :
            []

        self.fields = structure.fields != nil ?
            structure.fields!.map {
                MySoMoveNormalizedField(
                    name: $0.name,
                    type: MySoMoveNormalizedType.parseGraphQL($0.type!.signature)!
                )
            }:
            []
    }

    public init(structure: RPC_MOVE_MODULE_FIELDS.Structs.Node) {
        self.abilities = structure.abilities != nil ?
            MySoMoveAbilitySet(abilities: structure.abilities!.compactMap { $0.value?.rawValue }) :
            MySoMoveAbilitySet(abilities: [])

        self.typeParameters = structure.typeParameters != nil ?
            structure.typeParameters!.map {
                MySoMoveStructTypeParameter(
                    constraints: MySoMoveAbilitySet(abilities: $0.constraints.compactMap { $0.value?.rawValue }),
                    isPhantom: $0.isPhantom
                )
            } :
            []

        self.fields = structure.fields != nil ?
            structure.fields!.map {
                MySoMoveNormalizedField(
                    name: $0.name,
                    type: MySoMoveNormalizedType.parseGraphQL($0.type!.signature)!
                )
            }:
            []
    }

    /// Initializes a new instance of `MySoMoveNormalizedStruct`.
    ///
    /// - Parameters:
    ///   - abilities: A `MySoMoveAbilitySet` representing the abilities of the struct.
    ///   - typeParameters: An array of `MySoMoveStructTypeParameter` representing the type parameters of the struct.
    ///   - fields: An array of `MySoMoveNormalizedField` representing the fields within the struct.
    public init(
        abilities: MySoMoveAbilitySet,
        typeParameters: [MySoMoveStructTypeParameter],
        fields: [MySoMoveNormalizedField]
    ) {
        self.abilities = abilities
        self.typeParameters = typeParameters
        self.fields = fields
    }

    /// Initializes a new instance of `MySoMoveNormalizedStruct` from a JSON representation.
    /// Returns `nil` if there is an issue with the JSON input.
    ///
    /// - Parameter input: A JSON representation of a `MySoMoveNormalizedStruct`.
    public init?(input: JSON) {
        let typeParameters = input["typeParameters"].arrayValue
        let fields = input["fields"].arrayValue

        self.abilities = MySoMoveAbilitySet(input: input["abilities"])

        self.typeParameters = typeParameters.map {
            MySoMoveStructTypeParameter(
                constraints: MySoMoveAbilitySet(
                    abilities: $0["isPhantom"]["abilities"].arrayValue.map { $0.stringValue }
                ),
                isPhantom: $0["isPhantom"].boolValue
            )
        }

        var fieldsOutput: [MySoMoveNormalizedField] = []

        for field in fields {
            guard let type = MySoMoveNormalizedType.parseJSON(field["type"]) else { return nil }
            fieldsOutput.append(MySoMoveNormalizedField(
                name: field["name"].stringValue,
                type: type
            ))
        }

        self.fields = fieldsOutput
    }
}
