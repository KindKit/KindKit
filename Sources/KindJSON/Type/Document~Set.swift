//
//  KindKit
//

import Foundation

public extension Document {
    
    func set(
        path: Path,
        encode: (Path) throws -> IValue?
    ) throws {
        if self.root == nil {
            if path.isRoot == true {
                self.root = try encode(path)
            } else {
                switch path.items[path.items.startIndex] {
                case .key: self.root = NSMutableDictionary()
                case .index: self.root = NSMutableArray()
                }
            }
        }
        var prevRoot: IValue?
        var currRoot = self.root!
        for pathIndex in path.items.indices {
            switch path.items[pathIndex] {
            case .key(let key):
                var mutable: NSMutableDictionary
                if let dict = currRoot as? NSMutableDictionary {
                    mutable = dict
                } else if let dict = currRoot as? NSDictionary {
                    mutable = NSMutableDictionary(dictionary: dict)
                    if let prevRoot = prevRoot {
                        switch path.items[pathIndex - 1] {
                        case .key(let key):
                            let prev = prevRoot as! NSMutableDictionary
                            prev.setValue(mutable, forKey: key)
                        case .index(let index):
                            let prev = prevRoot as! NSMutableArray
                            prev.insert(mutable, at: index)
                        }
                    }
                    currRoot = mutable
                } else {
                    throw Error.Coding.access(self.path.appending(path, to: pathIndex))
                }
                if pathIndex == path.items.endIndex - 1 {
                    let final = self.path.appending(path)
                    if let value = try encode(final) {
                        mutable[key] = value
                    } else {
                        mutable.removeObject(forKey: key)
                    }
                } else if let nextRoot = mutable[key] {
                    currRoot = nextRoot as! IValue
                } else {
                    switch path.items[pathIndex + 1] {
                    case .key:
                        let nextRoot = NSMutableDictionary()
                        mutable[key] = nextRoot
                        currRoot = nextRoot
                    case .index:
                        let nextRoot = NSMutableArray()
                        mutable[key] = nextRoot
                        currRoot = nextRoot
                    }
                }
            case .index(let index):
                var mutable: NSMutableArray
                if let dict = currRoot as? NSMutableArray {
                    mutable = dict
                } else if let arr = currRoot as? NSArray {
                    mutable = NSMutableArray(array: arr)
                    if let prevRoot = prevRoot {
                        switch path.items[pathIndex - 1] {
                        case .key(let key):
                            let prev = prevRoot as! NSMutableDictionary
                            prev.setValue(mutable, forKey: key)
                        case .index(let index):
                            let prev = prevRoot as! NSMutableArray
                            prev.insert(mutable, at: index)
                        }
                    }
                    currRoot = mutable
                } else {
                    throw Error.Coding.access(self.path.appending(path, to: pathIndex))
                }
                if pathIndex == path.items.endIndex - 1 {
                    let final = self.path.appending(path)
                    if let value = try encode(final) {
                        mutable.insert(value, at: index)
                    } else {
                        mutable.removeObject(at: index)
                    }
                } else if index < mutable.count {
                    currRoot = mutable[index] as! IValue
                } else {
                    switch path.items[pathIndex + 1] {
                    case .key:
                        let nextRoot = NSMutableDictionary()
                        mutable[index] = nextRoot
                        currRoot = nextRoot
                    case .index:
                        let nextRoot = NSMutableArray()
                        mutable[index] = nextRoot
                        currRoot = nextRoot
                    }
                }
            }
            prevRoot = currRoot
        }
    }
    
    @inlinable
    func set(
        value: IValue,
        path: Path
    ) throws {
        try self.set(
            path: path,
            encode: { _ in
                return value
            }
        )
    }
    
    @inlinable
    func remove(
        path: Path
    ) throws {
        try self.set(
            path: path,
            encode: { _ in
                return nil
            }
        )
    }
    
    func clean() {
        self.root = nil
    }
    
}

