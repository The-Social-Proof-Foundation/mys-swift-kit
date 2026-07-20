import Foundation

enum Hex {
	static func decode(_ hex: String) throws -> Data {
		var h = hex.lowercased()
		if h.hasPrefix("0x") { h.removeFirst(2) }
		guard h.count % 2 == 0 else { throw MyDataError.invalidHex(hex) }
		var data = Data(capacity: h.count / 2)
		var i = h.startIndex
		while i < h.endIndex {
			let j = h.index(i, offsetBy: 2)
			guard let b = UInt8(h[i..<j], radix: 16) else { throw MyDataError.invalidHex(hex) }
			data.append(b)
			i = j
		}
		return data
	}

	static func encode(_ data: Data, prefix0x: Bool = false) -> String {
		let s = data.map { String(format: "%02x", $0) }.joined()
		return prefix0x ? "0x" + s : s
	}
}
