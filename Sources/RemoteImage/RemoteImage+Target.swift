//
//  KindKit
//

import Foundation

public extension RemoteImage {

    final class Target {
        
        public let onProgress: ((_ progress: Double) -> Void)?
        public let onImage: ((_ image: UI.Image) -> Void)?
        public let onError: ((_ error: Error) -> Void)?
        
        public init(
            onProgress: ((_ progress: Double) -> Void)? = nil,
            onImage: ((_ image: UI.Image) -> Void)? = nil,
            onError: ((_ error: Error) -> Void)? = nil
        ) {
            self.onProgress = onProgress
            self.onImage = onImage
            self.onError = onError
        }
        
    }
    
}

extension RemoteImage.Target : IRemoteImageTarget {
    
    public func remoteImage(progress: Double) {
        self.onProgress?(progress)
    }
    
    public func remoteImage(image: UI.Image) {
        self.onImage?(image)
    }
    
    public func remoteImage(error: Error) {
        self.onError?(error)
    }
    
}
