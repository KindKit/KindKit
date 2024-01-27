//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    enum WhiteBalance {
        
        case locked
        case auto
        case continuous
        
    }
    
}

extension VideoDevice.WhiteBalance : Hashable {
}

extension VideoDevice.WhiteBalance : Equatable {
}

extension VideoDevice.WhiteBalance : Sendable {
}

public extension VideoDevice {
    
    func isWhiteBalanceSupported(_ feature: WhiteBalance) -> Bool {
        return self.handle.isWhiteBalanceModeSupported(feature.raw)
    }
    
    func whiteBalance() -> WhiteBalance? {
        return .init(self.handle.whiteBalanceMode)
    }
    
}

public extension VideoDevice.Configuration {
    
    func isWhiteBalanceSupported(_ feature: VideoDevice.WhiteBalance) -> Bool {
        return self.device.isWhiteBalanceSupported(feature)
    }
    
    func whiteBalance() -> VideoDevice.WhiteBalance? {
        return self.device.whiteBalance()
    }
    
    func set(whiteBalance: VideoDevice.WhiteBalance) {
        self.device.handle.whiteBalanceMode = whiteBalance.raw
    }
    
}

extension VideoDevice.WhiteBalance {
    
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
