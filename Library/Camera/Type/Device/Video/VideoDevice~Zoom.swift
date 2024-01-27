//
//  KindKit
//

import AVFoundation

#if os(iOS)

public extension VideoDevice {
    
    func videoZoom() -> Double {
        return Double(self.handle.videoZoomFactor)
    }
    
    func minVideoZoom() -> Double {
        return 1
    }
    
    func maxVideoZoom() -> Double {
        return Double(self.handle.activeFormat.videoMaxZoomFactor)
    }
    
}

public extension VideoDevice.Configuration {
    
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
        self.device.handle.videoZoomFactor = CGFloat(max(minVideoZoom, min(videoZoom, maxVideoZoom)))
    }
    
}

#endif
