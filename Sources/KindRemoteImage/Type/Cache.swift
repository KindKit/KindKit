//
//  KindKit
//

import Foundation
import KindCore
import KindGraphics
import KindSystem

public final class Cache {
    
    public private(set) var name: String
    public private(set) var config: Config
    public private(set) var url: URL
    
    private var _memory: [String: Image] = [:]
    private var _fileManager = FileManager.default
    private var _lock = Lock()

    public init(
        name: String,
        config: Config = .init()
    ) throws {
        self.name = name
        self.config = config
        if let cachePath = self._fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.url = cachePath
        } else {
            self.url = URL(fileURLWithPath: NSHomeDirectory())
        }
        self.url.appendPathComponent(name)
        if self._fileManager.fileExists(atPath: self.url.path) == false {
            try self._fileManager.createDirectory(at: self.url, withIntermediateDirectories: true, attributes: nil)
        }
        self._setup()
    }
    
    deinit {
        self._destroy()
    }
    
}

public extension Cache {
    
    static let shared: Cache = try! Cache(
        name: "RemoteImageCache"
    )
    
}

public extension Cache {
    
    func isExist(query: IQuery) -> Bool {
        guard let key = self._key(query) else { return false }
        return self.isExist(key: key)
    }

    func isExist(query: IQuery, filter: IFilter) -> Bool {
        guard let key = self._key(query, filter) else { return false }
        return self.isExist(key: key)
    }
    
    func isExist(key: String) -> Bool {
        let memoryImage = self._lock.perform({
            return self._memory[key]
        })
        if memoryImage != nil {
            return true
        }
        let url = self.url.appendingPathComponent(key)
        return self._fileManager.fileExists(atPath: url.path)
    }
    
}

public extension Cache {
    
    func image(query: IQuery) -> Image? {
        guard let key = self._key(query) else { return nil }
        return self.image(key: key)
    }
    
    func image(query: IQuery, filter: IFilter) -> Image? {
        guard let key = self._key(query, filter) else { return nil }
        return self.image(key: key)
    }

    func image(key: String) -> Image? {
        let memoryImage = self._lock.perform({
            return self._memory[key]
        })
        if let image = memoryImage {
            return image
        }
        let url = self.url.appendingPathComponent(key)
        if let image = Image(url: url) {
            if self._canStoreInMemory(image: image) == true {
                self._lock.perform({
                    self._memory[key] = image
                })
            }
            return image
        }
        return nil
    }
    
}

public extension Cache {
    
    func set(data: Data, image: Image, query: IQuery) throws {
        guard let key = self._key(query) else { return }
        try self.set(data: data, image: image, key: key)
    }
    
    func set(data: Data, image: Image, query: IQuery, filter: IFilter) throws {
        guard let key = self._key(query, filter) else { return }
        try self.set(data: data, image: image, key: key)
    }

    func set(data: Data, image: Image, key: String) throws {
        let url = self.url.appendingPathComponent(key)
        try data.write(to: url, options: .atomic)
        if self._canStoreInMemory(image: image) == true {
            self._lock.perform({
                self._memory[key] = image
            })
        }
    }
    
}

public extension Cache {
    
    func remove(query: IQuery) throws {
        guard let key = self._key(query) else { return }
        try self.remove(key: key)
    }
    
    func remove(query: IQuery, filter: IFilter) throws {
        guard let key = self._key(query, filter) else { return }
        try self.remove(key: key)
    }

    func remove(key: String) throws {
        self._lock.perform({
            _ = self._memory.removeValue(forKey: key)
        })
        let url = self.url.appendingPathComponent(key)
        if self._fileManager.fileExists(atPath: url.path) == true {
            try self._fileManager.removeItem(at: url)
        }
    }
    
}

public extension Cache {

    func cleanup(before: TimeInterval) {
        self.cleanupMemory()
        let urls = self._fileManager.kk_contents(at: self.url, olderThan: before)
        for url in urls {
            try? self._fileManager.removeItem(at: url)
        }
    }

    func cleanupMemory() {
        self._lock.perform({
            self._memory.removeAll()
        })
    }

}

private extension Cache {
    
    func _setup() {
        AppState.default.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        AppState.default.remove(observer: self)
    }
    
    @inline(__always)
    func _key(_ query: IQuery) -> String? {
        let key = query.key
        if let sha256 = key.kk_sha256 {
            return sha256
        }
        return nil
    }
    
    @inline(__always)
    func _key(_ query: IQuery, _ filter: IFilter) -> String? {
        let key = "{\(filter.name)}{\(query.key)}"
        if let sha256 = key.kk_sha256 {
            return sha256
        }
        return nil
    }
    
    @inline(__always)
    func _canStoreInMemory(image: Image) -> Bool {
        return image.size.area.value < self.config.memory.maxImageArea
    }
    
}

extension Cache : IAppStateObserver {
    
    public func didEnterBackground(_ appState: AppState) {
        self.cleanupMemory()
    }
    
    public func didMemoryWarning(_ appState: AppState) {
        self.cleanupMemory()
    }
    
}
