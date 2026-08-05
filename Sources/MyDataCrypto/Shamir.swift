import Foundation
import Security

/// GF(256) Shamir secret sharing — mirrors `@socialproof/mydata` `shamir.mjs`.
enum MyDataShamir {
	struct Share {
		let index: UInt8
		let share: Data
	}

	/// Split a secret into `total` shares with reconstruction threshold (MyData `split`).
	static func split(_ secret: Data, threshold: Int, total: Int) throws -> [Share] {
		guard threshold >= 1, threshold <= total, total < 256 else {
			throw MyDataError.decryptionFailed("invalid shamir threshold/total")
		}
		let degree = threshold - 1
		var polynomials: [PolynomialBytes] = []
		polynomials.reserveCapacity(secret.count)
		for byte in secret {
			var coeffs = Data([byte])
			if degree > 0 {
				var random = [UInt8](repeating: 0, count: degree)
				_ = SecRandomCopyBytes(kSecRandomDefault, random.count, &random)
				coeffs.append(contentsOf: random)
			}
			polynomials.append(PolynomialBytes(coefficients: coeffs))
		}
		return (0..<total).map { i in
			let index = UInt8(i + 1)
			var share = Data(count: secret.count)
			for (j, poly) in polynomials.enumerated() {
				share[j] = poly.evaluate(x: index)
			}
			return Share(index: index, share: share)
		}
	}

	static func combine(_ shares: [Share]) throws -> Data {
		guard !shares.isEmpty else { throw MyDataError.decryptionFailed("no shares") }
		let length = shares[0].share.count
		guard shares.allSatisfy({ $0.share.count == length }) else {
			throw MyDataError.decryptionFailed("share length mismatch")
		}
		let indices = shares.map(\.index)
		guard Set(indices).count == indices.count else {
			throw MyDataError.decryptionFailed("duplicate share indices")
		}

		var secret = Data(count: length)
		for i in 0..<length {
			let coords = shares.map { share in
				(x: GF256(share.index), y: GF256(share.share[i]))
			}
			secret[i] = Polynomial.combine(coords).value
		}
		return secret
	}
}

private struct GF256 {
	let value: UInt8

	init(_ value: UInt8) { self.value = value }

	func log() -> Int {
		precondition(value != 0)
		return Int(GF256Tables.log[Int(value) - 1])
	}

	static func exp(_ x: Int) -> GF256 {
		GF256(GF256Tables.exp[x % 255])
	}

	func add(_ other: GF256) -> GF256 { GF256(value ^ other.value) }
	func sub(_ other: GF256) -> GF256 { add(other) }

	func mul(_ other: GF256) -> GF256 {
		if value == 0 || other.value == 0 { return GF256(0) }
		return GF256.exp(log() + other.log())
	}

	func div(_ other: GF256) -> GF256 {
		mul(GF256.exp(256 - other.log() - 1))
	}

	static func zero() -> GF256 { GF256(0) }
	static func one() -> GF256 { GF256(1) }
}

/// Byte-coefficient polynomial over GF(256) for Shamir split.
private struct PolynomialBytes {
	let coefficients: Data

	func evaluate(x: UInt8) -> UInt8 {
		let xv = GF256(x)
		return coefficients.reversed().reduce(GF256.zero()) { sum, c in
			sum.mul(xv).add(GF256(c))
		}.value
	}
}

private struct Polynomial {
	/// Evaluate Lagrange combine at x=0 (MyData `Polynomial.combine`).
	static func combine(_ coordinates: [(x: GF256, y: GF256)]) -> GF256 {
		let quotient = coordinates.enumerated().reduce(GF256.zero()) { sum, item in
			let (j, coord) = item
			let xj = coord.x
			let yj = coord.y
			let denominator = xj.mul(
				coordinates.enumerated().reduce(GF256.one()) { product, other in
					let (i, c) = other
					if i == j { return product }
					return product.mul(c.x.sub(xj))
				}
			)
			return sum.add(yj.div(denominator))
		}
		let productX = coordinates.reduce(GF256.one()) { $0.mul($1.x) }
		return productX.mul(quotient)
	}
}
