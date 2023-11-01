//
//  KindKit
//

import AVFoundation

public extension CameraSession.Recorder.Movie {
    
    enum Codec {
        
        case hevc
        case hevcWithAlpha
        case h264
        case proRes4444
        case proRes422
        case proRes422HQ
        case proRes422LT
        case proRes422Proxy
        
    }
    
}

extension CameraSession.Recorder.Movie.Codec {
    
    var raw: AVVideoCodecType {
        switch self {
        case .hevc: return .init(rawValue: "hvc1")
        case .hevcWithAlpha: return .init(rawValue: "muxa")
        case .h264: return .init(rawValue: "avc1")
        case .proRes4444: return .init(rawValue: "ap4h")
        case .proRes422: return .init(rawValue: "apcn")
        case .proRes422HQ: return .init(rawValue: "apch")
        case .proRes422LT: return .init(rawValue: "apcs")
        case .proRes422Proxy: return .init(rawValue: "apco")
        }
    }
    
    init?(_ raw: AVVideoCodecType) {
        switch raw.rawValue {
        case "hvc1": self = .hevc
        case "muxa": self = .hevcWithAlpha
        case "avc1": self = .h264
        case "ap4h": self = .proRes4444
        case "apcn": self = .proRes422
        case "apch": self = .proRes422HQ
        case "apcs": self = .proRes422LT
        case "apco": self = .proRes422Proxy
        default: return nil
        }
    }
    
}
