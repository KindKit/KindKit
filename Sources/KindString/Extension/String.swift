//
//  KindKit
//

import Foundation

public extension String {
    
    @inlinable
    func kk_replacing< Collection : Swift.Collection >(
        _ subrange: Range< Self.Index >,
        with collection: Collection
    ) -> Self where Collection.Element == Swift.Character {
        var result = self
        result.replaceSubrange(subrange, with: collection)
        return result
    }
    
    @inlinable
    func kk_removing(_ characterSet: CharacterSet) -> Self {
        return self.components(separatedBy: characterSet).joined()
    }

    func kk_replace(keys: [Self : Self]) -> Self {
        var result = self
        keys.forEach { (key: String, value: String) in
            if let range = result.range(of: key) {
                result.replaceSubrange(range, with: value)
            }
        }
        return result
    }

    func kk_applyMask(mask: Self) -> Self {
        var result = String()
        var maskIndex = mask.startIndex
        let maskEndIndex = mask.endIndex
        if self.count > 0 {
            var selfIndex = self.startIndex
            let selfEndIndex = self.endIndex
            while maskIndex < maskEndIndex {
                if mask[maskIndex] == "#" {
                    result.append(self[selfIndex])
                    selfIndex = self.index(selfIndex, offsetBy: 1)
                    if selfIndex >= selfEndIndex {
                        break
                    }
                } else {
                    result.append(mask[maskIndex])
                }
                maskIndex = mask.index(maskIndex, offsetBy: 1)
            }
            while selfIndex < selfEndIndex {
                result.append(self[selfIndex])
                selfIndex = self.index(selfIndex, offsetBy: 1)
            }
        } else {
            while maskIndex < maskEndIndex {
                if mask[maskIndex] != "#" {
                    result.append(mask[maskIndex])
                } else {
                    break
                }
                maskIndex = mask.index(maskIndex, offsetBy: 1)
            }
        }
        return result
    }
    
    var kk_md2: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_md2.kk_hexString
        }
        return nil
    }

    var kk_md4: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_md4.kk_hexString
        }
        return nil
    }

    var kk_md5: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_md5.kk_hexString
        }
        return nil
    }
    
    @inlinable
    var kk_sha1: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha1.kk_hexString
        }
        return nil
    }
    
    @inlinable
    var kk_sha224: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha224.kk_hexString
        }
        return nil
    }
    
    @inlinable
    var kk_sha256: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha256.kk_hexString
        }
        return nil
    }
    
    @inlinable
    var kk_sha384: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha384.kk_hexString
        }
        return nil
    }
    
    @inlinable
    var kk_sha512: Self? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha512.kk_hexString
        }
        return nil
    }

    func kk_components(pairSeparatedBy: Self, valueSeparatedBy: Self) -> [Self : Any] {
        var components: [String: Any] = [:]
        for keyValuePair in self.components(separatedBy: pairSeparatedBy) {
            let pair = keyValuePair.components(separatedBy: valueSeparatedBy)
            if pair.count > 1 {
                guard
                    let key = pair.first!.removingPercentEncoding,
                    let value = pair.last!.removingPercentEncoding else {
                    continue
                }
                let existValue = components[key]
                if let existValue = existValue {
                    if var existValueArray = existValue as? [String] {
                        existValueArray.append(value)
                        components[key] = existValueArray
                    } else if let existValueString = existValue as? String {
                        components[key] = [existValueString, value]
                    }
                } else {
                    components[key] = value
                }
            }
        }
        return components
    }
    
    @inlinable
    func kk_nsRange(from range: Range< Index >) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: self.utf16) else { return .init() }
        guard let to = range.upperBound.samePosition(in: self.utf16) else { return .init() }
        return NSRange(
            location: self.utf16.distance(from: self.utf16.startIndex, to: from),
            length: self.utf16.distance(from: from, to: to)
        )
    }
    
}
