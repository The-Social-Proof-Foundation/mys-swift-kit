import CryptoKit
import Foundation

/// DEM layer — mirrors `@socialproof/mydata` `dem.mjs` AesGcm256.
enum MyDataDEM {
	/// Fixed IV from MyData TS SDK.
	static let aesGcmIV = Data([
		138, 55, 153, 253, 198, 46, 121, 219,
		160, 128, 89, 7, 214, 156, 148, 220
	])

	static func aesGcm256Decrypt(key: Data, blob: Data, aad: Data) throws -> Data {
		guard key.count == 32 else { throw MyDataError.decryptionFailed("DEM key length") }
		let symmetric = SymmetricKey(data: key)
		let nonce = try AES.GCM.Nonce(data: aesGcmIV)
		// WebCrypto AES-GCM ciphertext is ciphertext||tag (16-byte tag at end).
		guard blob.count >= 16 else { throw MyDataError.invalidCiphertext("AES-GCM blob too short") }
		let tag = blob.suffix(16)
		let ciphertext = blob.prefix(blob.count - 16)
		let sealed = try AES.GCM.SealedBox(
			nonce: nonce,
			ciphertext: ciphertext,
			tag: tag
		)
		do {
			return try AES.GCM.open(sealed, using: symmetric, authenticating: aad)
		} catch {
			throw MyDataError.decryptionFailed("AES-GCM open failed")
		}
	}

	/// AES-GCM encrypt — returns WebCrypto layout `ciphertext||tag`.
	static func aesGcm256Encrypt(key: Data, plaintext: Data, aad: Data) throws -> Data {
		guard key.count == 32 else { throw MyDataError.decryptionFailed("DEM key length") }
		let symmetric = SymmetricKey(data: key)
		let nonce = try AES.GCM.Nonce(data: aesGcmIV)
		let sealed: AES.GCM.SealedBox
		do {
			if aad.isEmpty {
				sealed = try AES.GCM.seal(plaintext, using: symmetric, nonce: nonce)
			} else {
				sealed = try AES.GCM.seal(plaintext, using: symmetric, nonce: nonce, authenticating: aad)
			}
		} catch {
			throw MyDataError.decryptionFailed("AES-GCM seal failed")
		}
		return sealed.ciphertext + sealed.tag
	}
}
