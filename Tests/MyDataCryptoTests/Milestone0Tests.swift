import MyDataCrypto
import XCTest

final class Milestone0Tests: XCTestCase {
	func testGeneratorsMatchNoble() throws {
		let fixture = try loadFixture()
		XCTAssertEqual(
			Hex.encode(G1Element.generator().toBytes()),
			fixture.g1GeneratorHex
		)
		XCTAssertEqual(
			Hex.encode(G2Element.generator().toBytes()),
			fixture.g2GeneratorHex
		)
	}

	func testHashToG1FullIdMatchesNoble() throws {
		let fixture = try loadFixture()
		let fullId = try Hex.decode(fixture.fullId)
		let h = MyDataKDF.hashToG1(fullId)
		XCTAssertEqual(Hex.encode(h.toBytes()), fixture.hashToG1FullIdHex)
	}

	func testDecryptEncryptedObjectMatchesPlaintextByteForByte() async throws {
		let fixture = try loadFixture()
		let encrypted = try Hex.decode(fixture.encryptedObjectHex)
		let expected = try Hex.decode(fixture.plaintextHex)
		let usk1 = try G1Element.fromBytes(Hex.decode(fixture.usk1Hex))
		let usk2 = try G1Element.fromBytes(Hex.decode(fixture.usk2Hex))
		let keys: [String: G1Element] = [
			"\(fixture.fullId):\(fixture.server1)": usk1,
			"\(fixture.fullId):\(fixture.server2)": usk2
		]
		// Also try with 0x-prefixed server ids as used by some callers
		let keys0x: [String: G1Element] = [
			"\(fixture.fullId):\(fixture.server1)": usk1,
			"\(fixture.fullId):\(fixture.server2)": usk2
		]
		_ = keys0x
		let plaintext = try await MyDataObjectDecrypt.decrypt(
			encryptedObject: encrypted,
			keys: keys
		)
		XCTAssertEqual(Hex.encode(plaintext), Hex.encode(expected))
		XCTAssertEqual(plaintext, expected)
	}

	private struct Fixture: Decodable {
		let encryptedObjectHex: String
		let plaintextHex: String
		let packageId: String
		let identity: String
		let fullId: String
		let server1: String
		let server2: String
		let usk1Hex: String
		let usk2Hex: String
		let g1GeneratorHex: String
		let g2GeneratorHex: String
		let hashToG1FullIdHex: String
	}

	private func loadFixture() throws -> Fixture {
		let url = Bundle.module.url(forResource: "milestone0", withExtension: "json", subdirectory: nil)
			?? Bundle.module.url(forResource: "milestone0", withExtension: "json", subdirectory: "Fixtures")
		guard let url else {
			throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "fixture missing"])
		}
		return try JSONDecoder().decode(Fixture.self, from: Data(contentsOf: url))
	}
}

// Expose Hex for tests
enum Hex {
	static func encode(_ data: Data) -> String {
		data.map { String(format: "%02x", $0) }.joined()
	}

	static func decode(_ hex: String) throws -> Data {
		var h = hex.lowercased()
		if h.hasPrefix("0x") { h.removeFirst(2) }
		var data = Data(capacity: h.count / 2)
		var i = h.startIndex
		while i < h.endIndex {
			let j = h.index(i, offsetBy: 2)
			guard let b = UInt8(h[i..<j], radix: 16) else {
				throw NSError(domain: "hex", code: 1)
			}
			data.append(b)
			i = j
		}
		return data
	}
}
