//
//  KindKit
//

import Foundation
import SQLite3

public final class Statement {
    
    let instance: OpaquePointer
    let columns: [String]
    
    init(_ instance: OpaquePointer, numberOfColumns: Count) {
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

extension Statement {
    
    var numberOfRows: Count {
        return Count(sqlite3_data_count(self.instance))
    }
    
}

extension Statement {
    
    func get(at index: Index) -> Value {
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
    
    func perform(_ connection: Connection) throws {
        while true {
            let code = sqlite3_step(self.instance)
            switch code {
            case SQLITE_DONE:
                return
            default:
                throw Error.internal(connection.error)
            }
        }
    }
    
    func perform< Element >(_ connection: Connection, _ decode: (Statement) throws -> Element) throws -> [Element] {
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
                throw Error.internal(connection.error)
            }
        }
    }
        
}

public extension Statement {
    
    func index<
        Column : ITableColumn
    >(
        column: Column
    ) throws -> Index {
        guard let index = self.columns.firstIndex(of: column.name) else {
            throw Error.columnNotFound(column.name)
        }
        return index
    }
    
}

public extension Statement {
    
    func keyPath<
        Column : ITableColumn
    >(
        column: Column
    ) throws -> KeyPath< Column > {
        return .init(try self.index(column: column))
    }
    
}

public extension Statement {
    
    func decode<
        Coder : IValueCoder
    >(
        _ decoder: Coder.Type,
        at index: Index
    ) throws -> Coder.SQLiteCoded {
        return try Coder.decode(self.get(at: index))
    }
    
    func decode<
        Alias : IValueAlias
    >(
        _ decoder: Alias.Type,
        at index: Index
    ) throws -> Alias.SQLiteValueCoder.SQLiteCoded {
        return try self.decode(Alias.SQLiteValueCoder, at: index)
    }
    
    func decode<
        KeyPath : IKeyPath
    >(
        _ keyPath: KeyPath
    ) throws -> KeyPath.SQLiteTableColumn.SQLiteValueCoder.SQLiteCoded {
        return try self.decode(KeyPath.SQLiteTableColumn.SQLiteValueCoder.self, at: keyPath.index)
    }
        
}
