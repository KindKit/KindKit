//
//  KindKit
//

import Foundation

public extension Document {

    func asData(
        options: JSONSerialization.WritingOptions = []
    ) throws -> Data {
        guard let root = self.root else {
            throw Error.Save.empty
        }
        do {
            return try JSONSerialization.data(
                withJSONObject: root,
                options: options
            )
        } catch {
            throw Error.Save.unknown
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
