//
//  KindKit
//

import Foundation

public extension Query {
    
    struct Transaction {
        
        let action: String
        
    }
    
}

extension Query.Transaction : IQuery {
    
    public var query: String {
        return "\(self.action) TRANSACTION"
    }
    
}

public extension Query.Transaction {
    
    static func begin(_ transaction: Transaction) -> Self {
        return .init(action: "BEGIN \(transaction.query)")
    }
    
    static func commit() -> Self {
        return .init(action: "COMMIT")
    }
    
    static func rollback() -> Self {
        return .init(action: "ROLLBACK")
    }
    
}

public extension Instance {
    
    func transaction(
        _ mode: Transaction = .deferred,
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

