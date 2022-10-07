//
//  KindKit
//

import Foundation

public extension RemoteImage {

    final class Cache {

        public private(set) var name: String
        public private(set) var memory: [String: UI.Image]
        public private(set) var url: URL
        
        private let _appState: AppState
        private var _fileManager: FileManager
        private var _queue: DispatchQueue

        public init(name: String) throws {
            self.name = name
            self.memory = [:]
            self._appState = .init()
            self._fileManager = FileManager.default
            self._queue = DispatchQueue(label: "KindKit.RemoteImage.Cache")
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

}

public extension RemoteImage.Cache {
    
    static let shared: RemoteImage.Cache = try! RemoteImage.Cache(
        name: "RemoteImageCache"
    )
    
}

public extension RemoteImage.Cache {
    
    func isExist(query: IRemoteImageQuery) -> Bool {
        guard let key = self._key(query) else { return false }
        return self.isExist(key: key)
    }

    func isExist(query: IRemoteImageQuery, filter: IRemoteImageFilter) -> Bool {
        guard let key = self._key(query, filter) else { return false }
        return self.isExist(key: key)
    }
    
    func isExist(key: String) -> Bool {
        let memoryImage = self._queue.sync(execute: { return self.memory[key] })
        if memoryImage != nil {
            return true
        }
        let url = self.url.appendingPathComponent(key)
        return self._fileManager.fileExists(atPath: url.path)
    }
    
}

public extension RemoteImage.Cache {
    
    func image(query: IRemoteImageQuery) -> UI.Image? {
        guard let key = self._key(query) else { return nil }
        return self.image(key: key)
    }
    
    func image(query: IRemoteImageQuery, filter: IRemoteImageFilter) -> UI.Image? {
        guard let key = self._key(query, filter) else { return nil }
        return self.image(key: key)
    }

    func image(key: String) -> UI.Image? {
        let memoryImage = self._queue.sync(execute: { return self.memory[key] })
        if let image = memoryImage {
            return image
        }
        let url = self.url.appendingPathComponent(key)
        if let image = UI.Image(url: url) {
            self._queue.sync(flags: .barrier, execute: {
                self.memory[key] = image
            })
            return image
        }
        return nil
    }
    
}

public extension RemoteImage.Cache {
    
    func set(data: Data, image: UI.Image, query: IRemoteImageQuery) throws {
        guard let key = self._key(query) else { return }
        try self.set(data: data, image: image, key: key)
    }
    
    func set(data: Data, image: UI.Image, query: IRemoteImageQuery, filter: IRemoteImageFilter) throws {
        guard let key = self._key(query, filter) else { return }
        try self.set(data: data, image: image, key: key)
    }

    func set(data: Data, image: UI.Image, key: String) throws {
        let url = self.url.appendingPathComponent(key)
        try data.write(to: url, options: .atomic)
        self._queue.sync(flags: .barrier, execute: {
            self.memory[key] = image
        })
    }
    
}

public extension RemoteImage.Cache {
    
    func remove(query: IRemoteImageQuery) throws {
        guard let key = self._key(query) else { return }
        try self.remove(key: key)
    }
    
    func remove(query: IRemoteImageQuery, filter: IRemoteImageFilter) throws {
        guard let key = self._key(query, filter) else { return }
        try self.remove(key: key)
    }

    func remove(key: String) throws {
        self._queue.sync(flags: .barrier, execute: {
            _ = self.memory.removeValue(forKey: key)
        })
        let url = self.url.appendingPathComponent(key)
        if self._fileManager.fileExists(atPath: url.path) == true {
            try self._fileManager.removeItem(at: url)
        }
    }
    
}

public extension RemoteImage.Cache {

    func cleanup(before: TimeInterval) {
        self.cleanupMemory()
        let now = Date()
        if let urls = try? self._fileManager.contentsOfDirectory(at: self.url, includingPropertiesForKeys: nil, options: [ .skipsHiddenFiles ]) {
            for url in urls {
                guard
                    let attributes = try? self._fileManager.attributesOfItem(atPath: url.path),
                    let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date
                else {
                    continue
                }
                let delta = now.timeIntervalSince1970 - modificationDate.timeIntervalSince1970
                if delta > before {
                    try? self._fileManager.removeItem(at: url)
                }
            }
        }
    }

    func cleanupMemory() {
        self._queue.sync(flags: .barrier, execute: {
            self.memory.removeAll()
        })
    }

}

private extension RemoteImage.Cache {
    
    func _setup() {
        self._appState.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self._appState.remove(observer: self)
    }
    
    func _key(_ query: IRemoteImageQuery) -> String? {
        let key = query.key
        if let sha256 = key.kk_sha256 {
            return sha256
        }
        return nil
    }
    
    func _key(_ query: IRemoteImageQuery, _ filter: IRemoteImageFilter) -> String? {
        let key = "{\(filter.name)}{\(query.key)}"
        if let sha256 = key.kk_sha256 {
            return sha256
        }
        return nil
    }
    
}

extension RemoteImage.Cache : IAppStateObserver {
    
    public func didEnterBackground(_ appState: AppState) {
        self.cleanupMemory()
    }
    
    public func didMemoryWarning(_ appState: AppState) {
        self.cleanupMemory()
    }
    
}
