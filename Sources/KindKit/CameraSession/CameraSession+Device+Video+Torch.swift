//
//  KindKit
//

import AVFoundation

public extension CameraSession.Device.Video {
    
    enum Torch {
        
        case auto
        case off
        case on(Double)
        
    }
    
}

public extension CameraSession.Device.Video.Torch {
    
    static var on: Self {
        return .on(1)
    }
    
}

public extension CameraSession.Device.Video {
    
    func isTorchSupported() -> Bool {
        return self.device.isTorchAvailable
    }
    
    func torch() -> Torch? {
        return .init(self.device)
    }
    
}

public extension CameraSession.Device.Video.Configuration {
    
    func isTorchSupported() -> Bool {
        return self.device.isTorchSupported()
    }
    
    func torch() -> CameraSession.Device.Video.Torch? {
        return self.device.torch()
    }
    
    func set(torch: CameraSession.Device.Video.Torch) {
        torch.apply(self.device.device)
    }
    
}

extension CameraSession.Device.Video.Torch {
    
    var raw: AVCaptureDevice.TorchMode {
        switch self {
        case .auto: return .auto
        case .off: return .off
        case .on: return .on
        }
    }
    
    init?(_ device: AVCaptureDevice) {
        switch device.torchMode {
        case .auto: self = .auto
        case .off: self = .off
        case .on: self = .on(Double(device.torchLevel))
        @unknown default: return nil
        }
    }
    
    func apply(_ device: AVCaptureDevice) {
        switch self {
        case .auto: device.torchMode = .auto
        case .off: device.torchMode = .off
        case .on(let level):
            device.torchMode = .on
            try! device.setTorchModeOn(level: max(0, min(Float(level), 1)))
        }
    }
    
}
