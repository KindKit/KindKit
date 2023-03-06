//
//  KindKit
//

import Foundation
import AVFoundation

public extension CameraSession.Device.Video {
    
    enum WhiteBalance {
        
        case locked
        case auto
        case continuous
        
    }
    
}

extension CameraSession.Device.Video.WhiteBalance {
    
    var raw: AVCaptureDevice.WhiteBalanceMode {
        switch self {
        case .locked: return .locked
        case .auto: return .autoWhiteBalance
        case .continuous: return .continuousAutoWhiteBalance
        }
    }
    
    init?(_ raw: AVCaptureDevice.WhiteBalanceMode) {
        switch raw {
        case .locked: self = .locked
        case .autoWhiteBalance: self = .auto
        case .continuousAutoWhiteBalance: self = .continuous
        @unknown default: return nil
        }
    }
    
}

public extension CameraSession.Device.Video {
    
    func isWhiteBalanceSupported(_ feature: WhiteBalance) -> Bool {
        return self.device.isWhiteBalanceModeSupported(feature.raw)
    }
    
    func whiteBalance() -> WhiteBalance? {
        return .init(self.device.whiteBalanceMode)
    }
    
}

public extension CameraSession.Device.Video.Configuration {
    
    func isWhiteBalanceSupported(_ feature: CameraSession.Device.Video.WhiteBalance) -> Bool {
        return self.device.isWhiteBalanceSupported(feature)
    }
    
    func whiteBalance() -> CameraSession.Device.Video.WhiteBalance? {
        return self.device.whiteBalance()
    }
    
    func set(whiteBalance: CameraSession.Device.Video.WhiteBalance) {
        self.device.device.whiteBalanceMode = whiteBalance.raw
    }
    
}
