//
//  KindKit
//

import Foundation

public extension Query.Pragma {
    
    struct Set {
        
        let name: String
        let value: String
        
    }
    
}

extension Query.Pragma.Set : IQuery {
    
    public var query: String {
        let builder = StringBuilder("PRAGMA ")
        builder.append(self.name)
        builder.append(" = ")
        builder.append(self.value)
        return builder.string
    }
    
}

public extension Query.Pragma {
    
    static func set(userVersion: Int) -> Set {
        return .init(name: "USER_VERSION", value: "\(userVersion)")
    }
    
}

public extension Instance {
    
    func set(userVersion: Int) throws {
        try self.run(query: Query.Pragma.set(userVersion: userVersion))
    }
    
    func set< Enum : RawRepresentable >(userVersion: Enum) throws where Enum.RawValue == Int {
        try self.set(userVersion: userVersion.rawValue)
    }
    
    func set< Enum : IEnumEncodable >(userVersion: Enum.RealValue, _ type: Enum.Type) throws where Enum.RawValue == Int {
        try self.set(userVersion: Enum(realValue: userVersion))
    }
    
}
