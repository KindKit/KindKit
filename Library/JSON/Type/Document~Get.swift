//
//  KindKit
//

import Foundation

public extension Document {
    
    func find(
        in path: Path
    ) -> Result< Field, AccessError > {
        guard var node = self.root else {
            return .failure(AccessError(in: .root))
        }
        for itemIndex in path.items.indices {
            switch path.items[itemIndex] {
            case .key(let key):
                guard let dict = node as? NSDictionary else {
                    return .failure(AccessError(
                        in: self.path.appending(path, to: itemIndex + 1)
                    ))
                }
                guard let child = dict[key] as? Field else {
                    return .failure(AccessError(
                        in: self.path.appending(path, to: itemIndex + 1)
                    ))
                }
                node = child
            case .index(let index):
                guard let arr = node as? NSArray else {
                    return .failure(AccessError(
                        in: self.path.appending(path, to: itemIndex + 1)
                    ))
                }
                guard index < arr.count else {
                    return .failure(AccessError(
                        in: self.path.appending(path, to: itemIndex + 1)
                    ))
                }
                guard let child = arr[index] as? Field else {
                    return .failure(AccessError(
                        in: self.path.appending(path, to: itemIndex + 1)
                    ))
                }
                node = child
            }
        }
        return .success(node)
    }
    
    func get(
        in path: Path
    ) throws -> Field {
        switch self.find(in: path) {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    @inlinable
    func get<
        Output
    >(
        in path: Path,
        decodeValue: (Field, Path) throws -> Output,
        decodeError: (AccessError, Path) throws -> Output
    ) throws -> Output {
        let fullPath = self.path.appending(path)
        switch self.find(in: path) {
        case .success(let value):
            return try decodeValue(value, fullPath)
        case .failure(let error):
            return try decodeError(error, fullPath)
        }
    }
    
}
