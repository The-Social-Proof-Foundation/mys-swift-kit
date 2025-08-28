//
//  MySoMoveNormalizedModule.swift
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

/// Represents a normalized MySoMove Module, containing various details about the module including its address,
/// name, friend modules, structs, and exposed functions.
public struct MySoMoveNormalizedModule: Equatable {
    /// Specifies the file format version of the module.
    public let fileFormatVersion: Int

    /// The address where the module is located.
    public let address: String

    /// The name of the module.
    public let name: String

    /// An array of `MySoMoveModuleId` representing the friend modules of this module.
    public let friends: [MySoMoveModuleId]

    /// A dictionary containing the structs present in the module, where the key is the name of the struct and the value is an instance of `MySoMoveNormalizedStruct`.
    public let structs: [String: MySoMoveNormalizedStruct]

    /// A dictionary containing the exposed functions of the module, where the key is the name of the function and the value is an instance of `MySoMoveNormalizedFunction`.
    public let exposedFunctions: [String: MySoMoveNormalizedFunction]

    public init(graphql: GetNormalizedMoveModuleQuery.Data.Object.AsMovePackage.Module, package: String) {
        let module = graphql
        var structs: [String: MySoMoveNormalizedStruct] = [:]
        var exposedFunctions: [String: MySoMoveNormalizedFunction] = [:]

        if let structures = module.structs {
            for structure in structures.nodes {
                structs[structure.name] = MySoMoveNormalizedStruct(
                    structure: structure
                )
            }
        }

        if let functions = module.functions {
            for function in functions.filterUsable() {
                if let value = MySoMoveNormalizedFunction(function: function) {
                    exposedFunctions[function.name] = value
                }
            }
        }

        self.fileFormatVersion = module.fileFormatVersion
        self.address = package
        self.name = module.name
        self.friends = module.friends.nodes.map {
            MySoMoveModuleId(address: $0.package.address, name: $0.name)
        }
        self.structs = structs
        self.exposedFunctions = exposedFunctions
    }

    public init(graphql: GetNormalizedMoveModulesByPackageQuery.Data.Object.AsMovePackage.Modules.Node, package: String) {
        let module = graphql
        var structs: [String: MySoMoveNormalizedStruct] = [:]
        var exposedFunctions: [String: MySoMoveNormalizedFunction] = [:]

        if let structures = module.structs {
            for structure in structures.nodes {
                structs[structure.name] = MySoMoveNormalizedStruct(
                    structure: structure
                )
            }
        }

        if let functions = module.functions {
            for function in functions.filterUsable() {
                if let value = MySoMoveNormalizedFunction(function: function) {
                    exposedFunctions[function.name] = value
                }
            }
        }

        self.fileFormatVersion = module.fileFormatVersion
        self.address = package
        self.name = module.name
        self.friends = module.friends.nodes.map {
            MySoMoveModuleId(address: $0.package.address, name: $0.name)
        }
        self.structs = structs
        self.exposedFunctions = exposedFunctions
    }

    /// Initializes a new instance of `MySoMoveNormalizedModule` from a JSON representation.
    /// Returns `nil` if there is an issue with the JSON input.
    ///
    /// - Parameter input: A JSON representation of a `MySoMoveNormalizedModule`.
    public init?(input: JSON) {
        var structs: [String: MySoMoveNormalizedStruct] = [:]
        var exposedFunctions: [String: MySoMoveNormalizedFunction] = [:]

        for (structKey, structValue) in input["structs"].dictionaryValue {
            structs[structKey] = MySoMoveNormalizedStruct(input: structValue)
        }

        for (exposedKey, exposedValue) in input["exposedFunctions"].dictionaryValue {
            if
                (exposedValue["visibility"].stringValue == "Friend" || exposedValue["visibility"].stringValue == "Public") ||
                (exposedValue["isEntry"].boolValue) {
                exposedFunctions[exposedKey] = MySoMoveNormalizedFunction(input: exposedValue)
            }
        }

        self.fileFormatVersion = input["fileFormatVersion"].intValue
        self.address = input["address"].stringValue
        self.name = input["name"].stringValue
        self.friends = input["friends"].arrayValue.map {
            MySoMoveModuleId(
                address: $0["address"].stringValue,
                name: $0["name"].stringValue
            )
        }
        self.structs = structs
        self.exposedFunctions = exposedFunctions
    }
}
