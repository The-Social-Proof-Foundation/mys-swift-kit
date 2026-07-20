import Foundation

/// Local decrypt given already-fetched user secret keys — mirrors `@socialproof/mydata` `decrypt.mjs`.
///
/// Milestone 0 entry point: pass USKs from fixtures (or from key-server unwrap).
public enum MyDataObjectDecrypt {
	/// Decrypt an `EncryptedObject` to plaintext (for messaging DEK wrap, this **is** the DEK).
	///
	/// - Parameter keys: map `"\(fullIdHex):0x\(objectIdHex)"` or `"\(fullIdHex):\(objectIdHex)"` → USK G1
	public static func decrypt(
		encryptedObject bytes: Data,
		keys: [String: G1Element],
		checkLEEncoding: Bool = false
	) async throws -> Data {
		let obj = try MyDataEncryptedObject.parse(bytes)
		return try await decrypt(encryptedObject: obj, keys: keys, checkLEEncoding: checkLEEncoding)
	}

	public static func decrypt(
		encryptedObject obj: MyDataEncryptedObject,
		keys: [String: G1Element],
		checkLEEncoding: Bool = false
	) async throws -> Data {
		let fullIdHex = obj.fullIdHex
		let idBytes = obj.fullIdBytes
		let nonce = try G2Element.fromBytes(obj.nonce)

		var availableIndices: [Int] = []
		for (i, service) in obj.services.enumerated() {
			let oidHex = Hex.encode(service.objectId)
			let keyA = "\(fullIdHex):0x\(oidHex)"
			let keyB = "\(fullIdHex):\(oidHex)"
			if keys[keyA] != nil || keys[keyB] != nil {
				availableIndices.append(i)
			}
		}
		guard availableIndices.count >= Int(obj.threshold) else {
			throw MyDataError.notEnoughShares
		}

		var shamirShares: [MyDataShamir.Share] = []
		for i in availableIndices {
			let (objectId, index) = (obj.services[i].objectId, obj.services[i].index)
			let oidHex = Hex.encode(objectId)
			guard let usk = keys["\(fullIdHex):0x\(oidHex)"] ?? keys["\(fullIdHex):\(oidHex)"] else {
				continue
			}
			let share = try MyDataIBE.decryptShare(
				nonce: nonce,
				usk: usk,
				ciphertext: obj.encryptedShares[i],
				id: idBytes,
				objectId: objectId,
				index: index
			)
			shamirShares.append(.init(index: index, share: share))
		}

		let baseKey = try MyDataShamir.combine(shamirShares)
		let serverIds = obj.services.map(\.objectId)
		let randomnessKey = try MyDataKDF.deriveKey(
			purpose: .encryptedRandomness,
			baseKey: baseKey,
			encryptedShares: obj.encryptedShares,
			threshold: obj.threshold,
			keyServers: serverIds
		)
		let randomness = try MyDataIBE.decryptRandomness(obj.encryptedRandomness, randomnessKey: randomnessKey)
		let nonceOk: Bool
		if checkLEEncoding {
			nonceOk = try MyDataIBE.verifyNonceWithLE(nonce: nonce, randomness: randomness)
		} else {
			nonceOk = try MyDataIBE.verifyNonce(nonce: nonce, randomness: randomness, useBE: true)
		}
		guard nonceOk else { throw MyDataError.invalidCiphertext("Invalid nonce") }

		let demKey = try MyDataKDF.deriveKey(
			purpose: .dem,
			baseKey: baseKey,
			encryptedShares: obj.encryptedShares,
			threshold: obj.threshold,
			keyServers: serverIds
		)

		switch obj.ciphertext {
		case .aes256Gcm(let blob, let aad):
			return try MyDataDEM.aesGcm256Decrypt(key: demKey, blob: blob, aad: aad)
		case .hmac256Ctr:
			throw MyDataError.unsupportedFeature("Hmac256Ctr DEM")
		case .plain:
			throw MyDataError.unsupportedFeature("Plain ciphertext")
		}
	}
}
