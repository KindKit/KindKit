//
//  KindKit
//

import Foundation
import KindDebug

public enum NetworkError : Swift.Error, Hashable, Equatable {
    
    case notConnected
    case lost
    case untrusted
    case cancelled
    case timeout
    
}

public extension NetworkError {
    
    init?(_ error: NSError) {
        switch error.domain {
        case NSURLErrorDomain:
            switch error.code {
            case NSURLErrorCancelled:
                self = .cancelled
            case NSURLErrorNetworkConnectionLost:
                self = .lost
            case NSURLErrorSecureConnectionFailed, NSURLErrorServerCertificateHasBadDate, NSURLErrorServerCertificateUntrusted, NSURLErrorServerCertificateHasUnknownRoot, NSURLErrorServerCertificateNotYetValid, NSURLErrorClientCertificateRejected, NSURLErrorClientCertificateRequired, NSURLErrorCannotLoadFromNetwork:
                self = .untrusted
            case NSURLErrorTimedOut:
                self = .timeout
            default:
                self = .notConnected
            }
        default:
            return nil
        }
    }
    
}

extension NetworkError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "NetworkError", sequenceBuilder: {
            switch self {
            case .notConnected: StringInfo("NotConnected")
            case .lost: StringInfo("Lost")
            case .untrusted: StringInfo("Untrusted")
            case .cancelled: StringInfo("Cancelled")
            case .timeout: StringInfo("Timeout")
            }
        })
    }
    
}

extension NetworkError : CustomStringConvertible {
}

extension NetworkError : CustomDebugStringConvertible {
}
