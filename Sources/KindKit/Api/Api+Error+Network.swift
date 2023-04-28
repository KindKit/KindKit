//
//  KindKit
//

import Foundation

public extension Api.Error {
    
    enum Network : Swift.Error {
        
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
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Api.Error.Network")
        switch self {
        case .notConnected: buff.append(inter: indent, value: "NotConnected")
        case .lost: buff.append(inter: indent, value: "Lost")
        case .untrusted: buff.append(inter: indent, value: "Untrusted")
        case .cancelled: buff.append(inter: indent, value: "Cancelled")
        case .timeout: buff.append(inter: indent, value: "Timeout")
        }
    }
    
}
