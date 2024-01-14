//
//  KindKit
//

import KindGraphics

public final class Target {
    
    public let onProgress: ((_ progress: Double) -> Void)?
    public let onImage: ((_ image: Image) -> Void)?
    public let onError: ((_ error: Error) -> Void)?
    
    public init(
        onProgress: ((_ progress: Double) -> Void)? = nil,
        onImage: ((_ image: Image) -> Void)? = nil,
        onError: ((_ error: Error) -> Void)? = nil
    ) {
        self.onProgress = onProgress
        self.onImage = onImage
        self.onError = onError
    }
    
}

extension Target : ITarget {
    
    public func remoteImage(progress: Double) {
        self.onProgress?(progress)
    }
    
    public func remoteImage(image: Image) {
        self.onImage?(image)
    }
    
    public func remoteImage(error: Error) {
        self.onError?(error)
    }
    
}
