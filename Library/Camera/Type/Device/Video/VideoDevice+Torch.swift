//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    enum Torch {
        
        case auto
        case off
        case on(Double)
        
    }
    
}

extension VideoDevice.Torch : Hashable {
}

extension VideoDevice.Torch : Equatable {
}

extension VideoDevice.Torch : Sendable {
}

public extension VideoDevice.Torch {
    
    static var on: Self {
        return .on(1)
    }
    
}

public extension VideoDevice {
    
    func isTorchSupported() -> Bool {
        return self.handle.isTorchAvailable
    }
    
    func torch() -> Torch? {
        return .init(self.handle)
    }
    
}

public extension VideoDevice.Configuration {
    
    func isTorchSupported() -> Bool {
        return self.device.isTorchSupported()
    }
    
    func torch() -> VideoDevice.Torch? {
        return self.device.torch()
    }
    
    func set(torch: VideoDevice.Torch) {
        torch.apply(self.device.handle)
    }
    
}

extension VideoDevice.Torch {
    
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
