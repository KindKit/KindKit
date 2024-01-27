//
//  KindKit
//

import PhotosUI
#if os(iOS)
import UIKit
#endif
import KindPermission

public final class PermissionRequest : KindPermission.Request {
    
    public let access: Access
    
    public init(
        _ access: Access
    ) {
        self.access = access
    }
    
    public func status() async -> KindPermission.Status {
        return await Task(operation: {
            switch PHPhotoLibrary.kk_authorizationStatus(self.access) {
            case .notDetermined: return .notDetermined
            case .denied, .restricted: return .denied
            case .authorized, .limited: return .authorized
            default: return .denied
            }
        }).value
    }
    
    public func request() async {
        if #available(macOS 11.0, iOS 14, *) {
            await PHPhotoLibrary.requestAuthorization(for: self.access.level)
        } else {
            await withUnsafeContinuation({ continuation in
                PHPhotoLibrary.requestAuthorization({ _ in
                    continuation.resume()
                })
            })
        }
    }
    
}

extension PermissionRequest : @unchecked Sendable {
}

fileprivate extension PHPhotoLibrary {
    
    @inline(__always)
    static func kk_authorizationStatus(_ access: PermissionRequest.Access) -> PHAuthorizationStatus {
        if #available(macOS 11.0, iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: access.level)
        }
        return PHPhotoLibrary.authorizationStatus()
    }
    
}
