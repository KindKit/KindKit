//
//  KindKit
//

import Foundation

public extension Request.Body {
    
    struct Multipart {

        public let name: Request.Value
        public let filename: Request.Value?
        public let mimetype: String?
        public let data: Request.Body.Data

        public init(
            name: Request.Value,
            filename: Request.Value? = nil,
            mimetype: String? = nil,
            data: Request.Body.Data
        ) {
            self.name = name
            self.filename = filename
            self.mimetype = mimetype
            self.data = data
        }

    }
    
}
