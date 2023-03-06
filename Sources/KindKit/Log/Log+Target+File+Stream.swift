//
//  KindKit
//

import Foundation

extension Log.Target.File {
    
    final class Stream {
        
        let instance: OutputStream
        private(set) var size: UInt64
        
        init?(
            url: URL
        ) {
            guard let instance = OutputStream(url: url, append: true) else { return nil }
            self.instance = instance
            self.size = FileManager.default.kk_fileSize(at: url)
            instance.open()
        }
        
        deinit {
            self.instance.close()
        }
        
        func write(data: Data) {
            let writed = data.withUnsafeBytes({ bytes -> Int in
                var buffer = bytes.bindMemory(to: UInt8.self)
                while buffer.isEmpty == false {
                    guard let address = buffer.baseAddress else {
                        return -1
                    }
                    let written = self.instance.write(address, maxLength: buffer.count)
                    guard written >= 0 else {
                        return -1
                    }
                    buffer = .init(rebasing: buffer.dropFirst(written))
                }
                return bytes.count
            })
            if writed > 0 {
                self.size += UInt64(writed)
            }
        }
        
    }
    
}
