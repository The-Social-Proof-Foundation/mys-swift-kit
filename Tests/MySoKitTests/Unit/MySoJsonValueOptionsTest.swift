//
//  MySoJsonValueOptionsTest.swift
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

import XCTest
@testable import MySoKit

final class MySoJsonValueOptionsTest: XCTestCase {
    
    // MARK: - Option None Tests
    
    func testOptionNone() throws {
        let none = MySoJsonValue.optionNone()
        
        // Option::None should be a single byte with value 0
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        // Should be: [length_prefix, 0x00]
        // Length prefix is 1 (one byte), then the 0x00 byte
        XCTAssertEqual(output.count, 2, "Option::None should serialize to 2 bytes (length + value)")
        XCTAssertEqual(output[1], 0x00, "Option::None value byte should be 0x00")
    }
    
    // MARK: - Option<bool> Tests
    
    func testOptionBoolNone() throws {
        let none = try MySoJsonValue.optionBool(nil)
        
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output.count, 2, "Option<bool>::None should be 2 bytes")
        XCTAssertEqual(output[1], 0x00, "Should be None (0x00)")
    }
    
    func testOptionBoolSomeTrue() throws {
        let someTrue = try MySoJsonValue.optionBool(true)
        
        let serializer = Serializer()
        try someTrue.serialize(serializer)
        let output = serializer.output()
        
        // Option::Some(true) = [length, 0x01, 0x01]
        XCTAssertGreaterThan(output.count, 2, "Option<bool>::Some should have more than 2 bytes")
        // After length prefix, should have Some tag (0x01) and bool value (0x01)
    }
    
    func testOptionBoolSomeFalse() throws {
        let someFalse = try MySoJsonValue.optionBool(false)
        
        let serializer = Serializer()
        try someFalse.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertGreaterThan(output.count, 2, "Option<bool>::Some(false) should have more than 2 bytes")
    }
    
    // MARK: - Option<String> Tests
    
    func testOptionStringNone() throws {
        let none = try MySoJsonValue.optionString(nil)
        
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<String>::None should be None (0x00)")
    }
    
    func testOptionStringSome() throws {
        let testString = "Hello, World!"
        let some = try MySoJsonValue.optionString(testString)
        
        let serializer = Serializer()
        try some.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertGreaterThan(output.count, 2, "Option<String>::Some should have more than 2 bytes")
        // Should contain Some tag (0x01) followed by string length and UTF-8 bytes
    }
    
    // MARK: - Option<address> Tests
    
    func testOptionAddressNone() throws {
        let none = try MySoJsonValue.optionAddress(nil)
        
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<address>::None should be None (0x00)")
    }
    
    func testOptionAddressSome() throws {
        let testAddress = "0x0000000000000000000000000000000000000000000000000000000000000002"
        let some = try MySoJsonValue.optionAddress(testAddress)
        
        let serializer = Serializer()
        try some.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertGreaterThan(output.count, 2, "Option<address>::Some should have more than 2 bytes")
        // Should contain Some tag (0x01) followed by 32-byte address
    }
    
    // MARK: - Option<u64> Tests
    
    func testOptionU64None() throws {
        let none = try MySoJsonValue.optionU64(nil)
        
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<u64>::None should be None (0x00)")
    }
    
    func testOptionU64Some() throws {
        let value: UInt64 = 1000000
        let some = try MySoJsonValue.optionU64(value)
        
        let serializer = Serializer()
        try some.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertGreaterThan(output.count, 2, "Option<u64>::Some should have more than 2 bytes")
        // Should contain Some tag (0x01) followed by 8-byte u64
    }
    
    // MARK: - Option<vector<address>> Tests
    
    func testOptionAddressVectorNone() throws {
        let none = try MySoJsonValue.optionAddressVector(nil)
        
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<vector<address>>::None should be None (0x00)")
    }
    
    func testOptionAddressVectorEmptyArray() throws {
        let empty = try MySoJsonValue.optionAddressVector([])
        
        let serializer = Serializer()
        try empty.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<vector<address>> with empty array should be None (0x00)")
    }
    
    func testOptionAddressVectorSome() throws {
        let addresses = [
            "0x0000000000000000000000000000000000000000000000000000000000000002",
            "0x0000000000000000000000000000000000000000000000000000000000000003"
        ]
        let some = try MySoJsonValue.optionAddressVector(addresses)
        
        let serializer = Serializer()
        try some.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertGreaterThan(output.count, 2, "Option<vector<address>>::Some should have more than 2 bytes")
        // Should contain length prefix, array of: [Some tag (0x01), vector length, addresses...]
    }
    
    // MARK: - Option<vector<vector<u8>>> Tests
    
    func testOptionStringVectorNone() throws {
        let none = try MySoJsonValue.optionStringVector(nil)
        
        let serializer = Serializer()
        try none.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<vector<vector<u8>>>::None should be None (0x00)")
    }
    
    func testOptionStringVectorEmptyArray() throws {
        let empty = try MySoJsonValue.optionStringVector([])
        
        let serializer = Serializer()
        try empty.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertEqual(output[1], 0x00, "Option<vector<vector<u8>>> with empty array should be None (0x00)")
    }
    
    func testOptionStringVectorSome() throws {
        let strings = [
            "https://example.com/image1.jpg",
            "https://example.com/video.mp4",
            "Hello, World!"
        ]
        let some = try MySoJsonValue.optionStringVector(strings)
        
        let serializer = Serializer()
        try some.serialize(serializer)
        let output = serializer.output()
        
        XCTAssertGreaterThan(output.count, 2, "Option<vector<vector<u8>>>::Some should have more than 2 bytes")
        // Should contain length prefix, array of: [Some tag (0x01), outer vector length, inner vectors...]
    }
    
    // MARK: - Real-World Usage Example
    
    func testRealWorldCreatePostExample() throws {
        // Simulate creating a post with various Option parameters
        
        // Media URLs (Option<vector<vector<u8>>>)
        let mediaURLs = [
            "https://example.com/video.mp4",
            "https://example.com/thumbnail.jpg"
        ]
        let mediaArg = try MySoJsonValue.optionStringVector(mediaURLs)
        XCTAssertNotNil(mediaArg)
        
        // Mentions (Option<vector<address>>)
        let mentionsArg = try MySoJsonValue.optionAddressVector(nil) // None
        XCTAssertNotNil(mentionsArg)
        
        // Metadata (Option<String>)
        let metadataJSON = "{\"type\":\"video\",\"duration\":120}"
        let metadataArg = try MySoJsonValue.optionString(metadataJSON)
        XCTAssertNotNil(metadataArg)
        
        // Permission flags (Option<bool>)
        let allowCommentsArg = try MySoJsonValue.optionBool(true)
        let allowReactionsArg = try MySoJsonValue.optionBool(true)
        let allowRepostsArg = try MySoJsonValue.optionBool(false)
        
        // Verify all arguments can be serialized without errors
        for arg in [mediaArg, mentionsArg, metadataArg, allowCommentsArg, allowReactionsArg, allowRepostsArg] {
            let serializer = Serializer()
            XCTAssertNoThrow(try arg.serialize(serializer))
        }
    }
}

