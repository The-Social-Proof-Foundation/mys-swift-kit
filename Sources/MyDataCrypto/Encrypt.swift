import Foundation
import Security

/// MyData threshold encrypt — mirrors `@socialproof/mydata` `encrypt.mjs` (Boneh–Franklin + AES-GCM DEM).
public enum MyDataEncrypt {
	public struct KeyServer: Sendable {
		public let objectId: Data // 32 bytes
		public let pk: Data // G2 compressed 96 bytes

		public init(objectId: Data, pk: Data) {
			self.objectId = objectId
			self.pk = pk
		}

		public init(objectIdHex: String, pk: Data) throws {
			self.objectId = try addressBytes(objectIdHex)
			self.pk = pk
		}
	}

	/// Encrypt `plaintext` under identity `id` (inner id bytes) for `packageId`.
	public static func encrypt(
		keyServers: [KeyServer],
		threshold: Int,
		packageId: String,
		id: Data,
		plaintext: Data,
		aad: Data = Data()
	) throws -> Data {
		guard threshold > 0, threshold < 256,
		      keyServers.count >= threshold,
		      keyServers.count < 256
		else {
			throw MyDataError.decryptionFailed("invalid key servers or threshold")
		}
		var baseKey = Data(count: 32)
		_ = baseKey.withUnsafeMutableBytes { buf in
			SecRandomCopyBytes(kSecRandomDefault, 32, buf.baseAddress!)
		}
		let shares = try MyDataShamir.split(baseKey, threshold: threshold, total: keyServers.count)
		let fullId = try addressBytes(packageId) + id
		let ibe = try encryptBatched(
			keyServers: keyServers,
			id: fullId,
			shares: shares,
			baseKey: baseKey,
			threshold: UInt8(threshold)
		)
		let demKey = try MyDataKDF.deriveKey(
			purpose: .dem,
			baseKey: baseKey,
			encryptedShares: ibe.encryptedShares,
			threshold: UInt8(threshold),
			keyServers: keyServers.map(\.objectId)
		)
		let blob = try MyDataDEM.aesGcm256Encrypt(key: demKey, plaintext: plaintext, aad: aad)
		return try serializeEncryptedObject(
			packageId: try addressBytes(packageId),
			id: id,
			services: zip(keyServers, shares).map { ($0.objectId, $1.index) },
			threshold: UInt8(threshold),
			nonce: ibe.nonce,
			encryptedShares: ibe.encryptedShares,
			encryptedRandomness: ibe.encryptedRandomness,
			aesBlob: blob,
			aad: aad
		)
	}

	// MARK: - IBE

	private struct IBEBatch {
		let nonce: Data
		let encryptedShares: [Data]
		let encryptedRandomness: Data
	}

	private static func encryptBatched(
		keyServers: [KeyServer],
		id: Data,
		shares: [MyDataShamir.Share],
		baseKey: Data,
		threshold: UInt8
	) throws -> IBEBatch {
		let publicKeys = try keyServers.map { try G2Element.fromBytes($0.pk) }
		guard !publicKeys.isEmpty, publicKeys.count == shares.count else {
			throw MyDataError.decryptionFailed("invalid public keys")
		}
		let r = try MyDataScalar.random()
		let nonce = G2Element.generator().multiply(r)
		let gidR = MyDataKDF.hashToG1(id).multiply(r)
		var encryptedShares: [Data] = []
		encryptedShares.reserveCapacity(shares.count)
		for (i, share) in shares.enumerated() {
			let key = try MyDataKDF.kdf(
				element: gidR.pairing(publicKeys[i]),
				nonce: nonce,
				id: id,
				objectId: keyServers[i].objectId,
				index: share.index
			)
			encryptedShares.append(xor(share.share, key))
		}
		let randomnessKey = try MyDataKDF.deriveKey(
			purpose: .encryptedRandomness,
			baseKey: baseKey,
			encryptedShares: encryptedShares,
			threshold: threshold,
			keyServers: keyServers.map(\.objectId)
		)
		let encryptedRandomness = xor(randomnessKey, r.bytes)
		return IBEBatch(
			nonce: nonce.toBytes(),
			encryptedShares: encryptedShares,
			encryptedRandomness: encryptedRandomness
		)
	}

	// MARK: - BCS serialize

	private static func serializeEncryptedObject(
		packageId: Data,
		id: Data,
		services: [(Data, UInt8)],
		threshold: UInt8,
		nonce: Data,
		encryptedShares: [Data],
		encryptedRandomness: Data,
		aesBlob: Data,
		aad: Data
	) throws -> Data {
		var out = Data()
		out.append(0) // version
		out.append(packageId)
		out.append(uleb128(id.count))
		out.append(id)
		out.append(uleb128(services.count))
		for (oid, idx) in services {
			out.append(oid)
			out.append(idx)
		}
		out.append(threshold)
		out.append(uleb128(0)) // IBE variant BonehFranklinBLS12381
		out.append(nonce)
		out.append(uleb128(encryptedShares.count))
		for share in encryptedShares { out.append(share) }
		out.append(encryptedRandomness)
		out.append(uleb128(0)) // AES-GCM ciphertext variant
		out.append(uleb128(aesBlob.count))
		out.append(aesBlob)
		if aad.isEmpty {
			out.append(0) // Option::None
		} else {
			out.append(1) // Option::Some
			out.append(uleb128(aad.count))
			out.append(aad)
		}
		return out
	}

	private static func uleb128(_ n: Int) -> Data {
		var value = n
		var out = Data()
		while true {
			var byte = UInt8(value & 0x7F)
			value >>= 7
			if value != 0 { byte |= 0x80 }
			out.append(byte)
			if value == 0 { break }
		}
		return out
	}

	private static func addressBytes(_ hex: String) throws -> Data {
		var h = hex.lowercased()
		if h.hasPrefix("0x") { h.removeFirst(2) }
		guard h.count <= 64, h.count % 2 == 0, h.allSatisfy(\.isHexDigit) else {
			throw MyDataError.invalidHex(hex)
		}
		var raw = Data()
		var idx = h.startIndex
		while idx < h.endIndex {
			let next = h.index(idx, offsetBy: 2)
			guard let b = UInt8(h[idx..<next], radix: 16) else {
				throw MyDataError.invalidHex(hex)
			}
			raw.append(b)
			idx = next
		}
		if raw.count < 32 {
			return Data(repeating: 0, count: 32 - raw.count) + raw
		}
		return raw
	}

	private static func xor(_ a: Data, _ b: Data) -> Data {
		precondition(a.count == b.count)
		return Data(zip(a, b).map { $0 ^ $1 })
	}
}
