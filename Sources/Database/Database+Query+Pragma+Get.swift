//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query.Pragma {
    
    struct Get {
        
        let name: String
        
    }
    
}

extension Database.Query.Pragma.Get : IDatabaseSelectQuery {
    
    public var query: String {
        let builder = StringBuilder("PRAGMA ")
        builder.append(self.name)
        return builder.string
    }
    
}

public extension Database.Query.Pragma {
    
    static func userVersion() -> Get {
        return .init(name: "USER_VERSION")
    }
    
}

public extension Database {
    
    func userVersion() throws -> Int {
        guard let userVersion = try self.run(query: Database.Query.Pragma.userVersion(), decoder: Int.self) else {
            throw Database.Error.decode
        }
        return userVersion
    }
    
    func userVersion< Enum : RawRepresentable >(_ type: Enum.Type) throws -> Enum where Enum.RawValue == Int {
        guard let value = Enum(rawValue: try self.userVersion()) else {
            throw Database.Error.decode
        }
        return value
    }
    
    func userVersion< Enum : IEnumDecodable >(_ type: Enum.Type) throws -> Enum.RealValue where Enum.RawValue == Int {
        guard let value = Enum(rawValue: try self.userVersion()) else {
            throw Database.Error.decode
        }
        return value.realValue
    }
    
}
