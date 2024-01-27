//
//  KindKit
//

import AVFoundation

public final class AudioDevice {
    
    public let handle: AVCaptureDevice
    public let input: AVCaptureDeviceInput
    
    init?(
        _ handle: AVCaptureDevice
    ) {
        guard let input = try? AVCaptureDeviceInput(device: handle) else {
            return nil
        }
        self.handle = handle
        self.input = input
    }
    
}

extension AudioDevice : Equatable {
    
    public static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        return lhs === rhs
    }
    
}

extension AudioDevice : @unchecked Sendable {
}

public extension AudioDevice {
    
    @discardableResult
    func configuration(_ block: @Sendable (Configuration) -> Void) -> Bool {
        do {
            try self.handle.lockForConfiguration()
            block(.init(self))
            self.handle.unlockForConfiguration()
        } catch {
            return false
        }
        return true
    }
    
}
