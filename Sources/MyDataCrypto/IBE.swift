import Foundation

/// Boneh–Franklin IBE helpers — mirrors `@socialproof/mydata` `ibe.mjs`.
enum MyDataIBE {
	static func decap(nonce: G2Element, usk: G1Element) -> GTElement {
		usk.pairing(nonce)
	}

	static func decryptShare(
		nonce: G2Element,
		usk: G1Element,
		ciphertext: Data,
		id: Data,
		objectId: Data,
		index: UInt8
	) throws -> Data {
		let key = try MyDataKDF.kdf(
			element: decap(nonce: nonce, usk: usk),
			nonce: nonce,
			id: id,
			objectId: objectId,
			index: index
		)
		return xor(ciphertext, key)
	}

	static func decryptRandomness(_ encrypted: Data, randomnessKey: Data) throws -> Data {
		xor(encrypted, randomnessKey)
	}

	static func verifyNonce(nonce: G2Element, randomness: Data, useBE: Bool = true) throws -> Bool {
		let scalar: MyDataScalar
		if useBE {
			scalar = try MyDataScalar.fromBigEndian(randomness)
		} else {
			scalar = try MyDataScalar.fromBigEndian(Data(randomness.reversed()))
		}
		return G2Element.generator().multiply(scalar).equals(nonce)
	}

	static func verifyNonceWithLE(nonce: G2Element, randomness: Data) throws -> Bool {
		if let ok = try? verifyNonce(nonce: nonce, randomness: randomness, useBE: false), ok {
			return true
		}
		return try verifyNonce(nonce: nonce, randomness: randomness, useBE: true)
	}

	private static func xor(_ a: Data, _ b: Data) -> Data {
		precondition(a.count == b.count)
		return Data(zip(a, b).map { $0 ^ $1 })
	}
}
