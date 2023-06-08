//
//  KindKit
//

import Foundation

public extension Database.Query.Table {
    
    struct Insert {
        
        private let _table: Database.Table
        private let _columns: [String]
        private let _values: [String]
        
        init(
            table: Database.Table,
            columns: [String] = [],
            values: [String] = []
        ) {
            self._table = table
            self._columns = columns
            self._values = values
        }
        
    }
    
}

public extension Database.Query.Table.Insert {
    
    func set< Value : IDatabaseValue >(
        _ value: Value,
        `in` column: Database.Table.Column< Value >
    ) -> Self {
        var columns = self._columns
        var values = self._values
        if let index = columns.firstIndex(of: column.name) {
            values[index] = value.query
        } else {
            columns.append(column.name)
            values.append(value.query)
        }
        return .init(
            table: self._table,
            columns: columns,
            values: values
        )
    }
    
    func set< Encoder : IJsonModelEncoder >(
        _ encoder: Encoder.Type,
        model: Encoder.JsonModelEncoded,
        `in` column: Database.Table.Column< Json >
    ) -> Self {
        let json: Json
        do {
            json = try Json.build({
                try $0.encode(encoder, value: model)
            })
        } catch {
            json = Json(root: NSDictionary())
        }
        return self.set(json, in: column)
    }
    
    func set< Encoder : IJsonModelEncoder >(
        _ encoder: Encoder.Type,
        model: Encoder.JsonModelEncoded?,
        `in` column: Database.Table.Column< Json? >
    ) -> Self {
        guard let model = model else {
            return self.set(nil, in: column)
        }
        let json: Json
        do {
            json = try Json.build({
                try $0.encode(encoder, value: model)
            })
        } catch {
            json = Json(root: NSDictionary())
        }
        return self.set(json, in: column)
    }
    
}

extension Database.Query.Table.Insert : IDatabaseInsertQuery {
    
    public var query: String {
        let builder = StringBuilder("INSERT INTO ")
        builder.append(self._table.name)
        builder.append(" (")
        builder.append(self._columns, separator: ", ")
        builder.append(") VALUES (")
        builder.append(self._values, separator: ", ")
        builder.append(")")
        return builder.string
    }
    
}

public extension IDatabaseEntity {
    
    func insert() -> Database.Query.Table.Insert {
        return .init(table: table)
    }
    
}
