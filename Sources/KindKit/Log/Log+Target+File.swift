//
//  KindKit
//

import Foundation

public extension Log.Target {
    
    final class File {
        
        public let folder: URL
        public let fileName: String
        public let fileExtension: String
        public let sizePolicy: SizePolicy
        public let encoding: String.Encoding
        
        private let _queue: DispatchQueue
        private let _dateFormatter: StringFormatter.Date
        private var _stream: Stream?
        
        public init(
            folderName: String,
            fileName: String,
            fileExtension: String,
            sizePolicy: SizePolicy,
            encoding: String.Encoding = .utf8
        ) {
            self.folder = FileManager.kk_userDocumentsUrl.appendingPathComponent(folderName)
            if FileManager.default.fileExists(atPath: self.folder.path) == false {
                try? FileManager.default.createDirectory(at: self.folder, withIntermediateDirectories: true, attributes: nil)
            }
            self.fileName = fileName
            self.fileExtension = fileExtension
            self.sizePolicy = sizePolicy
            self.encoding = encoding
            self._queue = .init(label: "KindKit.Log.Target.File")
            self._dateFormatter = StringFormatter.Date(format: "yy-MM-dd-HH-mm-ss")
        }
        
    }
    
}

extension Log.Target.File : ILogTarget {
    
    public var files: [URL] {
        return FileManager.default.kk_contents(at: self.folder).compactMap({ item -> (url: URL, createdAt: Date)? in
            guard let createdAt = item.attributes[.creationDate] as? Date else { return nil }
            return (url: item.url, createdAt: createdAt)
        }).sorted(by: {
            return $0.createdAt > $1.createdAt
        }).map({
            return $0.url
        })
    }
    
    public func log(level: Log.Level, category: String, message: String) {
        let now = Date()
        self._queue.async(execute: { [weak self] in
            guard let self = self else {
                return
            }
            let marker = self._dateFormatter.format(now)
            let line = "[\(marker)]: [\(category)]: \(message)\r"
            guard let data = line.data(using: .utf8) else {
                return
            }
            if let stream = try? self._activeStream() {
                stream.write(data: data)
            }
        })
    }
    
}

private extension Log.Target.File {
    
    func _activeStream() throws -> Stream {
        if let stream = self._stream {
            if stream.size < self.sizePolicy.maxFileSize {
                return stream
            }
        }
        let items = FileManager.default.kk_contents(at: self.folder).compactMap({ item -> (url: URL, createdAt: Date, size: UInt64)? in
            guard let createdAt = item.attributes[.creationDate] as? Date else { return nil }
            guard let size = item.attributes[.size] as? UInt64 else { return nil }
            return (url: item.url, createdAt: createdAt, size: size)
        }).sorted(by: {
            return $0.createdAt > $1.createdAt
        })
        if items.count >= self.sizePolicy.maxNumberOfFiles {
            let lower = self.sizePolicy.maxNumberOfFiles
            let upper = items.count
            for item in items[lower..<upper] {
                try? FileManager.default.removeItem(at: item.url)
            }
        }
        if let item = items.first {
            if item.size < self.sizePolicy.maxFileSize {
                let stream = try self._createStream(with: item.url)
                self._stream = stream
                return stream
            }
        }
        let stream = try self._createStream()
        self._stream = stream
        return stream
    }
    
    func _createStream() throws -> Stream {
        let marker = self._dateFormatter.format(Date())
        return try self._createStream(
            with: self.folder.appendingPathComponent("\(self.fileName)-\(marker).\(self.fileExtension)")
        )
    }
    
    func _createStream(with url: URL) throws -> Stream {
        if FileManager.default.fileExists(atPath: url.path) == false {
            if FileManager.default.createFile(atPath: url.path, contents: nil) == false {
                throw NSError(domain: NSPOSIXErrorDomain, code: NSFileNoSuchFileError)
            }
        }
        guard let stream = Stream(url: url) else {
            throw NSError(domain: NSPOSIXErrorDomain, code: NSFileNoSuchFileError)
        }
        return stream
    }
    
}
