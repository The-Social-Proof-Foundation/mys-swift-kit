import CryptoKit
import Foundation

/// Messaging envelope AAD — mirrors myso-messaging-stack `buildMessageAad`.
/// Layout: `[groupId 32][keyVersion u64 LE][senderAddress 32]`
public enum MessagingMessageAAD {
	public static func build(groupId: Data, keyVersion: UInt64, senderAddress: Data) throws -> Data {
		guard groupId.count == 32 else { throw MyDataError.decryptionFailed("groupId length") }
		guard senderAddress.count == 32 else { throw MyDataError.decryptionFailed("sender length") }
		var out = Data(capacity: 72)
		out.append(groupId)
		var kv = keyVersion.littleEndian
		withUnsafeBytes(of: &kv) { out.append(contentsOf: $0) }
		out.append(senderAddress)
		return out
	}

	public static func build(groupIdHex: String, keyVersion: UInt64, senderAddressHex: String) throws -> Data {
		try build(
			groupId: try address32(groupIdHex),
			keyVersion: keyVersion,
			senderAddress: try address32(senderAddressHex)
		)
	}

	private static func address32(_ hex: String) throws -> Data {
		var data = try Hex.decode(hex)
		if data.count > 32 { throw MyDataError.invalidHex(hex) }
		if data.count < 32 {
			data = Data(repeating: 0, count: 32 - data.count) + data
		}
		return data
	}
}

/// AES-GCM message encrypt — ciphertext layout matches WebCrypto (`ciphertext||tag`).
public enum MessagingEnvelopeEncrypt {
	/// - Parameter aad: Message text uses AAD; attachment blobs pass `nil`.
	public static func encrypt(
		dek: Data,
		plaintext: Data,
		nonce: Data,
		aad: Data?
	) throws -> Data {
		guard dek.count == 32 else { throw MyDataError.decryptionFailed("DEK length") }
		guard nonce.count == 12 else { throw MyDataError.decryptionFailed("nonce length") }
		let key = SymmetricKey(data: dek)
		let gcmNonce = try AES.GCM.Nonce(data: nonce)
		let sealed: AES.GCM.SealedBox
		do {
			if let aad {
				sealed = try AES.GCM.seal(plaintext, using: key, nonce: gcmNonce, authenticating: aad)
			} else {
				sealed = try AES.GCM.seal(plaintext, using: key, nonce: gcmNonce)
			}
		} catch {
			throw MyDataError.decryptionFailed("message AES-GCM encrypt failed")
		}
		var out = Data()
		out.append(sealed.ciphertext)
		out.append(sealed.tag)
		return out
	}
}

/// AES-GCM message decrypt (relayer ciphertext) using DEK + optional AAD.
public enum MessagingEnvelopeDecrypt {
	/// - Parameter aad: Message text uses AAD; attachment blobs pass `nil`.
	public static func decrypt(
		dek: Data,
		ciphertext: Data,
		nonce: Data,
		aad: Data?
	) throws -> Data {
		guard dek.count == 32 else { throw MyDataError.decryptionFailed("DEK length") }
		guard nonce.count == 12 else { throw MyDataError.decryptionFailed("nonce length") }
		guard ciphertext.count >= 16 else { throw MyDataError.invalidCiphertext("message too short") }
		let tag = ciphertext.suffix(16)
		let body = ciphertext.prefix(ciphertext.count - 16)
		let key = SymmetricKey(data: dek)
		let gcmNonce = try AES.GCM.Nonce(data: nonce)
		let sealed = try AES.GCM.SealedBox(nonce: gcmNonce, ciphertext: body, tag: tag)
		do {
			if let aad {
				return try AES.GCM.open(sealed, using: key, authenticating: aad)
			}
			return try AES.GCM.open(sealed, using: key)
		} catch {
			throw MyDataError.decryptionFailed("message AES-GCM failed")
		}
	}

	/// Convenience — message envelopes always carry AAD.
	public static func decrypt(
		dek: Data,
		ciphertext: Data,
		nonce: Data,
		aad: Data
	) throws -> Data {
		try decrypt(dek: dek, ciphertext: ciphertext, nonce: nonce, aad: Optional.some(aad))
	}
}
