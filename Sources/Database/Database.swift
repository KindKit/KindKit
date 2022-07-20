//
//  KindKitDatabase
//

import Foundation
import KindKitCore
import SQLite3

public final class Database {
    
    public enum Error : Swift.Error {
        case userVersion
        case sqlite(code: Int, message: String?)
        case sqliteQuery(code: Int)
        case columnNotFound(name: String)
        case nullValueOf(column: String)
        case cast(column: String)
    }
    
    public enum Location {
        case inMemory
        case temporary
        case uri(_ path: String)
    }
    
    public enum DataType {
        case integer
        case double
        case string
        case dateTime
        case data
    }
    
    public struct OrderBy {
        
        public enum Mode {
            case asc
            case desc
        }
        
        public let columns: [Column]
        public let mode: Mode
        
        public init(columns: [Column], mode: Mode) {
            self.columns = columns
            self.mode = mode
        }
        
    }
    
    public struct Pagination {
        
        public let limit: Int
        public let offset: Int?
        
        public init(limit: Int, offset: Int? = nil) {
            self.limit = limit
            self.offset = offset
        }
        
    }
    
    public enum TransactionMode {
        case deferred
        case immediate
        case exclusive
    }
    
    open class Table {
        
        public internal(set) var name: String
        public internal(set) var columns: [Column]
        
        public init(
            name: String,
            columns: [Column]
        ) {
            self.name = name
            self.columns = columns
        }
        
    }
    
    open class Column {
        
        public internal(set) var name: String
        public internal(set) var dataType: DataType
        public internal(set) var isPrimaryKey: Bool
        public internal(set) var isAutoincrement: Bool
        public internal(set) var isNonNull: Bool
        public internal(set) var isUnique: Bool
        public internal(set) var defaultValue: IDatabaseDefaultValue?
        
        public init(
            name: String,
            dataType: DataType,
            isPrimaryKey: Bool = false,
            isAutoincrement: Bool = false,
            isNonNull: Bool = false,
            isUnique: Bool = false,
            defaultValue: IDatabaseDefaultValue? = nil
        ) {
            self.name = name
            self.dataType = dataType
            self.isPrimaryKey = isPrimaryKey
            self.isAutoincrement = isAutoincrement
            self.isNonNull = isNonNull
            self.isUnique = isUnique
            self.defaultValue = defaultValue
        }
        
    }
    
    public final class Statement {
        
        public enum Error : Swift.Error {
            case cast(index: Int)
        }
        
        private static let DefaultDestructor = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        private let _database: OpaquePointer
        private let _statement: OpaquePointer
        public private(set) lazy var numberOfParameters: Int = {
            return Int(sqlite3_bind_parameter_count(self._statement))
        }()
        public private(set) lazy var numberOfColumns: Int = {
            return Int(sqlite3_column_count(self._statement))
        }()
        public private(set) lazy var columnNames: [String] = {
            var result: [String] = []
            for index in 0 ..< self.numberOfColumns {
                if let name = sqlite3_column_name(self._statement, Int32(index)) {
                    if let nsString = NSString(utf8String: name) {
                        result.append(nsString as String)
                    } else {
                        result.append("")
                    }
                } else {
                    result.append("")
                }
            }
            return result
        }()
        public private(set) lazy var numberOfRows: Int = {
            return Int(sqlite3_data_count(self._statement))
        }()
        
        init(database: OpaquePointer, statement: OpaquePointer) {
            self._database = database
            self._statement = statement
        }
        
        deinit {
            do {
                try self.reset()
                try self.finalize()
            } catch let error {
                fatalError("Database: Error destruct statement: \(error)")
            }
        }
        
    }
    
    public private(set) var location: Location
    public private(set) var isReadonly: Bool
    public var deletingAfterClose: Bool
    public var lastInsertedRowId: Int64 {
        get { return sqlite3_last_insert_rowid(self._database) }
    }
    public var numberOfChangedRows: Int {
        get { return Int(sqlite3_changes(self._database)) }
    }
    public var isInTransaction: Bool {
        get { return sqlite3_get_autocommit(self._database) == 0 }
    }
    public var error: Error {
        get { return Database._error(database: self._database) }
    }
    
    private let _database: OpaquePointer
    
    public init(location: Location, readonly: Bool = false, deletingAfterClose: Bool = false) throws {
        self.location = location
        self.isReadonly = readonly
        self.deletingAfterClose = deletingAfterClose
        self._database = try Database._open(location, readonly)
    }
    
