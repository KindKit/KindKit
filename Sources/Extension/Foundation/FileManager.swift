//
//  KindKit
//

import Foundation

public extension FileManager {
    
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
