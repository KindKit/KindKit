//
//  KindKit
//

import Foundation
import KindJSON

public extension Request.Body {
    
    enum Data {
        
        case file(URL)
        case json(KindJSON.Document)
        case text(String, String.Encoding)
        case raw(Foundation.Data)
        
    }
    
}

public extension Request.Body.Data {
    
    static func json(_ block: (KindJSON.Document) throws -> Void) throws -> Request.Body.Data {
        do {
            return .json(try KindJSON.Document.build(block))
        } catch let error as KindJSON.Error.Coding {
            throw Error.Request.body(
                .json(.coding(error))
            )
        } catch {
            throw Error.Request.body(.unknown)
        }
    }
    
    static func text(_ string: String) -> Request.Body.Data {
        return .text(string, .utf8)
    }
    
}

public extension Request.Body.Data {
    
    @inlinable
    func build() throws -> (raw: Foundation.Data, mimetype: String) {
        switch self {
        case .file(let url):
            do {
                return (
                    raw: try Data(contentsOf: url),
                    mimetype: url.kk_mimeType
                )
            } catch let error as NSError {
                switch error.domain {
                case NSCocoaErrorDomain:
                    switch error.code {
                    case NSFileNoSuchFileError:
                        throw Error.Request.body(
                            .file(.notFound(url))
                        )
                    default:
                        throw Error.Request.body(
                            .file(.other(url))
                        )
                    }
                default:
                    throw Error.Request.body(.unknown)
                }
            }
        case .json(let json):
            do {
                return (
                    raw: try json.asData(),
                    mimetype: "application/json"
                )
            } catch let error as KindJSON.Error.Save {
                throw Error.Request.body(
                    .json(.save(error))
                )
            } catch {
                throw Error.Request.body(.unknown)
            }
        case .text(let string, let encoding):
            guard let data = string.data(using: encoding) else {
                throw Error.Request.body(
                    .text(.encoding(string, encoding))
                )
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

