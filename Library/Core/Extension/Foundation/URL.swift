//
//  KindKit
//

import Foundation
#if os(macOS)
import Carbon
#elseif os(iOS)
import MobileCoreServices
#endif

public extension URL {
    
    var kk_mimeType: String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    var kk_containsImage: Bool {
        let mimeType = self.kk_mimeType
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }
    
    var kk_containsAudio: Bool {
        let mimeType = self.kk_mimeType
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
    
    var kk_containsVideo: Bool {
        let mimeType = self.kk_mimeType
        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }
    
}

public extension URL {
    
    @inlinable
    func kk_access(
        _ block: (URL) -> Void
    ) {
        if self.startAccessingSecurityScopedResource() == true {
            defer {
                self.stopAccessingSecurityScopedResource()
            }
            block(self)
        } else {
            block(self)
        }
    }
    
    @inlinable
    func kk_access(
        _ block: (URL) throws -> Void
    ) throws {
        if self.startAccessingSecurityScopedResource() == true {
            defer {
                self.stopAccessingSecurityScopedResource()
            }
            try block(self)
        } else {
            try block(self)
        }
    }
    
    @inlinable
    func kk_access< Result >(
        _ block: (URL) -> Result
    ) -> Result {
        if self.startAccessingSecurityScopedResource() == true {
            defer {
                self.stopAccessingSecurityScopedResource()
            }
            return block(self)
        }
        return block(self)
    }
    
    @inlinable
    func kk_access< Result >(
        _ block: (URL) throws -> Result
    ) throws -> Result {
        if self.startAccessingSecurityScopedResource() == true {
            defer {
                self.stopAccessingSecurityScopedResource()
            }
            return try block(self)
        }
        return try block(self)
    }

}
