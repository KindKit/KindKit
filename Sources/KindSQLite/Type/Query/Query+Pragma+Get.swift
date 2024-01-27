//
//  KindKit
//

import KindString

public extension Query.Pragma {
    
    struct Get {
        
        let name: String
        
    }
    
}

extension Query.Pragma.Get : ISelectQuery {
    
    public var query: String {
        return .kk_build({
            LettersComponent("PRAGMA ")
            LettersComponent(self.name)
        })
    }
    
}

public extension Query.Pragma {
    
    static func userVersion() -> Get {
        return .init(name: "USER_VERSION")
    }
    
}

public extension Instance {
    
    func userVersion() throws -> Int {
        guard let userVersion = try self.run(query: Query.Pragma.userVersion(), decoder: Int.self) else {
            throw Error.decode
        }
        return userVersion
    }
    
    func userVersion< Enum : RawRepresentable >(_ type: Enum.Type) throws -> Enum where Enum.RawValue == Int {
        guard let value = Enum(rawValue: try self.userVersion()) else {
            throw Error.decode
        }
        return value
    }
    
    func userVersion< Enum : IEnumDecodable >(_ type: Enum.Type) throws -> Enum.RealValue where Enum.RawValue == Int {
        guard let value = Enum(rawValue: try self.userVersion()) else {
            throw Error.decode
        }
        return value.realValue
    }
    
}
