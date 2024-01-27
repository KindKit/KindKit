//
//  KindKit
//

import KindGraphics
import KindMonadicMacro

@Monadic
public final class SimpleTarget : Target {

    @MonadicSignal
    public let onProgress = Signal< Void, Percent >()
    
    @MonadicSignal
    public let onImage = Signal< Void, Image >()
    
    @MonadicSignal
    public let onError = Signal< Void, Error >()
    
    public init() {
    }
    
    public func remoteImage(progress: Percent) {
        self.onProgress.emit(progress)
    }
    
    public func remoteImage(image: Image) {
        self.onImage.emit(image)
    }
    
    public func remoteImage(error: Error) {
        self.onError.emit(error)
    }
    
}
