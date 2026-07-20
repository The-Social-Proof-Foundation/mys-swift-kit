import Foundation

public enum MyDataError: Error, LocalizedError, Equatable {
	case invalidHex(String)
	case invalidPoint(String)
	case invalidScalar
	case invalidCiphertext(String)
	case decryptionFailed(String)
	case notEnoughShares
	case unsupportedFeature(String)
	case bcsParse(String)
	case configMissing(String)
	case keyServer(String)
	case sessionKey(String)

	public var errorDescription: String? {
		switch self {
		case .invalidHex(let s): return "Invalid hex: \(s)"
		case .invalidPoint(let s): return "Invalid point: \(s)"
		case .invalidScalar: return "Invalid scalar"
		case .invalidCiphertext(let s): return "Invalid ciphertext: \(s)"
		case .decryptionFailed(let s): return "Decryption failed: \(s)"
		case .notEnoughShares: return "Not enough shares"
		case .unsupportedFeature(let s): return "Unsupported: \(s)"
		case .bcsParse(let s): return "BCS parse error: \(s)"
		case .configMissing(let s): return "Config missing: \(s)"
		case .keyServer(let s): return "Key server error: \(s)"
		case .sessionKey(let s): return "Session key error: \(s)"
		}
	}
}
