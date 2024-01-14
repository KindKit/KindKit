//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindSystem

public extension FileStorage {
        
#if os(iOS)
    
    @inlinable
    @discardableResult
    func append(name: String = UUID().uuidString, jpeg image: UIImage, compression: Double = 1.0) -> URL? {
        guard let data = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        return self.append(name: name, extension: "jpg", data: data)
    }
    
    @inlinable
    @discardableResult
    func append(name: String = UUID().uuidString, png image: UIImage) -> URL? {
        guard let data = image.pngData() else {
            return nil
        }
        return self.append(name: name, extension: "png", data: data)
    }
    
    @inlinable
    @discardableResult
    func append(name: String = UUID().uuidString, jpeg image: Image, compression: Double = 1.0) -> URL? {
        return self.append(name: name, jpeg: image.native, compression: compression)
    }
    
    @inlinable
    @discardableResult
    func append(name: String = UUID().uuidString, png image: Image) -> URL? {
        return self.append(name: name, png: image.native)
    }
    
#endif
    
}

public extension FileStorage {
    
    @inlinable
    func remove(jpg name: String) {
        self.remove(name: name, extension: "jpg")
    }
    
    @inlinable
    func remove(jpeg name: String) {
        self.remove(name: name, extension: "jpeg")
    }
    
    @inlinable
    func remove(png name: String) {
        self.remove(name: name, extension: "png")
    }
    
}

public extension FileStorage {
    
    @inlinable
    func contains(jpg name: String) -> Bool {
        return self.contains(name: name, extension: "jpg")
    }
    
    @inlinable
    func contains(jpeg name: String) -> Bool {
        return self.contains(name: name, extension: "jpeg")
    }
    
    @inlinable
    func contains(png name: String) -> Bool {
        return self.contains(name: name, extension: "png")
    }
    
}
