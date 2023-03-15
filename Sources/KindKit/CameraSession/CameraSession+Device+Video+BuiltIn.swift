//
//  KindKit
//

import AVFoundation

public extension CameraSession.Device.Video {
    
    enum BuiltIn : CaseIterable {
        
        case wideAngle
        case external
        case deskView
        case telephoto
        case dual
        case ultraWide
        case dualWide
        case triple
        case trueDepth
        case lidarDepthCamera
        
    }
    
}

extension CameraSession.Device.Video.BuiltIn {
    
    var raw: AVCaptureDevice.DeviceType? {
        switch self {
        case .wideAngle:
            return .builtInWideAngleCamera
        case .external:
#if os(macOS)
            return .externalUnknown
#else
            return nil
#endif
        case .deskView:
#if os(macOS)
            if #available(macOS 13.0, *) {
                return .deskViewCamera
            }
#endif
            return nil
        case .telephoto:
#if os(iOS)
            return .builtInTelephotoCamera
#else
            return nil
#endif
        case .dual:
#if os(iOS)
            return .builtInDualCamera
#else
            return nil
#endif
        case .ultraWide:
#if os(iOS)
            if #available(iOS 13.0, *) {
                return .builtInUltraWideCamera
            }
#endif
            return nil
        case .dualWide:
#if os(iOS)
            if #available(iOS 13.0, *) {
                return .builtInDualWideCamera
            }
#endif
            return nil
        case .triple:
#if os(iOS)
            if #available(iOS 13.0, *) {
                return .builtInTripleCamera
            }
#endif
            return nil
        case .trueDepth:
#if os(iOS)
            if #available(iOS 13.0, *) {
                return .builtInTrueDepthCamera
            }
#endif
            return nil
        case .lidarDepthCamera:
#if os(iOS)
            if #available(iOS 15.4, *) {
                return .builtInLiDARDepthCamera
            }
#endif
            return nil
        }
    }
    
    init?(_ raw: AVCaptureDevice.DeviceType) {
#if os(macOS)
        if #available(macOS 13.0, *) {
            if raw == .builtInWideAngleCamera {
                self = .wideAngle
            } else if raw == .externalUnknown {
                self = .external
            } else if raw == .deskViewCamera {
                self = .deskView
            } else {
                return nil
            }
        } else {
            if raw == .builtInWideAngleCamera {
                self = .wideAngle
            } else if raw == .externalUnknown {
                self = .external
            } else {
                return nil
            }
        }
#elseif os(iOS)
        if #available(iOS 15.4, *) {
            if raw == .builtInWideAngleCamera {
                self = .wideAngle
            } else if raw == .builtInTelephotoCamera {
                self = .telephoto
            } else if raw == .builtInDualCamera {
                self = .dual
            } else if raw == .builtInUltraWideCamera {
                self = .ultraWide
            } else if raw == .builtInDualWideCamera {
                self = .dualWide
            } else if raw == .builtInTripleCamera {
                self = .triple
            } else if raw == .builtInTrueDepthCamera {
                self = .trueDepth
            } else if raw == .builtInLiDARDepthCamera {
                self = .lidarDepthCamera
            } else {
                return nil
            }
        } else if #available(iOS 13.0, *) {
            if raw == .builtInWideAngleCamera {
                self = .wideAngle
            } else if raw == .builtInTelephotoCamera {
                self = .telephoto
            } else if raw == .builtInDualCamera {
                self = .dual
            } else if raw == .builtInUltraWideCamera {
                self = .ultraWide
            } else if raw == .builtInDualWideCamera {
                self = .dualWide
            } else if raw == .builtInTripleCamera {
                self = .triple
            } else if raw == .builtInTrueDepthCamera {
                self = .trueDepth
            } else {
                return nil
            }
        } else {
            if raw == .builtInWideAngleCamera {
                self = .wideAngle
            } else {
                return nil
            }
        }
#endif
    }
    
}
