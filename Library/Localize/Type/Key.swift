//
//  KindKit
//

import Foundation

public struct Key {
    
    public let name: String
    
    public let finder: any Finder
    
    public init(_ name: String, in finder: any Finder) {
        self.name = name
        self.finder = finder
    }
    
}

public extension Key {
    
    @inlinable
    var find: String? {
        return self.finder(key: self.name)
    }
    
    @inlinable
    var contains: Bool {
        return self.find != nil
    }
    
    @inlinable
    var string: String {
        return self.find ?? ""
    }
    
    @inlinable
    func string(format arguments: CVarArg...) -> String {
        guard let string = self.find else { return "" }
        return String(format: string, arguments: arguments)
    }
    
    @inlinable
    func string(format arguments: [CVarArg]) -> String {
        guard let string = self.find else { return "" }
        return String(format: string, arguments: arguments)
    }
    
}
