//
//  KindKitCore
//

import Foundation
import CommonCrypto

public extension Data {

    var hexString: String {
        var string = String()
        self.forEach({ string += String(format: "%02x", $0) })
        return string
    }
    
}

public extension Data {

    var md2: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD2_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_MD2($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var md4: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD4_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_MD4($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var md5: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_MD5($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha1: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha224: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA224_DIGEST_LENGTH))
         self.withUnsafeBytes({ _ = CC_SHA224($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha256: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha384: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA384_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_SHA384($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha512: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA512_DIGEST_LENGTH))
        self.withUnsafeBytes({ _ = CC_SHA512($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

}

public extension Data {
    
    var isBmp: Bool {
        if self.count >= 2 {
            if self.starts(with: [ 0x42, 0x4D ]) == true {
                return true
            }
        }
        return false
    }
    
    var isGif: Bool {
        if self.count >= 4 {
            if self.starts(with: [ 0x47, 0x49, 0x46, 0x38, 0x37, 0x61 ]) == true {
                return true
            }
            if self.starts(with: [ 0x47, 0x49, 0x46, 0x38, 0x39, 0x61 ]) == true {
                return true
            }
        }
        return false
    }
    
    var isJpeg: Bool {
        if self.count >= 4 {
            if self.starts(with: [ 0xFF, 0xD8, 0xFF, 0xDB ]) == true {
                return true
            }
            if self.starts(with: [ 0xFF, 0xD8, 0xFF, 0xE0 ]) == true {
                return true
            }
            if self.starts(with: [ 0xFF, 0x4F, 0xFF, 0x51 ]) == true {
                return true
            }
        }
        if self.count >= 12 {
            if self.starts(with: [ 0x00, 0x00, 0x00, 0x0C, 0x6A, 0x50, 0x20, 0x20, 0x0D, 0x0A, 0x87, 0x0A ]) == true {
                return true
            }
            do {
                let header = self.subdata(in: 0..<4)
                let footer = self.subdata(in: 6..<12)
                if header.starts(with: [ 0xFF, 0xD8, 0xFF, 0xE1 ]) == true && footer.elementsEqual([ 0x45, 0x78, 0x69, 0x66, 0x00, 0x00 ]) {
                    return true
                }
            }
        }
        return false
    }
    
    var isPng: Bool {
        if self.count >= 8 {
            if self.starts(with: [ 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A ]) == true {
                return true
            }
        }
        return false
    }
    
    var isTiff: Bool {
        if self.count >= 4 {
            if self.starts(with: [ 0x49, 0x49, 0x2A, 0x00 ]) == true {
                return true
            }
            if self.starts(with: [ 0x4D, 0x4D, 0x00, 0x2A ]) == true {
                return true
            }
        }
        return false
    }
    
    var isWebp: Bool {
        if self.count >= 12 {
            let header = self.subdata(in: 0..<4)
            let footer = self.subdata(in: 8..<12)
            if header.starts(with: [ 0x52, 0x49, 0x46, 0x46 ]) == true && footer.elementsEqual([ 0x57, 0x45, 0x42, 0x50 ]) {
                return true
            }
        }
        return false
    }
    
}
