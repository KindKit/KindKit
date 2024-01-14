//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public final class FileStorage {
    
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
    
    public convenience init?(_ name: String, parent: FileStorage) {
        self.init(path: parent.path.kk_appending(name))
    }
    
}

public extension FileStorage {
    
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

public extension FileStorage {
    
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

public extension FileStorage {
    
    @discardableResult
    func append(url: URL) -> URL? {
        if url.isFileURL == false {
            return url
        }
        let base = url.deletingLastPathComponent()
        if base == self.url {
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
    
    @inlinable
    @discardableResult
    func append(_ file: TemporaryFile) -> URL? {
        return self.append(url: file.url)
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
    
}

public extension FileStorage {
    
    @inlinable
    func remove(name: String, `extension`: String) {
        self.remove(url: self.url(name: name, extension: `extension`))
    }
    
    func remove(url: URL) {
        guard self.contains(url: url) else { return }
        try? self._fs.removeItem(at: url)
    }
    
}

public extension FileStorage {
    
    func contains(name: String, `extension`: String) -> Bool {
        let url = self.url(name: name, extension: `extension`)
        guard url == self.url else { return false }
        return self._fs.fileExists(atPath: url.path)
    }
    
    func contains(url: URL) -> Bool {
        guard url.isFileURL == true else { return false }
        let base = url.deletingLastPathComponent()
        guard base.absoluteString == self.url.absoluteString else { return false }
        return self._fs.fileExists(atPath: url.path)
    }
    
}

public extension FileStorage {
    
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
