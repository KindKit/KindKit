//
//  KindKit
//

import Foundation

public final class TemporaryFile {
    
    public let url: URL
    public var path: String {
        return self.url.path
    }
    
    public init(url: URL) {
        self.url = url
    }
    
    deinit {
        if FileManager.default.fileExists(atPath: self.path) == true {
            try? FileManager.default.removeItem(at: self.url)
        }
    }
    
}
