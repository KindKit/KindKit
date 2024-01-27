//
//  KindKit
//

import Foundation

public extension Document {
    
    func set(root: Data) throws(AccessError) {
        guard let object = try? JSONSerialization.jsonObject(with: root, options: []) else {
            throw AccessError(in: self.path)
        }
        self.root = (object as! Field)
    }
    
    func set(query: SetQuery, in path: Path) throws(AccessError) {
        if self.root == nil {
            if path.isRoot == true {
                switch query {
                case .insert(let value):
                    self.root = value
                case .remove:
                    self.root = nil
                }
            } else {
                switch path.items[path.items.startIndex] {
                case .key: self.root = NSMutableDictionary()
                case .index: self.root = NSMutableArray()
                }
            }
        }
        var prevRoot: Field?
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
                    throw AccessError(
                        in: self.path.appending(path, to: pathIndex)
                    )
                }
                if pathIndex == path.items.endIndex - 1 {
                    switch query {
                    case .insert(let value):
                        mutable[key] = value
                    case .remove:
                        mutable.removeObject(forKey: key)
                    }
                } else if let nextRoot = mutable[key] {
                    currRoot = nextRoot as! Field
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
                    throw AccessError(
                        in: self.path.appending(path, to: pathIndex)
                    )
                }
                if pathIndex == path.items.endIndex - 1 {
                    switch query {
                    case .insert(let value):
                        mutable.insert(value, at: index)
                    case .remove:
                        mutable.removeObject(at: index)
                    }
                } else if index < mutable.count {
                    currRoot = mutable[index] as! Field
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
    
    func set(value: Field, in path: Path) throws(AccessError) {
        try self.set(query: .insert(value), in: path)
    }
    
    func remove(in path: Path) throws(AccessError) {
        try self.set(query: .remove, in: path)
    }
    
    func clean() {
        self.root = nil
    }
    
}