    public convenience init(filename: String, readonly: Bool = false, deletingAfterClose: Bool = false) throws {
        let path = try FileManager.default.documentDirectory() as String
        try self.init(location: .uri("\(path)/\(filename).sqlite"), readonly: readonly, deletingAfterClose: deletingAfterClose)
    }
    
    deinit {
        do {
            let result = sqlite3_close(self._database)
            if result != SQLITE_OK {
                throw Database._error(database: self._database)
            }
        } catch let error {
            fatalError("Database: Error closing database: \(error.localizedDescription)")
        }
        if self.deletingAfterClose == true {
            switch self.location {
            case .inMemory, .temporary: break
            case .uri(let path):
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch let error {
                    fatalError("Database: Error deleting database: \(error.localizedDescription)")
                }
            }
        }
    }
        
}

public extension Database {
    
    static func isExist(filename: String) throws -> Bool {
        let path = try FileManager.default.documentDirectory() as String
        return FileManager.default.fileExists(atPath: "\(path)/\(filename).sqlite")
    }
    
    static func drop(filename: String) throws {
        let path = try FileManager.default.documentDirectory() as String
        try FileManager.default.removeItem(atPath: path)
    }
    
    func set(userVersion: Int) throws {
        let query = "PRAGMA USER_VERSION = \(userVersion)"
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
    }
    
    func set< Encoder : IEnumEncodable >(_ encoder: Encoder.Type, userVersion: Encoder.RealValue) throws where Encoder.RawValue : BinaryInteger {
        try self.set(userVersion: Int(Encoder(realValue: userVersion).rawValue))
    }
    
    func userVersion() throws -> Int {
        let query = "PRAGMA USER_VERSION"
        let statement = try self.statement(query: query)
        try statement.executeUntilRow()
        return Int(statement.value(at: 0))
    }
    
    func userVersion< Decoder : IEnumDecodable >(_ decoder: Decoder.Type) throws -> Decoder.RealValue where Decoder.RawValue == Int {
        guard let decoded = Decoder(rawValue: Decoder.RawValue(try self.userVersion())) else {
            throw Error.userVersion
        }
        return decoded.realValue
    }
    
    func create(table: Table, ifNotExists: Bool = false) throws {
        let columnsDeclarations: [String] = table.columns.compactMap({ return $0.queryString() })
        var query = "CREATE TABLE "
        if ifNotExists == true {
            query += "IF NOT EXISTS "
        }
        query += table.name + " (" + columnsDeclarations.joined(separator: ", ") + ")"
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
    }
    
    func drop(table: Table, ifExists: Bool = false) throws {
        var query = "DROP TABLE "
        if ifExists == true {
            query += "IF EXISTS "
        }
        query += table.name
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
    }
    
    func rename(table: Table, to: String) throws {
        let query = "ALTER TABLE " + table.name + " RENAME TO " + to
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        table.name = to
    }
    
    func isExist(table: Table) throws -> Bool {
        return try self.isExist(table: table.name)
    }
    
    func isExist(table: String) throws -> Bool {
        let query = "SELECT tbl_name FROM sqlite_master WHERE tbl_name == \"\(table)\""
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        return statement.numberOfRows > 0
    }
    
    func transaction(mode: TransactionMode = .deferred, block: () throws -> Void) throws {
        let beginStatement = try self.statement(query: "BEGIN \(mode.queryString()) TRANSACTION")
        try beginStatement.executeUntilDone()
        do {
            try block()
            let commitStatement = try self.statement(query: "COMMIT TRANSACTION")
            try commitStatement.executeUntilDone()
        } catch let error {
            let commitStatement = try self.statement(query: "ROLLBACK TRANSACTION")
            try commitStatement.executeUntilDone()
            throw error
        }
    }
    
    func add(column: Column, in table: Table) throws {
        let query = "ALTER TABLE \(table.name) ADD COLUMN " + column.queryString()
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        table.add(column: column)
    }
    
    func remove(column: Column, in table: Table) throws {
        let columnsNames: [String] = table.columns.compactMap({
            guard $0 != column else { return nil }
            return $0.name
        })
        let columnsDeclarations: [String] = table.columns.compactMap({
            guard $0 != column else { return nil }
            return $0.queryString()
        })
        var query = "BEGIN TRANSACTION;\n"
        query += "CREATE TEMPORARY TABLE " + table.name + "_temp (" + columnsDeclarations.joined(separator: ", ") + ");\n"
        query += "INSERT INTO " + table.name + "_temp SELECT " + columnsNames.joined(separator: ", ") + " FROM " + table.name + ";\n"
        query += "DROP TABLE " + table.name + ";\n"
        query += "CREATE TABLE " + table.name + " (" + columnsDeclarations.joined(separator: ", ") + ");\n"
        query += "INSERT INTO " + table.name + " SELECT " + columnsNames.joined(separator: ", ") + " FROM " + table.name + "_temp;\n"
        query += "DROP TABLE " + table.name + "_temp;\n"
        query += "COMMIT;"
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        table.remove(column: column)
    }
    
