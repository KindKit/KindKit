//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseInputValue {
    
    func bindTo(statement: Database.Statement, at index: Int) throws
    
}

extension Database.Statement {
    
    func bind< BindSequence : Sequence >(_ bindables: BindSequence) throws where BindSequence.Iterator.Element == IDatabaseInputValue {
        var index = 1
        for bindable in bindables {
            try bindable.bindTo(statement: self, at: index)
            index += 1
        }
    }
    
}

extension Bool : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

extension Int8 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension UInt8 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension Int16 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension UInt16 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension Int32 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension UInt32 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension Int64 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

extension UInt64 : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension Int : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension UInt : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

extension Float : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Double(self))
    }
    
}

extension Double : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

extension Decimal : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

extension String : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

extension URL : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try self.absoluteString.bindTo(statement: statement, at: index)
    }
    
}

extension Date : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Double(self.timeIntervalSince1970))
    }
    
}

extension Data : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

extension Optional : IDatabaseInputValue where Wrapped : IDatabaseInputValue {
    
    public func bindTo(statement: Database.Statement, at index: Int) throws {
        switch self {
        case .none: try statement.bindNull(at: index)
        case .some(let wrapped): try wrapped.bindTo(statement: statement, at: index)
        }
    }
    
}
