//
//  KindKit
//

import Foundation

public extension Response {
    
    struct Meta {

        public let url: URL?
        public let mimeType: String?
        public let textEncoding: String?
        public let statusCode: Int?
        public let headers: [AnyHashable : Any]?
        
        public init() {
            self.url = nil
            self.mimeType = nil
            self.textEncoding = nil
            self.statusCode = nil
            self.headers = nil
        }

        public init(_ response: URLResponse) {
            self.url = response.url
            self.mimeType = response.mimeType
            self.textEncoding = response.textEncodingName
            if let httpResponse = response as? HTTPURLResponse {
                self.statusCode = httpResponse.statusCode
                self.headers = httpResponse.allHeaderFields
            } else {
                self.statusCode = nil
                self.headers = nil
            }
        }
        
    }
    
}
