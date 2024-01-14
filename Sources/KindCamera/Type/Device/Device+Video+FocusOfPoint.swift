//
//  KindKit
//

import AVFoundation
import KindMath

public extension Device.Video {
    
    enum FocusOfPoint {
        
        case on(Point)
        
    }
    
}

public extension Device.Video {
    
    func isFocusOfPointSupported() -> Bool {
        return self.device.isFocusPointOfInterestSupported
    }
    
    func focusOfPoint() -> FocusOfPoint? {
        if self.device.isFocusPointOfInterestSupported == true {
            return .on(.init(self.device.focusPointOfInterest))
        }
        return nil
    }
    
}

public extension Device.Video.Configuration {
    
    func isFocusOfPointSupported() -> Bool {
        return self.device.isFocusOfPointSupported()
    }
    
    func focusOfPoint() -> Device.Video.FocusOfPoint? {
        return self.device.focusOfPoint()
    }
    
    func set(focusOfPoint: Device.Video.FocusOfPoint) {
        switch focusOfPoint {
        case .on(let point):
            self.device.device.focusPointOfInterest = point.cgPoint
        }
    }
    
}
