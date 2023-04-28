//
//  KindKit
//

import Foundation

public extension Json {

    func asData(
        options: JSONSerialization.WritingOptions = []
    ) throws -> Data {
        guard let root = self.root else {
            throw Json.Error.Save.empty
        }
        do {
            return try JSONSerialization.data(
                withJSONObject: root,
                options: options
            )
        } catch {
            throw Json.Error.Save.unknown
        }
    }

    func asString(
        encoding: String.Encoding = .utf8,
        options: JSONSerialization.WritingOptions = []
    ) throws -> String? {
        return String(
            data: try self.asData(options: options),
            encoding: encoding
        )
    }
    
}
