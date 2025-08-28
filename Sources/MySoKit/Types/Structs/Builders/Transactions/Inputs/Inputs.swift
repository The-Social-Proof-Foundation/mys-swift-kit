//
//  Inputs.swift
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

public struct Inputs {
    /// Creates a `PureCallArg` object from the provided `Data`.
    ///
    /// - Parameter data: The `Data` instance used to initialize the `PureCallArg` object.
    /// - Returns: A `PureCallArg` object initialized with the provided data.
    public static func pure(data: Data) -> PureCallArg {
        return PureCallArg(value: data)
    }

    /// Creates a `PureCallArg` object from the provided `MySoJsonValue`.
    ///
    /// - Parameter json: The `MySoJsonValue` used to initialize the `PureCallArg` object.
    /// - Throws: If unable to serialize the provided `json` value.
    /// - Returns: A `PureCallArg` object initialized with the serialized output of the provided JSON value.
    public static func pure(json: MySoJsonValue) throws -> PureCallArg {
        let ser = Serializer()
        try Serializer._struct(ser, value: json)
        return PureCallArg(value: ser.output())
    }

    /// Creates an `ObjectArg` of type `.immOrOwned` from the provided `MySoObjectRef`.
    ///
    /// - Parameter mysoObjectRef: The `MySoObjectRef` used to initialize the `ObjectArg`.
    /// - Throws: If unable to normalize the MYS address contained in `mysoObjectRef`.
    /// - Returns: An `ObjectArg` object initialized with the `.immOrOwned` variant.
    public static func immOrOwnedRef(mysoObjectRef: MySoObjectRef) throws -> ObjectArg {
        let immOrOwned = ImmOrOwned(
            ref: MySoObjectRef(
                objectId: try normalizeMySoAddress(value: mysoObjectRef.objectId),
                version: mysoObjectRef.version,
                digest: mysoObjectRef.digest
            )
        )
        return .immOrOwned(immOrOwned)
    }

    /// Creates an `ObjectArg` of type `.shared` from the provided `SharedObjectRef`.
    ///
    /// - Parameter sharedObjectRef: The `SharedObjectRef` used to initialize the `ObjectArg`.
    /// - Throws: If unable to normalize the MYS address contained in `sharedObjectRef`.
    /// - Returns: An `ObjectArg` object initialized with the `.shared` variant.
    public static func sharedObjectRef(sharedObjectRef: SharedObjectRef) throws -> ObjectArg {
        let sharedArg = try SharedObjectArg(
            objectId: normalizeMySoAddress(value: sharedObjectRef.objectId),
            initialSharedVersion: sharedObjectRef.initialSharedVersion,
            mutable: sharedObjectRef.mutable
        )
        return .shared(sharedArg)
    }

    /// Overload that creates an `ObjectArg` of type `.shared` from the provided `SharedObjectArg`.
    ///
    /// - Parameter sharedObjectArg: The `SharedObjectArg` used to initialize the `ObjectArg`.
    /// - Returns: An `ObjectArg` object initialized with the `.shared` variant.
    public static func sharedObjectRef(sharedObjectArg: SharedObjectArg) -> ObjectArg {
        return .shared(sharedObjectArg)
    }

    /// Normalizes the MYS address from the provided `objectId`.
    ///
    /// - Parameter arg: The `objectId` to be normalized.
    /// - Throws: If unable to normalize the provided `objectId`.
    /// - Returns: A normalized MYS address as a string.
    public static func getIdFromCallArg(arg: ObjectId) throws -> String {
        return try normalizeMySoAddress(value: arg)
    }

    public static func getIdFromCallArg(arg: ObjectCallArg) throws -> String {
        if case .immOrOwned(let immOrOwned) = arg.object {
            return try normalizeMySoAddress(value: immOrOwned.ref.objectId)
        }

        if case .shared(let shared) = arg.object {
            return try normalizeMySoAddress(value: shared.objectId)
        }

        throw MySoError.notImplemented
    }

    /// Normalizes the MYS address from the provided `ObjectArg`.
    ///
    /// - Parameter arg: The `ObjectArg` instance containing the address to be normalized.
    /// - Throws: If unable to normalize the address contained in `arg`.
    /// - Returns: A normalized MYS address as a string.
    public static func getIdFromCallArg(arg: ObjectArg) throws -> String {
        switch arg {
        case .immOrOwned(let immOwned):
            return try normalizeMySoAddress(value: immOwned.ref.objectId)
        case .shared(let shared):
            return try normalizeMySoAddress(value: shared.objectId)
        }
    }

    public static func getIdFromCallArg(value: TransactionObjectInput) throws -> String {
        if case .objectCallArg(let objCallArg) = value {
            return try Self.getIdFromCallArg(arg: objCallArg)
        }
        if case .string(let string) = value {
            return try Self.normalizeMySoAddress(value: string)
        }
        throw MySoError.notImplemented
    }

    /// The constant value defining the length of a MYS address.
    public static let mysoAddressLength = 32

    /// The constant value defining the maximum length of a pure argument.
    public static let maxPureArgumentLength = 16 * 1024

    /// Normalizes a MYS address value.
    ///
    /// - Parameters:
    ///   - value: The string value to be normalized.
    ///   - forceAdd0x: If `true`, forcibly adds "0x" prefix to the address, if not already present.
    /// - Throws: `MySoError.addressTooLong` if the input address is too long.
    /// - Returns: A string representing the normalized MYS address.
    public static func normalizeMySoAddress(value: String, forceAdd0x: Bool = false) throws -> String {
        var address = value.lowercased()
        if !forceAdd0x && address.hasPrefix("0x") {
            address = String(address.dropFirst(2))
        }
        guard address.count <= (Self.mysoAddressLength * 2) else { throw MySoError.customError(message: "Address too long (max \(Self.mysoAddressLength * 2) characters)") }
        return "0x" + String().padding(toLength: ((Self.mysoAddressLength * 2) - address.count), withPad: "0", startingAt: 0) + address
    }
}
