import Foundation

/// Parsed MyData `EncryptedObject` — BCS layout matches `@socialproof/mydata` / Rust crypto.
public struct MyDataEncryptedObject: Sendable {
	public let version: UInt8
	public let packageId: Data
	public let id: Data
	public let services: [(objectId: Data, index: UInt8)]
	public let threshold: UInt8
	public let nonce: Data
	public let encryptedShares: [Data]
	public let encryptedRandomness: Data
	public let ciphertext: Ciphertext

	public enum Ciphertext: Sendable {
		case aes256Gcm(blob: Data, aad: Data)
		case hmac256Ctr(blob: Data, aad: Data, mac: Data)
		case plain
	}

	public static func parse(_ bytes: Data) throws -> MyDataEncryptedObject {
		var r = BCSReader(bytes)
		let version = try r.u8()
		let packageId = try r.fixed(32)
		let id = try r.byteVector()
		let serviceCount = try r.uleb128()
		var services: [(Data, UInt8)] = []
		services.reserveCapacity(serviceCount)
		for _ in 0..<serviceCount {
			let oid = try r.fixed(32)
			let idx = try r.u8()
			services.append((oid, idx))
		}
		let threshold = try r.u8()
		let ibeVariant = try r.uleb128()
		guard ibeVariant == 0 else {
			throw MyDataError.unsupportedFeature("IBE variant \(ibeVariant)")
		}
		let nonce = try r.fixed(96)
		let shareCount = try r.uleb128()
		var encryptedShares: [Data] = []
		for _ in 0..<shareCount {
			encryptedShares.append(try r.fixed(32))
		}
		let encryptedRandomness = try r.fixed(32)
		let ctVariant = try r.uleb128()
		let ciphertext: Ciphertext
		switch ctVariant {
		case 0:
			let blob = try r.byteVector()
			let aadOpt = try r.u8()
			let aad = aadOpt == 0 ? Data() : try r.byteVector()
			ciphertext = .aes256Gcm(blob: blob, aad: aad)
		case 1:
			let blob = try r.byteVector()
			let aadOpt = try r.u8()
			let aad = aadOpt == 0 ? Data() : try r.byteVector()
			let mac = try r.fixed(32)
			ciphertext = .hmac256Ctr(blob: blob, aad: aad, mac: mac)
		case 2:
			ciphertext = .plain
		default:
			throw MyDataError.unsupportedFeature("ciphertext variant \(ctVariant)")
		}
		return MyDataEncryptedObject(
			version: version,
			packageId: packageId,
			id: id,
			services: services.map { (objectId: $0.0, index: $0.1) },
			threshold: threshold,
			nonce: nonce,
			encryptedShares: encryptedShares,
			encryptedRandomness: encryptedRandomness,
			ciphertext: ciphertext
		)
	}

	/// `packageId || id` hex (no 0x), matching `createFullId`.
	public var fullIdHex: String {
		Hex.encode(packageId + id)
	}

	public var fullIdBytes: Data { packageId + id }
}

private struct BCSReader {
	private let data: Data
	private var offset = 0

	init(_ data: Data) { self.data = data }

	mutating func u8() throws -> UInt8 {
		guard offset < data.count else { throw MyDataError.bcsParse("EOF u8") }
		defer { offset += 1 }
		return data[offset]
	}

	mutating func fixed(_ n: Int) throws -> Data {
		guard offset + n <= data.count else { throw MyDataError.bcsParse("EOF fixed \(n)") }
		defer { offset += n }
		return data.subdata(in: offset..<(offset + n))
	}

	mutating func uleb128() throws -> Int {
		var result = 0
		var shift = 0
		while true {
			let b = try u8()
			result |= Int(b & 0x7F) << shift
			if b & 0x80 == 0 { break }
			shift += 7
			if shift > 70 { throw MyDataError.bcsParse("uleb overflow") }
		}
		return result
	}

	mutating func byteVector() throws -> Data {
		let len = try uleb128()
		return try fixed(len)
	}
}
