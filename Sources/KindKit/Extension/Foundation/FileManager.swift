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
        guard let attributes = try? self.attributesOfItem(atPath: url.path) else { return 0 }
        return (attributes[.size] as? UInt64) ?? 0
    }
    
    func kk_contents(
        at url: URL
    ) -> [(url: URL, attributes: [FileAttributeKey : Any])] {
        guard let urls = try? self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [ .skipsHiddenFiles ]) else {
            return []
        }
        return urls.compactMap({
            guard let attributes = try? self.attributesOfItem(atPath: $0.path) else { return nil }
            return (url: $0, attributes: attributes)
        })
    }
    
    func kk_contents(
        at url: URL,
        olderThan: TimeInterval
    ) -> [URL] {
        let now = Date()
        return self.kk_contents(at: url).compactMap({
            guard let updatedAt = $0.attributes[.modificationDate] as? Date else { return nil }
            guard now.timeIntervalSince1970 - updatedAt.timeIntervalSince1970 > olderThan else { return nil }
            return $0.url
        })
    }
    
}
