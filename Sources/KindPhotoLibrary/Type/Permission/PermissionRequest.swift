//
//  KindKit
//

import PhotosUI
#if os(iOS)
import UIKit
#endif
import KindPermission

public final class PermissionRequest : KindPermission.IRequest {
    
    public let access: Access
    public var status: KindPermission.Status {
        switch PHPhotoLibrary.kk_authorizationStatus(self.access) {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized, .limited: return .authorized
        default: return .denied
        }
    }
    
    public init(
        _ access: Access
    ) {
        self.access = access
    }
    
    public func request(_ completion: @escaping () -> Void) {
        if #available(macOS 11.0, iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: self.access.level, handler: { _ in
                DispatchQueue.main.async(execute: completion)
            })
        } else {
            PHPhotoLibrary.requestAuthorization({ _ in
                DispatchQueue.main.async(execute: completion)
            })
        }
    }
    
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
