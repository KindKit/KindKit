//
//  KindKit
//

import Foundation

public extension Document {
    
    func get(
        path: Path
    ) throws -> IValue {
        guard var node = self.root else {
            throw Error.Coding.access(self.path)
        }
        for itemIndex in path.items.indices {
            switch path.items[itemIndex] {
            case .key(let key):
                guard let dict = node as? NSDictionary else {
                    throw Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                guard let child = dict[key] as? IValue else {
                    throw Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                node = child
            case .index(let index):
                guard let arr = node as? NSArray else {
                    throw Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                guard index < arr.count else {
                    throw Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
                }
                guard let child = arr[index] as? IValue else {
                    throw Error.Coding.access(self.path.appending(path, to: itemIndex + 1))
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
        path: Path,
        decode: (IValue, Path) throws -> Output
    ) throws -> Output {
        let node = try self.get(path: path)
        return try decode(node, self.path.appending(path))
    }
    
    @inlinable
    func get<
        Note : IValue,
        Output
    >(
        path: Path,
        as: Note.Type,
        decode: (Note, Path) throws -> Output
    ) throws -> Output {
        let node = try self.get(path: path)
        guard let node = node as? Note else {
            throw Error.Coding.cast(self.path.appending(path))
        }
        return try decode(node, self.path.appending(path))
    }
    
}
