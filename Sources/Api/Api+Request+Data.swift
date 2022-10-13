//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Data {
        
        case file(URL)
        case json(Json)
        case raw(Foundation.Data)
        
    }
    
}

public extension Api.Request.Data {
    
    static func json(_ block: (_ json: Json) throws -> Void) rethrows -> Api.Request.Data {
        return .json(try Json().build(block))
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
        case .raw(let data):
            return (
                raw: data,
                mimetype: "application/octet-stream"
            )
        }
    }
    
}

