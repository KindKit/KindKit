//
//  KindKit
//

import Foundation

public extension Discovery {
    
    struct Video {
        
        public let preset: VideoDevice.Preset
        public let device: VideoDevice
        
    }
    
}

public extension Session {
    
    func videoDevices(
        builtIns: [VideoDevice.BuiltIn],
        presets: [VideoDevice.Preset]
    ) -> [Discovery.Video] {
        var result: [Discovery.Video] = []
        let allDevices = self.videoDevices
        for builtIn in builtIns {
            guard let device = allDevices.first(where: { $0.builtIn == builtIn }) else {
                continue
            }
            for preset in presets {
                guard device.isPresetSupported(preset) == true else {
                    continue
                }
                result.append(.init(
                    preset: preset,
                    device: device
                ))
            }
        }
        return result
    }
    
    func videoDevice(
        positions: [VideoDevice.Position],
        builtIns: [VideoDevice.BuiltIn],
        presets: [VideoDevice.Preset]
    ) -> Discovery.Video? {
        let allDevices = self.videoDevices
        for position in positions {
            let devices = allDevices.filter({ position == $0.position })
            guard devices.isEmpty == false else {
                continue
            }
            for builtIn in builtIns {
                guard let device = devices.first(where: { $0.builtIn == builtIn }) else {
                    continue
                }
                for preset in presets {
                    guard device.isPresetSupported(preset) == true else {
                        continue
                    }
                    return .init(
                        preset: preset,
                        device: device
                    )
                }
            }
        }
        return nil
    }
    
}
