import CBlst
import Foundation

/// Thin BLS12-381 wrappers matching `@socialproof/mydata` `bls12381` usage.
/// Backend: portable blst (byte-compatible with `@noble/curves` for MyData encodings).

public struct MyDataScalar: Equatable, Sendable {
	public static let size = 32
	public let bytes: Data

	public init(bytes: Data) throws {
		guard bytes.count == Self.size else { throw MyDataError.invalidScalar }
		var sc = blst_scalar()
		bytes.withUnsafeBytes { raw in
			blst_scalar_from_bendian(&sc, raw.bindMemory(to: UInt8.self).baseAddress!)
		}
		// Reject out-of-range by checking reduction: blst_sk_check
		var ok = false
		withUnsafePointer(to: sc) { p in
			ok = blst_sk_check(p)
		}
		guard ok else { throw MyDataError.invalidScalar }
		self.bytes = bytes
	}

	public static func fromBigEndian(_ data: Data) throws -> MyDataScalar {
		try MyDataScalar(bytes: data)
	}
}

public struct G1Element: Equatable, Sendable {
	public static let size = 48
	fileprivate var point: blst_p1

	public static func generator() -> G1Element {
		var g = blst_p1()
		let gen = blst_p1_generator()!
		g = gen.pointee
		return G1Element(point: g)
	}

	public static func fromBytes(_ data: Data) throws -> G1Element {
		guard data.count == size else { throw MyDataError.invalidPoint("G1 length") }
		var aff = blst_p1_affine()
		let err = data.withUnsafeBytes { raw -> BLST_ERROR in
			blst_p1_uncompress(&aff, raw.bindMemory(to: UInt8.self).baseAddress!)
		}
		guard err == BLST_SUCCESS else { throw MyDataError.invalidPoint("G1 uncompress") }
		var p = blst_p1()
		blst_p1_from_affine(&p, &aff)
		return G1Element(point: p)
	}

	public func toBytes() -> Data {
		var out = [UInt8](repeating: 0, count: Self.size)
		var p = point
		blst_p1_compress(&out, &p)
		return Data(out)
	}

	public func multiply(_ scalar: MyDataScalar) -> G1Element {
		var out = blst_p1()
		var p = point
		var sc = blst_scalar()
		scalar.bytes.withUnsafeBytes { raw in
			blst_scalar_from_bendian(&sc, raw.bindMemory(to: UInt8.self).baseAddress!)
		}
		withUnsafeBytes(of: &sc) { raw in
			blst_p1_mult(&out, &p, raw.bindMemory(to: UInt8.self).baseAddress!, 255)
		}
		return G1Element(point: out)
	}

	public func add(_ other: G1Element) -> G1Element {
		var out = blst_p1()
		var a = point
		var b = other.point
		blst_p1_add_or_double(&out, &a, &b)
		return G1Element(point: out)
	}

	public func subtract(_ other: G1Element) -> G1Element {
		var neg = other.point
		blst_p1_cneg(&neg, true)
		return add(G1Element(point: neg))
	}

	/// Hash-to-curve matching MyData `G1Element.hashToCurve` / noble default G1 DST.
	public static func hashToCurve(_ data: Data) -> G1Element {
		var out = blst_p1()
		let dst = Array("BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_".utf8)
		data.withUnsafeBytes { msg in
			dst.withUnsafeBufferPointer { dstPtr in
				blst_hash_to_g1(
					&out,
					msg.bindMemory(to: UInt8.self).baseAddress,
					data.count,
					dstPtr.baseAddress,
					dst.count,
					nil,
					0
				)
			}
		}
		return G1Element(point: out)
	}

	public func pairing(_ other: G2Element) -> GTElement {
		var pAff = blst_p1_affine()
		var qAff = blst_p2_affine()
		var p = point
		var q = other.point
		blst_p1_to_affine(&pAff, &p)
		blst_p2_to_affine(&qAff, &q)
		var tmp = blst_fp12()
		blst_miller_loop(&tmp, &qAff, &pAff)
		var gt = blst_fp12()
		blst_final_exp(&gt, &tmp)
		return GTElement(element: gt)
	}

	public static func == (lhs: G1Element, rhs: G1Element) -> Bool {
		var a = lhs.point
		var b = rhs.point
		return blst_p1_is_equal(&a, &b)
	}
}

public struct G2Element: Equatable, Sendable {
	public static let size = 96
	fileprivate var point: blst_p2

	public static func generator() -> G2Element {
		var g = blst_p2()
		g = blst_p2_generator()!.pointee
		return G2Element(point: g)
	}

