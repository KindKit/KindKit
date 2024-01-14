//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

extension Player {
    
    public enum Error {
        
        case unknown
        case notFound
        case unauthorized
        case authenticationError
        case forbidden
        case unavailable
        case mediaFileError
        case bandwidthExceeded
        case playlistUnchanged
        case decoderMalfunction
        case decoderTemporarilyUnavailable
        case wrongHostIP
        case wrongHostDNS
        case badURL
        case invalidRequest
        
    }

    
}

#endif
