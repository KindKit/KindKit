//
//  KindKit
//

import Foundation

public extension Discovery {
    
    struct Video {
        
        public let preset: Device.Video.Preset
        public let device: Device.Video
        
    }
    
}

public extension Session {
    
    func videoDevices(
        builtIns: [Device.Video.BuiltIn],
        presets: [Device.Video.Preset]
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
        positions: [Device.Video.Position],
        builtIns: [Device.Video.BuiltIn],
        presets: [Device.Video.Preset]
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