	public static func fromBytes(_ data: Data) throws -> G2Element {
		guard data.count == size else { throw MyDataError.invalidPoint("G2 length") }
		var aff = blst_p2_affine()
		let err = data.withUnsafeBytes { raw -> BLST_ERROR in
			blst_p2_uncompress(&aff, raw.bindMemory(to: UInt8.self).baseAddress!)
		}
		guard err == BLST_SUCCESS else { throw MyDataError.invalidPoint("G2 uncompress") }
		var p = blst_p2()
		blst_p2_from_affine(&p, &aff)
		return G2Element(point: p)
	}

	public func toBytes() -> Data {
		var out = [UInt8](repeating: 0, count: Self.size)
		var p = point
		blst_p2_compress(&out, &p)
		return Data(out)
	}

	public func multiply(_ scalar: MyDataScalar) -> G2Element {
		var out = blst_p2()
		var p = point
		var sc = blst_scalar()
		scalar.bytes.withUnsafeBytes { raw in
			blst_scalar_from_bendian(&sc, raw.bindMemory(to: UInt8.self).baseAddress!)
		}
		withUnsafeBytes(of: &sc) { raw in
			blst_p2_mult(&out, &p, raw.bindMemory(to: UInt8.self).baseAddress!, 255)
		}
		return G2Element(point: out)
	}

	public func add(_ other: G2Element) -> G2Element {
		var out = blst_p2()
		var a = point
		var b = other.point
		blst_p2_add_or_double(&out, &a, &b)
		return G2Element(point: out)
	}

	public func equals(_ other: G2Element) -> Bool {
		self == other
	}

	public static func == (lhs: G2Element, rhs: G2Element) -> Bool {
		var a = lhs.point
		var b = rhs.point
		return blst_p2_is_equal(&a, &b)
	}
}

public struct GTElement: Equatable, Sendable {
	public static let size = 576
	fileprivate var element: blst_fp12

	/// MyData `GTElement.toBytes` — Fp12 bytes with limb reorder `[0,3,1,4,2,5]`.
	public func toBytes() -> Data {
		let raw = serializeFp12(element)
		let P = [0, 3, 1, 4, 2, 5]
		let pairSize = Self.size / P.count
		var result = Data(count: Self.size)
		for (i, srcIdx) in P.enumerated() {
			let sourceStart = srcIdx * pairSize
			let targetStart = i * pairSize
			result.replaceSubrange(
				targetStart..<(targetStart + pairSize),
				with: raw[sourceStart..<(sourceStart + pairSize)]
			)
		}
		return result
	}

	public static func == (lhs: GTElement, rhs: GTElement) -> Bool {
		var a = lhs.element
		var b = rhs.element
		return blst_fp12_is_equal(&a, &b)
	}
}

/// Serialize blst fp12 as 12 × 48-byte big-endian field elements (noble Fp12 order attempt).
private func serializeFp12(_ fp12: blst_fp12) -> Data {
	var e = fp12
	var out = Data(capacity: 576)
	// blst_fp12 = { fp6[2] }; fp6 = { fp2[3] }; fp2 = { fp[2] }
	withUnsafeBytes(of: &e) { raw in
		// Prefer explicit field walks via bendian helpers on each limb.
		_ = raw
	}
	// Walk structure: c0.c0.c0, c0.c0.c1, c0.c1.c0, ... matching noble's typical Fp12 layout
	func appendFP(_ fp: blst_fp) {
		var f = fp
		var bytes = [UInt8](repeating: 0, count: 48)
		blst_bendian_from_fp(&bytes, &f)
		out.append(contentsOf: bytes)
	}
	// fp6[0]
	appendFP(e.fp6.0.fp2.0.fp.0)
	appendFP(e.fp6.0.fp2.0.fp.1)
	appendFP(e.fp6.0.fp2.1.fp.0)
	appendFP(e.fp6.0.fp2.1.fp.1)
	appendFP(e.fp6.0.fp2.2.fp.0)
	appendFP(e.fp6.0.fp2.2.fp.1)
	// fp6[1]
	appendFP(e.fp6.1.fp2.0.fp.0)
	appendFP(e.fp6.1.fp2.0.fp.1)
	appendFP(e.fp6.1.fp2.1.fp.0)
	appendFP(e.fp6.1.fp2.1.fp.1)
	appendFP(e.fp6.1.fp2.2.fp.0)
	appendFP(e.fp6.1.fp2.2.fp.1)
	return out
}
