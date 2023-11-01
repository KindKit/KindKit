//
//  KindKit
//

import AVFoundation

#if os(iOS)

public extension CameraSession.Device.Video {
    
    func videoZoom() -> Double {
        return Double(self.device.videoZoomFactor)
    }
    
    func minVideoZoom() -> Double {
        return 1
    }
    
    func maxVideoZoom() -> Double {
        return Double(self.device.activeFormat.videoMaxZoomFactor)
    }
    
}

public extension CameraSession.Device.Video.Configuration {
    
    func videoZoom() -> Double {
        return self.device.videoZoom()
    }
    
    func minVideoZoom() -> Double {
        return self.device.minVideoZoom()
    }
    
    func maxVideoZoom() -> Double {
        return self.device.maxVideoZoom()
    }
    
    func set(videoZoom: Double) {
        let minVideoZoom = self.minVideoZoom()
        let maxVideoZoom = self.maxVideoZoom()
        self.device.device.videoZoomFactor = CGFloat(max(minVideoZoom, min(videoZoom, maxVideoZoom)))
    }
    
}

#endif
