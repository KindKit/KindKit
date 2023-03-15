//
//  KindKit
//

import Foundation
import PhotosUI

public extension Permission {
    
    final class PhotoLibrary : Permission.Base {
        
        public let access: Access
        public override var status: Permission.Status {
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
            super.init()
        }
        
        public override func request(source: Any) {
            switch PHPhotoLibrary.kk_authorizationStatus(self.access) {
            case .notDetermined:
                self.willRequest(source: source)
                if #available(macOS 11.0, iOS 14, *) {
                    PHPhotoLibrary.requestAuthorization(for: self.access.level, handler: { [weak self] _ in
                        DispatchQueue.main.async(execute: {
                            self?.didRequest(source: source)
                        })
                    })
                } else {
                    PHPhotoLibrary.requestAuthorization({ [weak self] _ in
                        DispatchQueue.main.async(execute: {
                            self?.didRequest(source: source)
                        })
                    })
                }
            case .denied:
                self.redirectToSettings(source: source)
            default:
                break
            }
        }
        
    }
    
}

public extension IPermission where Self : Permission.PhotoLibrary {
    
    static func photoLibrary(
        _ access: Permission.PhotoLibrary.Access
    ) -> Self {
        return .init(access)
    }
    
}

fileprivate extension PHPhotoLibrary {
    
    @inline(__always)
    static func kk_authorizationStatus(_ access: Permission.PhotoLibrary.Access) -> PHAuthorizationStatus {
        if #available(macOS 11.0, iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: access.level)
        }
        return PHPhotoLibrary.authorizationStatus()
    }
    
}

