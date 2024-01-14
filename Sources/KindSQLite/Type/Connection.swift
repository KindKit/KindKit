//
//  KindKit
//

import Foundation
import SQLite3

final class Connection {
    
    let instance: OpaquePointer
    
    init(_ instance: OpaquePointer) {
        self.instance = instance
    }
    
}

extension Connection {
    
    @inlinable
    static func open(location: String, isReadonly: Bool) -> Connection? {
        var instance: OpaquePointer? = nil
        let flags = (isReadonly == true) ? SQLITE_OPEN_READONLY : (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        let code = sqlite3_open_v2(location.cString(using: .utf8)!, &instance, flags | SQLITE_OPEN_FULLMUTEX, nil)
        if code != SQLITE_OK {
            return nil
        }
        return .init(instance!)
    }
    
}

extension Connection {
    
    @inlinable
    var lastInsertedRowId: RowId {
        return RowId(sqlite3_last_insert_rowid(self.instance))
    }
    
    @inlinable
    var numberOfChangedRows: Count {
        return Count(sqlite3_changes(self.instance))
    }
    
    @inlinable
    var isInTransaction: Bool {
        return sqlite3_get_autocommit(self.instance) == 0
    }
    
    @inlinable
    var error: Error.Internal {
        let code = sqlite3_errcode(self.instance)
        let message: String?
        if let utf8 = sqlite3_errmsg(self.instance) {
            message = String(utf8String: utf8)
        } else {
            message = nil
        }
        return .init(
            code: Int(code),
            message: message
        )
    }
    
}

extension Connection {
    
    @inlinable
    func statement(query: String) throws -> Statement {
        guard let query = query.cString(using: .utf8) else {
            throw Error.failQuery(query)
        }
        var instance: OpaquePointer? = nil
        let code = sqlite3_prepare_v2(self.instance, query, -1, &instance, nil)
        if code != SQLITE_OK {
            throw Error.internal(self.error)
        }
        return .init(instance!, numberOfColumns: Int(sqlite3_column_count(instance!)))
    }
    
    @inlinable
    func close() {
        sqlite3_close(self.instance)
    }
        
}
