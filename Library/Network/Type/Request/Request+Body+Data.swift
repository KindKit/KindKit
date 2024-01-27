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

extension Request.Body.Data : Hashable {
}

extension Request.Body.Data : Equatable {
}

extension Request.Body.Data : Sendable {
}

public extension Request.Body.Data {
    
    static func json(_ block: (KindJSON.Document) throws -> Void) throws -> Request.Body.Data {
        do {
            return .json(try KindJSON.Document.build(document: block))
        } catch let error as KindJSON.AccessError {
            throw RequestError.body(
                .json(.access(error))
            )
        } catch let error as KindJSON.CodingError {
            throw RequestError.body(
                .json(.coding(error))
            )
        } catch {
            throw RequestError.body(.unknown)
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
                        throw RequestError.body(
                            .file(.notFound(url))
                        )
                    default:
                        throw RequestError.body(
                            .file(.other(url))
                        )
                    }
                default:
                    throw RequestError.body(.unknown)
                }
            }
        case .json(let json):
            do {
                return (
                    raw: try json.asData(),
                    mimetype: "application/json"
                )
            } catch let error {
                throw RequestError.body(
                    .json(.save(error))
                )
            }
        case .text(let string, let encoding):
            guard let data = string.data(using: encoding) else {
                throw RequestError.body(
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

