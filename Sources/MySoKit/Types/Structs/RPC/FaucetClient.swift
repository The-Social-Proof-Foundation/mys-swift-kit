//
//  FaucetClient.swift
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

#if swift(>=6.0)
public struct FaucetClient: Sendable {
    /// A connection conforming to `ConnectionProtocol` to interact with.
    public let connection: any ConnectionProtocol

    /// Initializes a new `FaucetClient` with the given connection.
    /// - Parameter connection: A connection conforming to `ConnectionProtocol`.
    public init(connection: any ConnectionProtocol) {
        self.connection = connection
    }
}
#elseif swift(<6.0)
public struct FaucetClient {
    /// A connection conforming to `ConnectionProtocol` to interact with.
    public let connection: any ConnectionProtocol

    /// Initializes a new `FaucetClient` with the given connection.
    /// - Parameter connection: A connection conforming to `ConnectionProtocol`.
    public init(connection: any ConnectionProtocol) {
        self.connection = connection
    }
}
#endif

public extension FaucetClient {
    /// Requests coin info for the given account address from the faucet.
    /// - Parameter address: The account address to request coin info for.
    /// - Returns: A `FaucetCoinInfo` object containing details about the transferred coins.
    /// - Throws:
    ///     - `MySoError.faucetUrlRequired` if the faucet URL is not available in the connection.
    ///     - `MySoError.invalidUrl` if the faucet URL is invalid.
    ///     - `MySoError.faucetRateLimitError` if the request is rate limited.
    ///     - `MySoError.invalidJsonData` if the received JSON data is invalid.
    func funcAccount(_ address: String) async throws -> FaucetCoins {
        guard let baseUrl = connection.faucet else {
            throw MySoError.customError(message: "Faucet URL required")
        }

        guard let url = URL(string: baseUrl) else {
            throw MySoError.customError(message: "Invalid URL: \(baseUrl)")
        }

        let data: [String: Any] = [
            "FixedAmountRequest": [
                "recipient": address
            ]
        ]

        do {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: data)
            request.httpMethod = "POST"

            let result = try await URLSession.shared.asyncData(with: request)
            let coins = try JSONDecoder().decode(FaucetCoins.self, from: result)

            return coins
        } catch {
            throw MySoError.customError(message: "\(error.localizedDescription)")
        }
    }
}
