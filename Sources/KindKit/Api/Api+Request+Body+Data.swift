//
//  KindKit
//

import Foundation

public extension Api.Request.Body {
    
    enum Data {
        
        case file(URL)
        case json(Json)
        case text(String, String.Encoding)
        case raw(Foundation.Data)
        
    }
    
}

public extension Api.Request.Body.Data {
    
    static func json(_ block: (_ json: Json) throws -> Void) throws -> Api.Request.Body.Data {
        do {
            return .json(try Json.build(block))
        } catch let error as KindKit.Json.Error.Coding {
            throw Api.Error.Request.body(
                .json(.coding(error))
            )
        } catch {
            throw Api.Error.Request.body(.unknown)
        }
    }
    
    static func text(_ string: String) -> Api.Request.Body.Data {
        return .text(string, .utf8)
    }
    
}

public extension Api.Request.Body.Data {
    
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
                        throw Api.Error.Request.body(
                            .file(.notFound(url))
                        )
                    default:
                        throw Api.Error.Request.body(
                            .file(.other(url))
                        )
                    }
                default:
                    throw Api.Error.Request.body(.unknown)
                }
            }
        case .json(let json):
            do {
                return (
                    raw: try json.asData(),
                    mimetype: "application/json"
                )
            } catch let error as KindKit.Json.Error.Save {
                throw Api.Error.Request.body(
                    .json(.save(error))
                )
            } catch {
                throw Api.Error.Request.body(.unknown)
            }
        case .text(let string, let encoding):
            guard let data = string.data(using: encoding) else {
                throw Api.Error.Request.body(
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

