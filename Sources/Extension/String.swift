//
//  KindKit
//

import Foundation

public extension String {

    func kk_remove(_ characterSet: CharacterSet) -> String {
        return self.components(separatedBy: characterSet).joined()
    }

    func kk_replace(keys: [String : String]) -> String {
        var result = self
        keys.forEach { (key: String, value: String) in
            if let range = result.range(of: key) {
                result.replaceSubrange(range, with: value)
            }
        }
        return result
    }

    func kk_applyMask(mask: String) -> String {
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

    @available(macOS, introduced: 10.4, deprecated: 10.15, message: "This function is cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger).")
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "This function is cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger).")
    var kk_md2: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_md2.kk_hexString
        }
        return nil
    }

    @available(macOS, introduced: 10.4, deprecated: 10.15, message: "This function is cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger).")
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "This function is cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger).")
    var kk_md4: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_md4.kk_hexString
        }
        return nil
    }

    @available(macOS, introduced: 10.4, deprecated: 10.15, message: "This function is cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger).")
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "This function is cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger).")
    var kk_md5: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_md5.kk_hexString
        }
        return nil
    }

    var kk_sha1: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha1.kk_hexString
        }
        return nil
    }

    var kk_sha224: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha224.kk_hexString
        }
        return nil
    }

    var kk_sha256: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha256.kk_hexString
        }
        return nil
    }

    var kk_sha384: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha384.kk_hexString
        }
        return nil
    }
    
    var kk_sha512: String? {
        if let data = self.data(using: .utf8) {
            return data.kk_sha512.kk_hexString
        }
        return nil
    }

    func kk_components(pairSeparatedBy: String, valueSeparatedBy: String) -> [String: Any] {
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

    func kk_range(from nsRange: NSRange) -> Range< Index >? {
        return Range< Index >(nsRange, in: self)
    }

    func kk_nsRange(from range: Range< Index >) -> NSRange {
        guard
            let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16)
            else {
                return NSRange()
        }
        return NSRange(
            location: utf16.distance(from: utf16.startIndex, to: from),
            length: utf16.distance(from: from, to: to)
        )
    }
    
    @inlinable
    func kk_attributed(font: UI.Font) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                .font : font.native,
                .paragraphStyle : NSParagraphStyle.default
            ]
        )
    }
    
    @inlinable
    func kk_size(font: UI.Font, numberOfLines: UInt, available: SizeFloat) -> SizeFloat {
        let attributed = self.kk_attributed(font: font)
        return attributed.kk_size(numberOfLines: numberOfLines, available: available)
    }

}
