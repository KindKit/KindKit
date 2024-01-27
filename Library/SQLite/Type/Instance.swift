//
//  KindKit
//

import Foundation

public final class Instance {
    
    public private(set) var location: Location
    public private(set) var isReadonly: Bool
    public var deletingAfterClose: Bool
    public var isInTransaction: Bool {
        return self._connection.isInTransaction
    }
    
    private let _connection: Connection
    
    public init(
        location: Location,
        readonly: Bool = false,
        deletingAfterClose: Bool = false
    ) throws {
        guard let connection = Connection.open(location: location.query, isReadonly: readonly) else {
            throw Error.unableLocation(location)
        }
        self.location = location
        self.isReadonly = readonly
        self.deletingAfterClose = deletingAfterClose
        self._connection = connection
    }
    
    @inlinable
    public convenience init(
        filename: String,
        readonly: Bool = false,
        deletingAfterClose: Bool = false
    ) throws {
        try self.init(
            location: .uri(filename: filename),
            readonly: readonly,
            deletingAfterClose: deletingAfterClose
        )
    }
    
    deinit {
        self._connection.close()
        if self.deletingAfterClose == true {
            switch self.location {
            case .inMemory, .temporary: break
            case .uri(let path):
                try? FileManager.default.removeItem(atPath: path)
            }
        }
    }
        
}

public extension Instance {
    
    static func isExist(filename: String) throws -> Bool {
        let path = Location.path(filename: filename)
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func drop(filename: String) throws {
        let path = Location.path(filename: filename)
        try FileManager.default.removeItem(atPath: path)
    }

}

public extension Instance {
    
    func run<
        Query : IQuery
    >(
        query: Query
    ) throws {
        let statement = try self._connection.statement(query: query.query)
        try statement.perform(self._connection)
    }
    
    @discardableResult
    func run<
        Query : IInsertQuery
    >(
        query: Query
    ) throws -> Result.Insert {
        let statement = try self._connection.statement(query: query.query)
        try statement.perform(self._connection)
        return .init(
            lastRowId: self._connection.lastInsertedRowId,
            numberOfInserted: self._connection.numberOfChangedRows
        )
    }
    
    @discardableResult
    func run<
        Query : IUpdateQuery
    >(
        query: Query
    ) throws -> Result.Update {
        let statement = try self._connection.statement(query: query.query)
        try statement.perform(self._connection)
        return .init(
            numberOfUpdated: self._connection.numberOfChangedRows
        )
    }

    func run<
        Query : ISelectQuery,
        Decoder: IDecoder
    >(
        query: Query,
        decode: (Statement) throws -> Decoder
    ) throws -> [Decoder.SQLiteDecoded] {
        let statement = try self._connection.statement(query: query.query)
        let decoder = try decode(statement)
        return try statement.perform(self._connection, {
            try decoder.decode($0)
        })
    }
    
    func run<
        Query : ISelectQuery,
        Decoder: IValueCoder
    >(
        query: Query,
        decoder: Decoder.Type
    ) throws -> Decoder.SQLiteCoded? {
        let statement = try self._connection.statement(query: query.query)
        let result = try statement.perform(self._connection, {
            try decoder.decode($0.get(at: 0))
        })
        return result.first
    }
    
    func run<
        Query : ISelectQuery,
        Alias: IValueAlias
    >(
        query: Query,
        decoder: Alias.Type
    ) throws -> Alias.SQLiteValueCoder.SQLiteCoded? {
        return try self.run(query: query, decoder: Alias.SQLiteValueCoder.self)
    }

}
