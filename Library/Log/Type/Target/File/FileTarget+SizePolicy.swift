//
//  KindKit
//

public extension FileTarget {
    
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

extension FileTarget.SizePolicy : Hashable {
}

extension FileTarget.SizePolicy : Equatable {
}

extension FileTarget.SizePolicy : Sendable {
}