    @discardableResult
    func insert(table: Table, data: [Column : IDatabaseInputValue]) throws -> Int64 {
        let columns: [String] = data.compactMap({ return $0.key.name })
        let values: [String] = data.compactMap({ _ in return "?" })
        let query = "INSERT INTO " + table.name + " (" + columns.joined(separator: ", ") + ") VALUES (" + values.joined(separator: ", ") + ")"
        let statement = try self.statement(query: query)
        try statement.bind(data.values)
        try statement.executeUntilDone()
        return self.lastInsertedRowId
    }
    
    @discardableResult
    func update(table: Table, data: [Column : IDatabaseInputValue], where: IDatabaseExpressable?, orderBy: OrderBy? = nil, pagination: Pagination? = nil) throws -> Int {
        let values: [String] = data.compactMap({ return $0.key.name + " = ?" })
        var bindables = data.values.compactMap({ return $0 })
        var query = "UPDATE " + table.name + " SET " + values.joined(separator: ", ")
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        try statement.executeUntilDone()
        return self.numberOfChangedRows
    }
    
    func updateOrInsert(table: Table, data: [Column : IDatabaseInputValue], where: IDatabaseExpressable) throws {
        let numberOfChanges = try self.update(table: table, data: data, where: `where`)
        if numberOfChanges == 0 {
            try self.insert(table: table, data: data)
        }
    }
    
    @discardableResult
    func delete(table: Table, where: IDatabaseExpressable? = nil, orderBy: OrderBy? = nil, pagination: Pagination? = nil) throws -> Int {
        var bindables: [IDatabaseInputValue] = []
        var query = "DELETE FROM " + table.name
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        try statement.executeUntilDone()
        return self.numberOfChangedRows
    }
    
    func select< Result >(table: Table, columns: [Column]? = nil, where: IDatabaseExpressable? = nil, orderBy: OrderBy? = nil, pagination: Pagination? = nil, map: (Database.Statement) throws -> Result) throws -> [Result] {
        var bindables: [IDatabaseInputValue] = []
        var query = "SELECT "
        if let columns = columns {
            query += columns.compactMap({ return $0.name }).joined(separator: ", ")
        } else {
            query += "*"
        }
        query += " FROM " + table.name
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        return try statement.executeRows(map)
    }
    
    func selectFirst< Result >(table: Table, columns: [Column]? = nil, where: IDatabaseExpressable? = nil, orderBy: OrderBy? = nil, pagination: Pagination? = nil, map: (Database.Statement) throws -> Result) throws -> Result? {
        var bindables: [IDatabaseInputValue] = []
        var query = "SELECT "
        if let columns = columns {
            query += columns.compactMap({ return $0.name }).joined(separator: ", ")
        } else {
            query += "*"
        }
        query += " FROM " + table.name
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        return try statement.executeFirstRow(map)
    }
    
}

extension Database.Column : Hashable {
    
    public var hashValue: Int {
        get { return self.name.hashValue }
    }
    
    public func hash(into hasher: inout Hasher) {
        self.name.hash(into: &hasher)
    }
    
    public static func == (lhs: Database.Column, rhs: Database.Column) -> Bool {
        return lhs.name == rhs.name
    }
    
}

public extension Database.Statement {
    
    func value< Output : IDatabaseOutputValue >(of column: Database.Column) throws -> Output {
        guard let index = self.columnIndex(of: column.name) else {
            throw Database.Error.columnNotFound(name: column.name)
        }
        if sqlite3_column_type(self._statement, Int32(index)) == SQLITE_NULL {
            throw Database.Error.nullValueOf(column: column.name)
        }
        var result: Output
        do {
            result = try Output.value(statement: self, at: index)
        } catch Error.cast(let index) {
            throw Database.Error.cast(column: self.columnName(at: index))
        } catch let error {
            throw error
        }
        return result
    }
    
