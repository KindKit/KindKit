//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitView

public class RemoteImageTarget {
    
    public let onProgress: ((_ progress: Float) -> Void)?
    public let onImage: ((_ image: Image) -> Void)?
    public let onError: ((_ error: Error) -> Void)?
    
    public init(
        onProgress: ((_ progress: Float) -> Void)? = nil,
        onImage: ((_ image: Image) -> Void)? = nil,
        onError: ((_ error: Error) -> Void)? = nil
    ) {
        self.onProgress = onProgress
        self.onImage = onImage
        self.onError = onError
    }
    
}

extension RemoteImageTarget : IRemoteImageTarget {
    
    public func remoteImage(progress: Float) {
        self.onProgress?(progress)
    }
    
    public func remoteImage(image: Image) {
        self.onImage?(image)
    }
    
    public func remoteImage(error: Error) {
        self.onError?(error)
    }
    
}
