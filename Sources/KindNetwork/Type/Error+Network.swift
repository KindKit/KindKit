//
//  KindKit
//

import KindDebug

public extension Error {
    
    enum Network : Swift.Error, Hashable, Equatable {
        
        case notConnected
        case lost
        case untrusted
        case cancelled
        case timeout
        
    }
    
}

public extension Error.Network {
    
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

extension Error.Network : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .object(name: "Error.Network", info: {
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

extension Error.Network : CustomStringConvertible {
}

extension Error.Network : CustomDebugStringConvertible {
}
