//
//  KindKit
//

import AVFoundation

public final class VideoDevice {
    
    public let handle: AVCaptureDevice
    public let input: AVCaptureDeviceInput
    public let position: Position
    public let builtIn: BuiltIn
    
    init?(
        _ handle: AVCaptureDevice
    ) {
        guard let position = Position(handle.position) else {
            return nil
        }
        guard let builtIn = BuiltIn(handle.deviceType) else {
            return nil
        }
        guard let input = try? AVCaptureDeviceInput(device: handle) else {
            return nil
        }
        self.handle = handle
        self.input = input
        self.position = position
        self.builtIn = builtIn
    }
    
}

extension VideoDevice : Equatable {
    
    public static func == (lhs: VideoDevice, rhs: VideoDevice) -> Bool {
        return lhs === rhs
    }
    
}

extension VideoDevice : @unchecked Sendable {
}

public extension VideoDevice {
    
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
