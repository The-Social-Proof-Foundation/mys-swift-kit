//
//  MySoJsonValue+Options.swift
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
import UInt256

/// Extension to MySoJsonValue providing helpers for Move Option<T> type serialization.
///
/// In Move, Option<T> is represented in BCS (Binary Canonical Serialization) as:
/// - None: 0x00 (single byte with value 0)
/// - Some(value): 0x01 followed by the serialized value
///
/// These helpers make it easy to construct properly serialized Option types for Move function calls.
public extension MySoJsonValue {
    
    // MARK: - Option None
    
    /// Creates a serialized representation of Option::None for any type.
    ///
    /// This is the BCS representation of None (empty Option).
    ///
    /// - Returns: A MySoJsonValue representing Option::None as `[0x00]`
    ///
    /// Example:
    /// ```swift
    /// let noMentions = MySoJsonValue.optionNone()
    /// // Use for any Option<T> parameter when you want to pass None
    /// ```
    static func optionNone() -> MySoJsonValue {
        return .array([.uint8Number(0)])
    }
    
    // MARK: - Option<vector<address>>
    
    /// Creates a serialized representation of Option<vector<address>> for Move function calls.
    ///
    /// This is commonly used for parameters like mentions, tagged users, or lists of addresses.
    ///
    /// - Parameter addresses: An optional array of hex-encoded Sui addresses.
    ///   - If nil or empty, returns Option::None
    ///   - If contains addresses, returns Option::Some(vector<address>)
    /// - Returns: A properly serialized MySoJsonValue for Option<vector<address>>
    /// - Throws: MySoError if any address is invalid
    ///
    /// Example:
    /// ```swift
    /// // None (no mentions)
    /// let noMentions = try MySoJsonValue.optionAddressVector(nil)
    ///
    /// // Some(mentions)
    /// let mentions = try MySoJsonValue.optionAddressVector([
    ///     "0x742d35cc6634c0532925a3b844bc9c7eb6fb05cd0b9db6e8f7c61a21e1b0b0b0",
    ///     "0x123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0"
    /// ])
    /// ```
    static func optionAddressVector(_ addresses: [String]?) throws -> MySoJsonValue {
        guard let addresses = addresses, !addresses.isEmpty else {
            return optionNone()
        }
        
        // Serialize the inner vector of addresses
        let serializer = Serializer()
        let addressValues = try addresses.map { try AccountAddress.fromHex($0) }
        try serializer.sequence(addressValues, Serializer._struct)
        
        // Wrap in Option::Some (0x01 prefix)
        let outerSerializer = Serializer()
        try outerSerializer.uleb128(1) // Some tag
        outerSerializer.fixedBytes(serializer.output())
        
        return .array(outerSerializer.output().map { .uint8Number($0) })
    }
    
    // MARK: - Option<vector<vector<u8>>>
    
    /// Creates a serialized representation of Option<vector<vector<u8>>> for Move function calls.
    ///
    /// This is commonly used for parameters like media URLs, file paths, or lists of strings/byte arrays.
    /// Each string is converted to a vector of UTF-8 bytes.
    ///
    /// - Parameter strings: An optional array of strings to be serialized as byte vectors.
    ///   - If nil or empty, returns Option::None
    ///   - If contains strings, returns Option::Some(vector<vector<u8>>)
    /// - Returns: A properly serialized MySoJsonValue for Option<vector<vector<u8>>>
    /// - Throws: BCSError if serialization fails
    ///
    /// Example:
    /// ```swift
    /// // None (no media)
    /// let noMedia = try MySoJsonValue.optionStringVector(nil)
    ///
    /// // Some(media URLs)
    /// let mediaURLs = try MySoJsonValue.optionStringVector([
    ///     "https://example.com/image1.jpg",
    ///     "https://example.com/video.mp4"
    /// ])
    /// ```
    static func optionStringVector(_ strings: [String]?) throws -> MySoJsonValue {
        guard let strings = strings, !strings.isEmpty else {
            return optionNone()
        }
        
        // Serialize the outer vector length
        let serializer = Serializer()
        try serializer.uleb128(UInt(strings.count))
        
        // Serialize each string as vector<u8>
        for string in strings {
            let bytes = [UInt8](string.utf8)
            try serializer.sequence(bytes, Serializer.u8)
        }
        
        // Wrap in Option::Some (0x01 prefix)
        let outerSerializer = Serializer()
        try outerSerializer.uleb128(1) // Some tag
        outerSerializer.fixedBytes(serializer.output())
        
        return .array(outerSerializer.output().map { .uint8Number($0) })
    }
    
    // MARK: - Option<String>
    
