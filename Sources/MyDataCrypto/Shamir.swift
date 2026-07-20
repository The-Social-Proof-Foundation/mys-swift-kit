import Foundation

/// GF(256) Shamir secret sharing — mirrors `@socialproof/mydata` `shamir.mjs`.
enum MyDataShamir {
	struct Share {
		let index: UInt8
		let share: Data
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
