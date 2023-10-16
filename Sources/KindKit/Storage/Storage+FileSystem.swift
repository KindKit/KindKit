//
//  KindKit
//

public extension Storage {
    
    final class FileSystem {
        
        public let path: [String]
        public let url: URL
        
        private let _fs = FileManager.default
        
        public init?(path: [String]) {
            guard path.isEmpty == false else { return nil }
            self.path = path
            self.url = path.reduce(FileManager.kk_userDocumentsUrl, {
                if #available(macOS 13.0, iOS 16.0, *) {
                    return $0.appending(path: $1)
                } else {
                    return $0.appendingPathComponent($1)
                }
            })
            if self._fs.fileExists(atPath: self.url.path) == false {
                do {
                    try self._fs.createDirectory(at: self.url, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    return nil
                }
            }
        }
        
        public convenience init?(_ name: String) {
            self.init(path: [ name ])
        }
        
        public convenience init?(_ name: String, parent: Storage.FileSystem) {
            self.init(path: parent.path.kk_appending(name))
        }
        
    }
    
}

public extension Storage.FileSystem {
    
    @inlinable
    func url(name: String, `extension`: String) -> URL {
        return self.url.appendingPathComponent("\(name).\(`extension`)")
    }
    
    @inlinable
    func url(jpg name: String) -> URL {
        return self.url(name: name, extension: "jpg")
    }
    
    @inlinable
    func url(jpeg name: String) -> URL {
        return self.url(name: name, extension: "jpeg")
    }
    
    @inlinable
    func url(png name: String) -> URL {
        return self.url(name: name, extension: "png")
    }
    
}

public extension Storage.FileSystem {
    
    @inlinable
    func data(name: String, `extension`: String) -> Data? {
        let url = self.url(name: name, extension: `extension`)
        return try? Data(contentsOf: url)
    }
    
    @inlinable
    func data(jpg name: String) -> Data? {
        return self.data(name: name, extension: "jpg")
    }
    
    @inlinable
    func data(jpeg name: String) -> Data? {
        return self.data(name: name, extension: "jpeg")
    }
    
    @inlinable
    func data(png name: String) -> Data? {
        return self.data(name: name, extension: "png")
    }
    
}

public extension Storage.FileSystem {
    
    @discardableResult
    func append(url: URL) -> URL? {
        if url.isFileURL == false {
            return url
        }
        let base = url.deletingLastPathComponent()
        if base.absoluteString == self.url.absoluteString {
            return url
        }
        let newUrl = self.url.appendingPathComponent(url.lastPathComponent)
        if self._fs.fileExists(atPath: newUrl.path) == false {
            do {
                try url.kk_access({
                    try self._fs.copyItem(at: $0, to: newUrl)
                })
            } catch {
                return nil
            }
        }
        return newUrl
    }
    
    @discardableResult
    func append(name: String = UUID().uuidString, `extension`: String, data: Data) -> URL? {
        do {
            let url = self.url(name: name, extension: `extension`)
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }
    
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
    func append(name: String = UUID().uuidString, jpeg image: UI.Image, compression: Double = 1.0) -> URL? {
        return self.append(name: name, jpeg: image.native, compression: compression)
    }
    
    @inlinable
    @discardableResult
    func append(name: String = UUID().uuidString, png image: UI.Image) -> URL? {
        return self.append(name: name, png: image.native)
    }
    
#endif
    
}

public extension Storage.FileSystem {
    
    @inlinable
    func remove(name: String, `extension`: String) {
        self.remove(url: self.url(name: name, extension: `extension`))
    }
    
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
    
    func remove(url: URL) {
        guard self.contains(url: url) else { return }
        try? self._fs.removeItem(at: url)
    }
    
}

public extension Storage.FileSystem {
    
    func contains(name: String, `extension`: String) -> Bool {
        let url = self.url(name: name, extension: `extension`)
        guard url == self.url else { return false }
        return self._fs.fileExists(atPath: url.path)
    }
    
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
    
    func contains(url: URL) -> Bool {
        guard url.isFileURL == true else { return false }
        let base = url.deletingLastPathComponent()
        guard base.absoluteString == self.url.absoluteString else { return false }
        return self._fs.fileExists(atPath: url.path)
    }
    
}

public extension Storage.FileSystem {
    
    func clear(before: TimeInterval? = nil, recursive: Bool = false) {
        let urls: [URL]
        if let before = before {
            urls = self._fs.kk_files(at: self.url, olderThan: before, recursive: recursive)
        } else {
            urls = self._fs.kk_files(at: self.url, recursive: recursive)
        }
        for url in urls {
            try? self._fs.removeItem(at: url)
        }
    }
    
    func delete() {
        try? self._fs.removeItem(at: self.url)
    }
    
}
