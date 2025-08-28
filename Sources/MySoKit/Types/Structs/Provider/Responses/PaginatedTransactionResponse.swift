//
//  PaginatedTransactionResponse.swift
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

/// Represents a paginated response containing a list of `MySoTransactionBlockResponse` instances,
/// which may represent transaction blocks retrieved from the MySocial blockchain, along with
/// pagination information.
public struct PaginatedTransactionResponse {
    /// An array of `MySoTransactionBlockResponse` instances, each representing the response
    /// for a specific transaction block, possibly containing transaction data.
    public let data: [MySoTransactionBlockResponse]

    /// A Boolean value indicating whether there are more pages of transaction blocks available to be retrieved.
    /// `true` if there are more pages available, otherwise `false`.
    public let hasNextPage: Bool

    /// An optional string representing the cursor for the next page of transaction blocks.
    /// `nil` if there are no more pages available.
    public let nextCursor: String?
}
