//
//  KindKit
//

import Foundation

public extension Json {
    
    func get(
        path: Json.Path
    ) throws -> IJsonValue {
        guard var node = self.root else {
            throw Json.Error.Coding.access(self.path)
        }
        for itemIndex in path.items.indices {
            switch path.items[itemIndex] {
            case .key(let key):
                guard let dict = node as? NSDictionary else {
                    throw Json.Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                guard let child = dict[key] as? IJsonValue else {
                    throw Json.Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                node = child
            case .index(let index):
                guard let arr = node as? NSArray else {
                    throw Json.Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                guard index < arr.count else {
                    throw Json.Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                guard let child = arr[index] as? IJsonValue else {
                    throw Json.Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                node = child
            }
        }
        return node
    }
    
    @inlinable
    func get<
        Output
    >(
        path: Json.Path,
        decode: (IJsonValue, Json.Path) throws -> Output
    ) throws -> Output {
        let node = try self.get(path: path)
        return try decode(node, self.path.appending(path))
    }
    
    @inlinable
    func get<
        Note : IJsonValue,
        Output
    >(
        path: Json.Path,
        as: Note.Type,
        decode: (Note, Json.Path) throws -> Output
    ) throws -> Output {
        let node = try self.get(path: path)
        guard let node = node as? Note else {
            throw Json.Error.Coding.cast(self.path.appending(path))
        }
        return try decode(node, self.path.appending(path))
    }
    
}