    /// Creates a serialized representation of Option<String> for Move function calls.
    ///
    /// This is commonly used for optional text parameters like metadata, descriptions, or comments.
    ///
    /// - Parameter value: An optional string value.
    ///   - If nil, returns Option::None
    ///   - If non-nil, returns Option::Some(String)
    /// - Returns: A properly serialized MySoJsonValue for Option<String>
    /// - Throws: BCSError if serialization fails
    ///
    /// Example:
    /// ```swift
    /// // None
    /// let noMetadata = try MySoJsonValue.optionString(nil)
    ///
    /// // Some(metadata)
    /// let metadata = try MySoJsonValue.optionString("{\"key\":\"value\"}")
    /// ```
    static func optionString(_ value: String?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.str(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    // MARK: - Option<bool>
    
    /// Creates a serialized representation of Option<bool> for Move function calls.
    ///
    /// This is commonly used for optional boolean flags or permissions.
    ///
    /// - Parameter value: An optional boolean value.
    ///   - If nil, returns Option::None
    ///   - If non-nil, returns Option::Some(bool)
    /// - Returns: A properly serialized MySoJsonValue for Option<bool>
    /// - Throws: BCSError if serialization fails
    ///
    /// Example:
    /// ```swift
    /// // None
    /// let noFlag = try MySoJsonValue.optionBool(nil)
    ///
    /// // Some(true)
    /// let allowComments = try MySoJsonValue.optionBool(true)
    ///
    /// // Some(false)
    /// let disableComments = try MySoJsonValue.optionBool(false)
    /// ```
    static func optionBool(_ value: Bool?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.bool(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    // MARK: - Option<u8>, Option<u64>, etc.
    
    /// Creates a serialized representation of Option<u8> for Move function calls.
    ///
    /// - Parameter value: An optional UInt8 value.
    /// - Returns: A properly serialized MySoJsonValue for Option<u8>
    /// - Throws: BCSError if serialization fails
    static func optionU8(_ value: UInt8?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.u8(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    /// Creates a serialized representation of Option<u16> for Move function calls.
    ///
    /// - Parameter value: An optional UInt16 value.
    /// - Returns: A properly serialized MySoJsonValue for Option<u16>
    /// - Throws: BCSError if serialization fails
    static func optionU16(_ value: UInt16?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.u16(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    /// Creates a serialized representation of Option<u32> for Move function calls.
    ///
    /// - Parameter value: An optional UInt32 value.
    /// - Returns: A properly serialized MySoJsonValue for Option<u32>
    /// - Throws: BCSError if serialization fails
    static func optionU32(_ value: UInt32?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.u32(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    /// Creates a serialized representation of Option<u64> for Move function calls.
    ///
    /// - Parameter value: An optional UInt64 value.
    /// - Returns: A properly serialized MySoJsonValue for Option<u64>
    /// - Throws: BCSError if serialization fails
    static func optionU64(_ value: UInt64?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.u64(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    /// Creates a serialized representation of Option<u128> for Move function calls.
    ///
    /// - Parameter value: An optional UInt128 value.
    /// - Returns: A properly serialized MySoJsonValue for Option<u128>
    /// - Throws: BCSError if serialization fails
    static func optionU128(_ value: UInt128?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.u128(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    /// Creates a serialized representation of Option<u256> for Move function calls.
    ///
    /// - Parameter value: An optional UInt256 value.
    /// - Returns: A properly serialized MySoJsonValue for Option<u256>
    /// - Throws: BCSError if serialization fails
    static func optionU256(_ value: UInt256?) throws -> MySoJsonValue {
        guard let value = value else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        try Serializer.u256(serializer, value)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
    
    // MARK: - Option<address>
    
    /// Creates a serialized representation of Option<address> for Move function calls.
    ///
    /// - Parameter address: An optional hex-encoded Sui address.
    /// - Returns: A properly serialized MySoJsonValue for Option<address>
    /// - Throws: MySoError if the address is invalid
    ///
    /// Example:
    /// ```swift
    /// // None
    /// let noRecipient = try MySoJsonValue.optionAddress(nil)
    ///
    /// // Some(address)
    /// let recipient = try MySoJsonValue.optionAddress("0x742d35cc6634c0532925a3b844bc9c7eb6fb05cd0b9db6e8f7c61a21e1b0b0b0")
    /// ```
    static func optionAddress(_ address: String?) throws -> MySoJsonValue {
        guard let address = address else {
            return optionNone()
        }
        
        let serializer = Serializer()
        try serializer.uleb128(1) // Some tag
        let accountAddress = try AccountAddress.fromHex(address)
        try Serializer._struct(serializer, value: accountAddress)
        
        return .array(serializer.output().map { .uint8Number($0) })
    }
}