    func value< Raw : RawRepresentable, Value : IDatabaseOutputValue >(of column: Database.Column) throws -> Raw where Raw.RawValue == Value {
        guard let index = self.columnIndex(of: column.name) else {
            throw Database.Error.columnNotFound(name: column.name)
        }
        if sqlite3_column_type(self._statement, Int32(index)) == SQLITE_NULL {
            throw Database.Error.nullValueOf(column: column.name)
        }
        var rawValue: Value
        do {
            rawValue = try Value.value(statement: self, at: index)
        } catch Error.cast(let index) {
            throw Database.Error.cast(column: self.columnName(at: index))
        } catch let error {
            throw error
        }
        guard let value = Raw(rawValue: rawValue) else {
            throw Database.Error.cast(column: column.name)
        }
        return value
    }
    
}

extension Database {
    
    func statement(query: String) throws -> Statement {
        return Statement(
            database: self._database,
            statement: try self._prepareStatement(query)
        )
    }
    
}

extension Database.Location {
    
    var sqlitePath: String {
        get {
            switch self {
            case .inMemory: return ":memory:"
            case .temporary: return ""
            case .uri(let path): return path
            }
        }
    }
    
}

extension Database.DataType {
    
    var type: Int32 {
        get {
            switch self {
            case .integer: return SQLITE_INTEGER
            case .double: return SQLITE_FLOAT
            case .string: return SQLITE_TEXT
            case .dateTime: return SQLITE_FLOAT
            case .data: return SQLITE_BLOB
            }
        }
    }
    
    func queryString() -> String {
        switch self {
        case .integer: return "INTEGER"
        case .double, .dateTime: return "REAL"
        case .string: return "TEXT"
        case .data: return "BLOB"
        }
    }
    
}

extension Database.OrderBy.Mode {
    
    func queryString() -> String {
        switch self {
        case .asc: return "ASC"
        case .desc: return "DESC"
        }
    }
    
}

extension Database.TransactionMode {
    
    func queryString() -> String {
        switch self {
        case .deferred: return "DEFERRED"
        case .immediate: return "IMMEDIATE"
        case .exclusive: return "EXCLUSIVE"
        }
    }
    
}

extension Database.Table {
    
    func add(column: Database.Column) {
        guard self.columns.contains(where: { return $0.name == column.name }) == false else { return }
        self.columns.append(column)
    }
    
    func remove(column: Database.Column) {
        guard let index = self.columns.firstIndex(where: { return $0.name == column.name }) else { return }
        self.columns.remove(at: index)
    }
    
}

extension Database.Column {
    
    func queryString() -> String {
        var string: String = "\(self.name) \(self.dataType.queryString())"
        if self.isPrimaryKey == true { string += " PRIMARY KEY" }
        if self.isAutoincrement == true { string += " AUTOINCREMENT" }
        if self.isNonNull == true { string += " NOT NULL" }
        if self.isUnique == true { string += " UNIUE" }
        if let defaultValue = self.defaultValue {
            string += " DEFAULT " + defaultValue.queryDefaultValue()
        }
        return string
        
    }
    
}

extension Database.Statement {
    
