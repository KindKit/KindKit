//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Data {
        
        case file(URL)
        case json(Json)
        case text(String, String.Encoding)
        case raw(Foundation.Data)
        
    }
    
}

public extension Api.Request.Data {
    
    static func json(_ block: (_ json: Json) throws -> Void) rethrows -> Api.Request.Data {
        return .json(try Json().build(block))
    }
    
    static func text(_ string: String) -> Api.Request.Data {
        return .text(string, .utf8)
    }
    
}

public extension Api.Request.Data {
    
    func build() throws -> (raw: Foundation.Data, mimetype: String) {
        switch self {
        case .file(let url):
            return (
                raw: try Data(contentsOf: url),
                mimetype: url.kk_mimeType
            )
        case .json(let json):
            return (
                raw: try json.saveAsData(),
                mimetype: "application/json"
            )
        case .text(let string, let encoding):
            guard let data = string.data(using: encoding) else {
                throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
            }
            return (
                raw: data,
                mimetype: "text/plain"
            )
        case .raw(let data):
            return (
                raw: data,
                mimetype: "application/octet-stream"
            )
        }
    }
    
}

