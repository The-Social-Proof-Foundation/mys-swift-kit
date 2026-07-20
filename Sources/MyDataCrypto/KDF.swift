import CryptoSwift
import Foundation

/// Key derivation — mirrors `@socialproof/mydata` `kdf.mjs`.
public enum MyDataKDF {
	public static let dstIBE = Data("MYSO-MYDATA-IBE-BLS12381-00".utf8)
	public static let dstH2 = Data("MYSO-MYDATA-IBE-BLS12381-H2-00".utf8)
	public static let dstH3 = Data("MYSO-MYDATA-IBE-BLS12381-H3-00".utf8)

	public enum KeyPurpose: UInt8 {
		case encryptedRandomness = 0
		case dem = 1
	}

	public static func hashToG1(_ id: Data) -> G1Element {
		var msg = Data()
		msg.append(dstIBE)
		msg.append(id)
		return G1Element.hashToCurve(msg)
	}

	static func kdf(
		element: GTElement,
		nonce: G2Element,
		id: Data,
		objectId: Data,
		index: UInt8
	) throws -> Data {
		guard objectId.count == 32 else { throw MyDataError.decryptionFailed("object id") }
		var input = Data()
		input.append(dstH2)
		input.append(element.toBytes())
		input.append(nonce.toBytes())
		input.append(hashToG1(id).toBytes())
		input.append(objectId)
		input.append(index)
		return Data(SHA3(variant: .sha256).calculate(for: [UInt8](input)))
	}

	static func deriveKey(
		purpose: KeyPurpose,
		baseKey: Data,
		encryptedShares: [Data],
		threshold: UInt8,
		keyServers: [Data]
	) throws -> Data {
		guard baseKey.count == 32 else { throw MyDataError.decryptionFailed("base key") }
		guard encryptedShares.count == keyServers.count else {
			throw MyDataError.decryptionFailed("share/server mismatch")
		}
		guard keyServers.allSatisfy({ $0.count == 32 }) else {
			throw MyDataError.decryptionFailed("key server id")
		}
		guard encryptedShares.allSatisfy({ $0.count == 32 }) else {
			throw MyDataError.decryptionFailed("encrypted share")
		}
		var input = Data()
		input.append(dstH3)
		input.append(baseKey)
		input.append(purpose.rawValue)
		input.append(threshold)
		for share in encryptedShares { input.append(share) }
		for server in keyServers { input.append(server) }
		return Data(SHA3(variant: .sha256).calculate(for: [UInt8](input)))
	}
}
