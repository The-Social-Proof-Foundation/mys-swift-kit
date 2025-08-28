//
//  MySoObjectChange.swift
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

/// `MySoObjectChange` represents the type of change that occurred on a MySoObject.
///
/// - `published`: The object has been published.
/// - `transferred`: The object has been transferred.
/// - `mutated`: The object has been mutated.
/// - `deleted`: The object has been deleted.
/// - `wrapped`: The object has been wrapped.
/// - `created`: The object has been created.
public enum MySoObjectChange {
    /// Represents a published object change.
    case published(MySoObjectChangePublished)

    /// Represents a transferred object change.
    case transferred(MySoObjectChangeTransferred)

    /// Represents a mutated object change.
    case mutated(MySoObjectChangeMutated)

    /// Represents a deleted object change.
    case deleted(MySoObjectChangeDeleted)

    /// Represents a wrapped object change.
    case wrapped(MySoObjectChangeWrapped)

    /// Represents a created object change.
    case created(MySoObjectChangeCreated)

    /// Creates a `MySoObjectChange` instance from a JSON object.
    public static func fromJSON(_ input: JSON) -> MySoObjectChange? {
        switch input["type"].stringValue {
        case "published":
            return .published(MySoObjectChangePublished(input: input))
        case "transferred":
            guard let transferred = MySoObjectChangeTransferred(input: input) else { return nil }
            return .transferred(transferred)
        case "mutated":
            guard let mutated = MySoObjectChangeMutated(input: input) else { return nil }
            return .mutated(mutated)
        case "deleted":
            guard let deleted = MySoObjectChangeDeleted(input: input) else { return nil }
            return .deleted(deleted)
        case "wrapped":
            guard let wrapped = MySoObjectChangeWrapped(input: input) else { return nil }
            return .wrapped(wrapped)
        case "created":
            guard let created = MySoObjectChangeCreated(input: input) else { return nil }
            return .created(created)
        default:
            return nil
        }
    }

    /// Returns the kind of object change as a string.
    var kind: String {
        switch self {
        case .published:
            return "published"
        case .transferred:
            return "transferred"
        case .mutated:
            return "mutated"
        case .deleted:
            return "deleted"
        case .wrapped:
            return "wrapped"
        case .created:
            return "created"
        }
    }
}
