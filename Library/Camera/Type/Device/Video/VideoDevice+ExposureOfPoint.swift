//
//  KindKit
//

import AVFoundation
import KindGeometry

public extension VideoDevice {
    
    enum ExposureOfPoint {
        
        case on(Point)
        
    }
    
}

extension VideoDevice.ExposureOfPoint : Hashable {
}

extension VideoDevice.ExposureOfPoint : Equatable {
}

extension VideoDevice.ExposureOfPoint : Sendable {
}

public extension VideoDevice {
    
    func isExposureOfPointSupported() -> Bool {
        return self.handle.isExposurePointOfInterestSupported
    }
    
    func exposureOfPoint() -> ExposureOfPoint? {
        if self.handle.isExposurePointOfInterestSupported == true {
            return .on(.init(self.handle.exposurePointOfInterest))
        }
        return nil
    }
    
}

public extension VideoDevice.Configuration {
    
    func isExposureOfPointSupported() -> Bool {
        return self.device.isExposureOfPointSupported()
    }
    
    func exposureOfPoint() -> VideoDevice.ExposureOfPoint? {
        return self.device.exposureOfPoint()
    }
    
    func set(exposureOfPoint: VideoDevice.ExposureOfPoint) {
        switch exposureOfPoint {
        case .on(let point):
            self.device.handle.exposurePointOfInterest = point.cgPoint
        }
    }
    
}
