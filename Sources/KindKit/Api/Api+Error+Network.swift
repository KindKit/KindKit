//
//  KindKit
//

import Foundation

public extension Api.Error {
    
    enum Network : Swift.Error, Hashable, Equatable {
        
        case notConnected
        case lost
        case untrusted
        case cancelled
        case timeout
        
    }
    
}

public extension Api.Error.Network {
    
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

extension Api.Error.Network : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "Api.Error.Network", info: {
            switch self {
            case .notConnected: return .string("NotConnected")
            case .lost: return .string("Lost")
            case .untrusted: return .string("Untrusted")
            case .cancelled: return .string("Cancelled")
            case .timeout: return .string("Timeout")
            }
        })
    }
    
}

extension Api.Error.Network : CustomStringConvertible {
}

extension Api.Error.Network : CustomDebugStringConvertible {
}
