//
//  KindKit
//

import Foundation

public extension Api.Request.Body {
    
    struct Multipart {

        public let name: Api.Request.Value
        public let filename: Api.Request.Value?
        public let mimetype: String?
        public let data: Api.Request.Body.Data

        public init(
            name: Api.Request.Value,
            filename: Api.Request.Value? = nil,
            mimetype: String? = nil,
            data: Api.Request.Body.Data
        ) {
            self.name = name
            self.filename = filename
            self.mimetype = mimetype
            self.data = data
        }

    }
    
}
