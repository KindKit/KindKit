//
//  KindKit
//

import Foundation

public extension Log.Target.File {
    
    struct SizePolicy {
        
        public let maxFileSize: UInt64
        public let maxNumberOfFiles: Int
        
        public init(
            maxFileSize: UInt64,
            maxNumberOfFiles: Int
        ) {
            self.maxFileSize = maxFileSize
            self.maxNumberOfFiles = maxNumberOfFiles
        }
        
    }
    
}
