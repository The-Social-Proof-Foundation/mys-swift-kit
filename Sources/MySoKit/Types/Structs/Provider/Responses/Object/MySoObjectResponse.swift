//
//  MySoObjectResponse.swift
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

/// A structure representing the response from a request for a MySoObject, containing either the object data or an error.
public struct MySoObjectResponse: Equatable {
    /// An optional `ObjectResponseError` representing any error that occurred during the request for the MySoObject.
    public var error: ObjectResponseError?

    /// An optional `MySoObjectData` representing the data of the requested MySoObject, if the request was successful.
    public var data: MySoObjectData?

    /// Retrieves the initial version of the shared object, if applicable.
    ///
    /// This method will return `nil` if the `data` is `nil` or if the owner of the object is not shared.
    /// - Returns: An optional `Int` representing the initial version of the shared object.
    public func getSharedObjectInitialVersion() -> Int? {
        guard let owner = self.data?.owner else { return nil }
        switch owner {
        case .shared(let shared):
            return shared
        default:
            return nil
        }
    }

    /// Constructs and retrieves a `MySoObjectRef` reference from the object data, if available.
    ///
    /// This method will return `nil` if the `data` is `nil`.
    /// - Returns: An optional `MySoObjectRef` representing the object reference constructed from the object data.
    public func getObjectReference() -> MySoObjectRef? {
        guard let data = self.data else { return nil }
        return MySoObjectRef(
            objectId: data.objectId,
            version: data.version,
            digest: data.digest
        )
    }

    public init(error: ObjectResponseError? = nil, data: MySoObjectData? = nil) {
        self.error = error
        self.data = data
    }

    public init?(input: JSON) {
        var error: ObjectResponseError?
        if input["error"].exists() {
            error = ObjectResponseError.parseJSON(input["error"])
        }
        let data = input["data"]
        self.error = error
        self.data = MySoObjectData(data: data)
    }
}
