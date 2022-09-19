//
//  KindKit
//

import Foundation

extension Json {
    
    func _set(value: IJsonValue?, path: String?) throws {
        if let path = path {
            try self._set(value: value, subpaths: self._subpaths(path))
        } else {
            self.root = value
        }
    }
    
    func _get(path: String?) throws -> IJsonValue {
        guard var root = self.root else {
            throw Json.Error.notJson
        }
        guard let path = path else { return root }
        var subpathIndex: Int = 0
        let subpaths = self._subpaths(path)
        while subpaths.endIndex != subpathIndex {
            let subpath = subpaths[subpathIndex]
            if let dictionary = root as? NSDictionary {
                guard let key = subpath.jsonPathKey else {
                    throw Json.Error.access
                }
                guard let temp = dictionary.object(forKey: key) else {
                    throw Json.Error.access
                }
                root = temp as! IJsonValue
            } else if let array = root as? NSArray {
                guard let index = subpath.jsonPathIndex, index < array.count else {
                    throw Json.Error.access
                }
                root = array.object(at: index) as! IJsonValue
            } else {
                throw Json.Error.access
            }
            subpathIndex += 1
        }
        return root
    }
    
}

private extension Json {

    func _set(value: IJsonValue?, subpaths: [IJsonPath]) throws {
        if self.root == nil {
            if let subpath = subpaths.first {
                if subpath.jsonPathKey != nil {
                    self.root = NSMutableDictionary()
                } else if subpath.jsonPathIndex != nil {
                    self.root = NSMutableArray()
                } else {
                    throw Json.Error.access
                }
            } else {
                throw Json.Error.access
            }
        }
        var root: IJsonValue = self.root!
        var prevRoot: IJsonValue?
        var subpathIndex: Int = 0
        while subpaths.endIndex != subpathIndex {
            let subpath = subpaths[subpathIndex]
            if let key = subpath.jsonPathKey {
                var mutable: NSMutableDictionary
                if root is NSMutableDictionary {
                    mutable = root as! NSMutableDictionary
                } else if root is NSDictionary {
                    mutable = NSMutableDictionary(dictionary: root as! NSDictionary)
                    if let prevRoot = prevRoot {
                        let prevSubpath = subpaths[subpathIndex - 1]
                        if let prevDictionary = prevRoot as? NSMutableDictionary {
                            prevDictionary.setValue(mutable, forKey: prevSubpath.jsonPathKey!)
                        } else if let prevArray = prevRoot as? NSMutableArray {
                            prevArray.insert(mutable, at: prevSubpath.jsonPathIndex!)
                        }
                    }
                    root = mutable
                } else {
                    throw Json.Error.access
                }
                if subpathIndex == subpaths.endIndex - 1 {
                    if let value = value {
                        mutable[key] = value
                    } else {
                        mutable.removeObject(forKey: key)
                    }
                } else if let nextRoot = mutable[key] {
                    root = nextRoot as! IJsonValue
                } else {
                    let nextSubpath = subpaths[subpathIndex + 1]
                    if nextSubpath.jsonPathKey != nil {
                        let nextRoot = NSMutableDictionary()
                        mutable[key] = nextRoot
                        root = nextRoot
                    } else if nextSubpath.jsonPathIndex != nil {
                        let nextRoot = NSMutableArray()
                        mutable[key] = nextRoot
                        root = nextRoot
                    } else {
                        throw Json.Error.access
                    }
                }
            } else if let index = subpath.jsonPathIndex {
                var mutable: NSMutableArray
                if root is NSMutableArray {
                    mutable = root as! NSMutableArray
                } else if root is NSArray {
                    mutable = NSMutableArray(array: root as! NSArray)
                    if let prevRoot = prevRoot {
                        let prevSubpath = subpaths[subpathIndex - 1]
                        if let prevDictionary = prevRoot as? NSMutableDictionary {
                            prevDictionary.setValue(mutable, forKey: prevSubpath.jsonPathKey!)
                        } else if let prevArray = prevRoot as? NSMutableArray {
                            prevArray.insert(mutable, at: prevSubpath.jsonPathIndex!)
                        }
                    }
                    root = mutable
                } else {
                    throw Json.Error.access
                }
                if subpathIndex == subpaths.endIndex - 1 {
                    if let value = value {
                        mutable.insert(value, at: index)
                    } else {
                        mutable.removeObject(at: index)
                    }
                } else if index < mutable.count {
                    root = mutable[index] as! IJsonValue
                } else {
                    let nextSubpath = subpaths[subpathIndex + 1]
                    if nextSubpath.jsonPathKey != nil {
                        let nextRoot = NSMutableDictionary()
                        mutable[index] = nextRoot
                        root = nextRoot
                    } else if nextSubpath.jsonPathIndex != nil {
                        let nextRoot = NSMutableArray()
                        mutable[index] = nextRoot
                        root = nextRoot
                    } else {
                        throw Json.Error.access
                    }
                }
            } else {
                throw Json.Error.access
            }
            subpathIndex += 1
            prevRoot = root
        }
    }
    
    func _subpaths(_ path: String) -> [IJsonPath] {
        guard path.contains(Const.pathSeparator) == true else { return [ path ] }
        let components = path.components(separatedBy: Const.pathSeparator)
        return components.compactMap({ (subpath: String) -> IJsonPath? in
            guard let match = Const.pathIndexPattern.firstMatch(in: subpath, options: [], range: NSRange(location: 0, length: subpath.count)) else { return subpath }
            if((match.range.location != NSNotFound) && (match.range.length > 0)) {
                let startIndex = subpath.index(subpath.startIndex, offsetBy: 1)
                let endIndex = subpath.index(subpath.endIndex, offsetBy: -1)
                let indexString = String(subpath[startIndex ..< endIndex])
                return NSNumber.number(from: indexString)
            }
            return subpath
        })
    }

    struct Const {
        public static var pathSeparator = "."
        public static var pathIndexPattern = try! NSRegularExpression(pattern: "^\\[\\d+\\]$", options: [ .anchorsMatchLines ])
    }

}
