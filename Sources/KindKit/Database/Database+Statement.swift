//
//  KindKit
//

import Foundation
import SQLite3

public extension Database {
    
    class Statement {
        
        let instance: OpaquePointer
        let columns: [String]
        
        init(_ instance: OpaquePointer, numberOfColumns: Database.Count) {
            self.instance = instance
            self.columns = (0..<numberOfColumns).map({
                if let name = sqlite3_column_name(instance, Int32($0)) {
                    if let string = String(utf8String: name) {
                        return string
                    }
                }
                return ""
            })
        }

        deinit {
            sqlite3_reset(self.instance)
            sqlite3_finalize(self.instance)
        }
        
    }
    
}

extension Database.Statement {
    
    var numberOfRows: Database.Count {
        return Database.Count(sqlite3_data_count(self.instance))
    }
    
}

extension Database.Statement {
    
    func get(at index: Database.Index) -> Database.Value {
        switch sqlite3_column_type(self.instance, Int32(index)) {
        case SQLITE_INTEGER:
            let value = sqlite3_column_int64(self.instance, Int32(index))
            return .integer(Int(value))
        case SQLITE_FLOAT:
            let value = sqlite3_column_double(self.instance, Int32(index))
            return .real(value)
        case SQLITE_TEXT, SQLITE3_TEXT:
            guard let cString = sqlite3_column_text(self.instance, Int32(index)) else {
                return .null
            }
            return .text(String(cString: cString))
        case SQLITE_BLOB:
            guard let bytes = sqlite3_column_blob(self.instance, Int32(index)) else {
                return .null
            }
            let count = sqlite3_column_bytes(self.instance, Int32(index))
            return .blob(Data(bytes: bytes, count: Int(count)))
        default:
            return .null
        }
    }
    
    func perform(_ connection: Database.Connection) throws {
        while true {
            let code = sqlite3_step(self.instance)
            switch code {
            case SQLITE_DONE:
                return
            default:
                throw Database.Error.internal(connection.error)
            }
        }
    }
    
    func perform< Element >(_ connection: Database.Connection, _ decode: (Database.Statement) throws -> Element) throws -> [Element] {
        var result: [Element] = []
        while true {
            let code = sqlite3_step(self.instance)
            switch code {
            case SQLITE_ROW:
                do {
                    result.append(try decode(self))
                } catch {
                    throw error
                }
            case SQLITE_DONE:
                return result
            default:
                throw Database.Error.internal(connection.error)
            }
        }
    }
        
}

public extension Database.Statement {
    
    func index<
        Column : IDatabaseTableColumn
    >(
        column: Column
    ) throws -> Database.Index {
        guard let index = self.columns.firstIndex(of: column.name) else {
            throw Database.Error.columnNotFound(column.name)
        }
        return index
    }
    
}

public extension Database.Statement {
    
    func keyPath<
        Column : IDatabaseTableColumn
    >(
        column: Column
    ) throws -> Database.KeyPath< Column > {
        return .init(try self.index(column: column))
    }
    
}

public extension Database.Statement {
    
    func decode<
        Coder : IDatabaseValueCoder
    >(
        _ decoder: Coder.Type,
        at index: Database.Index
    ) throws -> Coder.DatabaseCoded {
        return try Coder.decode(self.get(at: index))
    }
    
    func decode<
        Alias : IDatabaseValueAlias
    >(
        _ decoder: Alias.Type,
        at index: Database.Index
    ) throws -> Alias.DatabaseValueCoder.DatabaseCoded {
        return try self.decode(Alias.DatabaseValueCoder, at: index)
    }
    
    func decode<
        KeyPath : IDatabaseKeyPath
    >(
        _ keyPath: KeyPath
    ) throws -> KeyPath.DatabaseTableColumn.DatabaseValueCoder.DatabaseCoded {
        return try self.decode(KeyPath.DatabaseTableColumn.DatabaseValueCoder.self, at: keyPath.index)
    }
        
}
