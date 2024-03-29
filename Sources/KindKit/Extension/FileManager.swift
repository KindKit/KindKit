//
//  KindKit
//

import Foundation

public extension FileManager {
    
    @inlinable
    static var kk_homeUrl: URL {
        return URL(fileURLWithPath: NSHomeDirectory())
    }
    
    @inlinable
    static var kk_homePath: String {
        return NSHomeDirectory()
    }
    
    @inlinable
    static var kk_userDocumentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    @inlinable
    static var kk_userDocumentsPath: String {
        return Self.kk_userDocumentsUrl.path
    }
    
}

public extension FileManager {
    
    var kk_totalDiskSpace: Int64? {
        guard let attributes = try? self.attributesOfFileSystem(forPath: Self.kk_homePath) else { return nil }
        guard let space = attributes[.systemSize] as? NSNumber else { return nil }
        return space.int64Value
    }
    
    var kk_freeDiskSpace: Int64? {
        if #available(iOS 11.0, *) {
            guard let values = try? Self.kk_homeUrl.resourceValues(forKeys: [ .volumeAvailableCapacityForImportantUsageKey ]) else { return nil }
            guard let space = values.volumeAvailableCapacityForImportantUsage else { return nil }
            return space
        } else {
            guard let attributes = try? self.attributesOfFileSystem(forPath: Self.kk_homePath) else { return nil }
            guard let space = attributes[.systemFreeSize] as? NSNumber else { return nil }
            return space.int64Value
        }
    }
    
    var kk_usedDiskSpace: Int64? {
        guard let totalDiskSpace = self.kk_totalDiskSpace else { return nil }
        guard let freeDiskSpace = self.kk_freeDiskSpace else { return nil }
        return totalDiskSpace - freeDiskSpace
    }
    
}

public extension FileManager {
    
    func kk_fileSize(
        at url: URL
    ) -> UInt64 {
        return url.kk_access({
            guard let attributes = try? self.attributesOfItem(atPath: $0.path) else { return 0 }
            guard let size = attributes[.size] as? UInt64 else { return 0 }
            return size
        })
    }
    
    func kk_contents(
        at url: URL
    ) -> [URL] {
        guard let urls = try? self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return []
        }
        return urls
    }
    
    func kk_contents(
        at url: URL,
        olderThan: TimeInterval
    ) -> [URL] {
        let now = Date()
        return self.kk_contents(at: url).compactMap({
            guard let attributes = try? self.attributesOfItem(atPath: $0.path) else { return nil }
            guard let updatedAt = attributes[.modificationDate] as? Date else { return nil }
            guard now.timeIntervalSince1970 - updatedAt.timeIntervalSince1970 > olderThan else { return nil }
            return $0
        })
    }
    
    func kk_files(
        at url: URL,
        recursive: Bool
    ) -> [URL] {
        guard let contents = try? self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return []
        }
        var result: [URL] = []
        for content in contents {
            if content.hasDirectoryPath == true {
                if recursive == true {
                    result.append(contentsOf: self.kk_files(at: content, recursive: recursive))
                }
            } else {
                result.append(content)
            }
        }
        return result
    }
    
    func kk_files(
        at url: URL,
        olderThan: TimeInterval,
        recursive: Bool
    ) -> [URL] {
        let now = Date()
        return self.kk_files(at: url, recursive: recursive).compactMap({
            guard let attributes = try? self.attributesOfItem(atPath: $0.path) else { return nil }
            guard let updatedAt = attributes[.modificationDate] as? Date else { return nil }
            guard now.timeIntervalSince1970 - updatedAt.timeIntervalSince1970 > olderThan else { return nil }
            return $0
        })
    }
    
}
