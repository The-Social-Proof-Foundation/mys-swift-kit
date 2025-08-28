//
//  Coin.swift
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

/// Represents the properties and functionalities of a coin in the MySocial ecosystem.
public struct Coin {
    /// Represents the MySocial system address.
    public static let mysoSystemAddress = "0x3"

    /// Represents the MySocial framework address.
    public static let mysoFrameworkAddress = "0x2"

    /// Represents the address for the move standard library.
    public static let moveStandardLibraryAddress = "0x1"

    /// Module name for objects.
    public static let objectModuleName = "object"

    /// Struct name for UID.
    public static let uidStructName = "UID"

    /// Struct name for ID.
    public static let idStructName = "ID"

    /// Type argument for MYS.
    public static let mysoTypeArg = "0x2::mys::MYS"

    /// Query for validators event.
    public static let validatorsEventQuery = "0x3::validator_set::ValidatorEpochInfoEventV2"

    /// Object ID for the MYS clock.
    public static let mysoClockObjectId: String = "0x6"

    /// Module name for payments.
    public static let payModuleName = "pay"

    /// Function name for splitting a coin vector.
    public static let paySplitCoinVecFuncName = "split_vec"

    /// Function name for joining coins.
    public static let payJoinCoinFuncName = "join"

    /// Regex to match a coin type argument.
    public static let coinTypeArgRegex = "/^0x2::coin::Coin<(.+)>$/"

    /// Determines if a given `MySoObjectResponse` is a coin.
    /// - Parameter data: The `MySoObjectResponse` to check.
    /// - Returns: `true` if the given data is a coin, otherwise `false`.
    public static func isCoin(data: MySoObjectResponse) -> Bool {
        guard let type = data.data?.type else { return false }

        let regex = try! NSRegularExpression(pattern: Coin.coinTypeArgRegex)
        let range = NSRange(location: 0, length: type.utf16.count)
        let match = regex.firstMatch(in: type, options: [], range: range)

        return match != nil
    }

    /// Determines if a given `MySoObjectResponse` is an MYS coin.
    /// - Parameter data: The `MySoObjectResponse` to check.
    /// - Returns: `true` if the given data is an MYS coin, otherwise `false`.
    public static func isMYS(data: MySoObjectResponse) -> Bool {
        guard let type = data.data?.type else { return false }
        return Coin.getCoinSymbol(coinTypeArg: type) == "MYS"
    }

    /// Retrieves the symbol of the coin from a coin type argument.
    /// - Parameter coinTypeArg: The coin type argument string.
    /// - Returns: The coin symbol string.
    public static func getCoinSymbol(coinTypeArg: String) -> String {
        if let range = coinTypeArg.range(of: ":", options: .backwards) {
            return String(coinTypeArg[range.upperBound...])
        }
        return coinTypeArg
    }

    /// Retrieves the struct tag of a coin from a coin type argument.
    /// - Parameter coinTypeArg: The coin type argument string.
    /// - Throws: If the coin struct tag cannot be determined.
    /// - Returns: The `MySoMoveNormalizedStructType` representing the struct tag of the coin.
    public static func getCoinStructTag(coinTypeArg: String) throws -> MySoMoveNormalizedStructType {
        return MySoMoveNormalizedStructType(
            address: try AccountAddress.fromHex(try Inputs.normalizeMySoAddress(
                value: coinTypeArg.components(separatedBy: "::").first ?? "")
            ),
            module: coinTypeArg.components(separatedBy: "::").dropFirst().first ?? "",
            name: coinTypeArg.components(separatedBy: "::").dropFirst(2).first ?? "",
            typeArguments: []
        )
    }

    /// Calculates the total balance from an array of `CoinStruct`.
    /// - Parameter coins: An array of `CoinStruct` to calculate the total balance from.
    /// - Returns: The total balance as an integer.
    public static func totalBalance(coins: [CoinStruct]) -> Int {
        return coins.reduce(0) { partialResult, coinStruct in
            partialResult + (Int(coinStruct.balance) ?? 0)
        }
    }

    /// Sorts an array of `CoinStruct` by their balance.
    /// - Parameter coins: An array of `CoinStruct` to sort.
    /// - Returns: The sorted array of `CoinStruct`.
    public static func sortByBalance(coins: [CoinStruct]) -> [CoinStruct] {
        return coins.sorted { a, b in
            (Int(a.balance) ?? 0) < (Int(b.balance) ?? 0)
        }
    }
}
