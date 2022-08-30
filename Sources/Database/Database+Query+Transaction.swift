//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Query {
    
    struct Transaction {
        
        let action: String
        
    }
    
}

extension Database.Query.Transaction : IDatabaseQuery {
    
    public var query: String {
        return "\(self.action) TRANSACTION"
    }
    
}

public extension Database.Query.Transaction {
    
    static func begin(_ transaction: Database.Transaction) -> Self {
        return .init(action: "BEGIN \(transaction.query)")
    }
    
    static func commit() -> Self {
        return .init(action: "COMMIT")
    }
    
    static func rollback() -> Self {
        return .init(action: "ROLLBACK")
    }
    
}

public extension Database {
    
    func transaction(
        _ mode: Database.Transaction = .deferred,
        block: () throws -> Void
    ) throws {
        try self.run(query: Query.Transaction.begin(mode))
        do {
            try block()
            try self.run(query: Query.Transaction.commit())
        } catch {
            try self.run(query: Query.Transaction.rollback())
            throw error
        }
    }
    
}