    func reset() throws {
        let result = sqlite3_reset(self._statement)
        if result != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func finalize() throws {
        let result = sqlite3_finalize(self._statement)
        if result != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func executeUntilDone() throws {
        let step = sqlite3_step(self._statement)
        switch step {
        case SQLITE_DONE: return
        default: throw Database._error(database: self._database)
        }
    }
    
    func executeUntilRow() throws {
        let step = sqlite3_step(self._statement)
        switch step {
        case SQLITE_ROW: return
        default: throw Database._error(database: self._database)
        }
    }
    
    func executeFirstRow< Result >(_ block: (Database.Statement) throws -> Result) throws -> Result? {
        while true {
            let step = sqlite3_step(self._statement)
            switch step {
            case SQLITE_ROW: return try block(self)
            case SQLITE_DONE: return nil
            default: throw Database._error(database: self._database)
            }
        }
    }
    
    func executeRows< Result >(_ block: (Database.Statement) throws -> Result) throws -> [Result] {
        var results: [Result] = []
        while true {
            let step = sqlite3_step(self._statement)
            switch step {
            case SQLITE_ROW: results.append(try block(self))
            case SQLITE_DONE: return results
            default: throw Database._error(database: self._database)
            }
        }
        return results
    }
        
    func bindIndex(of name: String) -> Int? {
        guard let name = name.cString(using: String.Encoding.utf8) else { return nil }
        let index = sqlite3_bind_parameter_index(self._statement, name)
        return (index > 0) ? Int(index) : nil
    }
    
    func bind(at index: Int, value: Bool) throws {
        if sqlite3_bind_int(self._statement, Int32(index), Int32(value ? 1 : 0)) != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: Bool) throws {
        guard let index = self.bindIndex(of: name) else {
            throw Database.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    func bind(at index: Int, value: Int64) throws {
        if sqlite3_bind_int64(self._statement, Int32(index), value) != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: Int64) throws {
        guard let index = self.bindIndex(of: name) else {
            throw Database.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    func bind(at index: Int, value: Double) throws {
        if sqlite3_bind_double(self._statement, Int32(index), value) != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: Double) throws {
        guard let index = self.bindIndex(of: name) else {
            throw Database.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    func bind(at index: Int, value: Decimal) throws {
        try self.bind(at: index, value: NSDecimalNumber(decimal: value).int64Value)
    }
    
    func bind(of name: String, value: Decimal) throws {
        try self.bind(of: name, value: NSDecimalNumber(decimal: value).int64Value)
    }
    
    func bind(at index:Int, value: String) throws {
        let cString = value.cString(using: String.Encoding.utf8)
        if sqlite3_bind_text(self._statement, Int32(index), cString!, -1, Database.Statement.DefaultDestructor) != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: String) throws {
        guard let index = self.bindIndex(of: name) else {
            throw Database.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    func bind(at index: Int, value: Data) throws {
        let nsData = value as NSData
        if nsData.length > 0 {
            if sqlite3_bind_blob(self._statement, Int32(index), nsData.bytes, Int32(nsData.length), Database.Statement.DefaultDestructor) != SQLITE_OK {
                throw Database._error(database: self._database)
            }
        } else {
            if sqlite3_bind_zeroblob(self._statement, Int32(index), 0) != SQLITE_OK {
                throw Database._error(database: self._database)
            }
        }
    }
    
    func bind(of name: String, value: Data) throws {
        guard let index = self.bindIndex(of: name) else {
            throw Database.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    func bindNull(at index: Int) throws {
        if sqlite3_bind_null(self._statement, Int32(index)) != SQLITE_OK {
            throw Database._error(database: self._database)
        }
    }
    
    func bindNull(of name: String) throws {
        guard let index = self.bindIndex(of: name) else {
            throw Database.Error.columnNotFound(name: name)
        }
        try self.bindNull(at: index)
    }
    
    func columnName(at index: Int) -> String {
        return self.columnNames[index]
    }
    
    func columnIndex(of name: String) -> Int? {
        return self.columnNames.firstIndex(of: name)
    }
    
    func value(at index: Int) -> Bool {
        return sqlite3_column_int64(self._statement, Int32(index)) != 0
    }
    
    func value(at index: Int) -> Int64 {
        return sqlite3_column_int64(self._statement, Int32(index))
    }
    
    func value(at index: Int) -> Double {
        return sqlite3_column_double(self._statement, Int32(index))
    }
    
    func value(at index: Int) -> Decimal {
        let int64: Int64 = self.value(at: index)
        return Decimal(int64)
    }
    
    func value(at index: Int) -> String {
        guard let text = sqlite3_column_text(self._statement, Int32(index)) else { return "" }
        let assumingText = UnsafeRawPointer(text).assumingMemoryBound(to: Int8.self)
        guard let string = NSString(utf8String: assumingText) else { return "" }
        return string as String
    }
    
    func value(at index: Int) -> Data {
        guard let bytes = sqlite3_column_blob(self._statement, Int32(index)) else { return Data() }
        let count = sqlite3_column_bytes(self._statement, Int32(index))
        return Data(bytes: bytes, count: Int(count))
    }
    
}

private extension Database {
    
    static func _open(_ location: Location, _ isReadonly: Bool) throws -> OpaquePointer {
        var database: OpaquePointer? = nil
        let flags = (isReadonly == true) ? SQLITE_OPEN_READONLY : (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        let result = sqlite3_open_v2(location.sqlitePath.cString(using: String.Encoding.utf8)!, &database, flags | SQLITE_OPEN_FULLMUTEX, nil)
        if result != SQLITE_OK {
            throw Database._error(database: database!)
        }
        return database!
    }
    
    static func _error(database: OpaquePointer) -> Database.Error {
        var message: String?
        if let errorMessage = sqlite3_errmsg(database) {
            if let nsString = NSString(utf8String: errorMessage) {
                message = nsString as String
            }
        }
        return Database.Error.sqlite(
            code: Int(sqlite3_errcode(database)),
            message: message
        )
    }
    
    func _prepareStatement(_ query: String) throws -> OpaquePointer {
        var statement: OpaquePointer? = nil
        let resultCode = sqlite3_prepare_v2(self._database, query.cString(using: String.Encoding.utf8)!, -1, &statement, nil)
        if resultCode != SQLITE_OK {
            throw Database._error(database: self._database)
        }
        return statement!
    }
    
}
