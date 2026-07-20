import Foundation
import Security

/// ElGamal over G1 — mirrors `@socialproof/mydata` `elgamal.mjs`.
public enum MyDataElGamal {
	public static func generateSecretKey() throws -> Data {
		var bytes = Data(count: 32)
		let status = bytes.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!) }
		guard status == errSecSuccess else { throw MyDataError.sessionKey("RNG failed") }
		// Ensure valid scalar by retrying until blst accepts
		for _ in 0..<16 {
			if (try? MyDataScalar(bytes: bytes)) != nil { return bytes }
			_ = bytes.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!) }
		}
		throw MyDataError.invalidScalar
	}

	public static func toPublicKey(_ sk: Data) throws -> Data {
		let scalar = try MyDataScalar(bytes: sk)
		return G1Element.generator().multiply(scalar).toBytes()
	}

	public static func toVerificationKey(_ sk: Data) throws -> Data {
		let scalar = try MyDataScalar(bytes: sk)
		return G2Element.generator().multiply(scalar).toBytes()
	}

	/// Decrypt ElGamal ciphertext `(c0, c1)` each 48-byte G1 compressed points.
	public static func decrypt(sk: Data, c0: Data, c1: Data) throws -> Data {
		let scalar = try MyDataScalar(bytes: sk)
		let p0 = try G1Element.fromBytes(c0)
		let p1 = try G1Element.fromBytes(c1)
		return p1.subtract(p0.multiply(scalar)).toBytes()
	}
}
