//
//  KindKit
//

import AVFoundation
import KindMath

public extension Device.Video {
    
    enum ExposureOfPoint {
        
        case on(Point)
        
    }
    
}

public extension Device.Video {
    
    func isExposureOfPointSupported() -> Bool {
        return self.device.isExposurePointOfInterestSupported
    }
    
    func exposureOfPoint() -> ExposureOfPoint? {
        if self.device.isExposurePointOfInterestSupported == true {
            return .on(.init(self.device.exposurePointOfInterest))
        }
        return nil
    }
    
}

public extension Device.Video.Configuration {
    
    func isExposureOfPointSupported() -> Bool {
        return self.device.isExposureOfPointSupported()
    }
    
    func exposureOfPoint() -> Device.Video.ExposureOfPoint? {
        return self.device.exposureOfPoint()
    }
    
    func set(exposureOfPoint: Device.Video.ExposureOfPoint) {
        switch exposureOfPoint {
        case .on(let point):
            self.device.device.exposurePointOfInterest = point.cgPoint
        }
    }
    
}
