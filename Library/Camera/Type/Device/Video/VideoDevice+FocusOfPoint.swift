//
//  KindKit
//

import AVFoundation
import KindGeometry

public extension VideoDevice {
    
    enum FocusOfPoint {
        
        case on(Point)
        
    }
    
}

extension VideoDevice.FocusOfPoint : Hashable {
}

extension VideoDevice.FocusOfPoint : Equatable {
}

extension VideoDevice.FocusOfPoint : Sendable {
}

public extension VideoDevice {
    
    func isFocusOfPointSupported() -> Bool {
        return self.handle.isFocusPointOfInterestSupported
    }
    
    func focusOfPoint() -> FocusOfPoint? {
        if self.handle.isFocusPointOfInterestSupported == true {
            return .on(.init(self.handle.focusPointOfInterest))
        }
        return nil
    }
    
}

public extension VideoDevice.Configuration {
    
    func isFocusOfPointSupported() -> Bool {
        return self.device.isFocusOfPointSupported()
    }
    
    func focusOfPoint() -> VideoDevice.FocusOfPoint? {
        return self.device.focusOfPoint()
    }
    
    func set(focusOfPoint: VideoDevice.FocusOfPoint) {
        switch focusOfPoint {
        case .on(let point):
            self.device.handle.focusPointOfInterest = point.cgPoint
        }
    }
    
}
