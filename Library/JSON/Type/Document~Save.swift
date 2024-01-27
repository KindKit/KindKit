//
//  KindKit
//

import Foundation

public extension Document {

    func asData(
        options: JSONSerialization.WritingOptions = []
    ) throws(SaveError) -> Data {
        guard let root = self.root else {
            throw SaveError.empty
        }
        do {
            return try JSONSerialization.data(
                withJSONObject: root,
                options: options
            )
        } catch {
            throw SaveError.unknown
        }
    }

    func asString(
        encoding: String.Encoding = .utf8,
        options: JSONSerialization.WritingOptions = []
    ) throws(SaveError) -> String? {
        return String(
            data: try self.asData(options: options),
            encoding: encoding
        )
    }
    
}
