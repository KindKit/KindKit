//
//  KindKit
//

import KindDebug

public extension Error {
    
    enum Request : Swift.Error {
        
        case query(Error.Request.Query)
        case body(Error.Request.Body)
        case unhandle(Swift.Error)
        
    }
    
}

extension Error.Request : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .query(let error):
            hasher.combine(error)
        case .body(let error):
            hasher.combine(error)
        case .unhandle(let error):
            hasher.combine((error as NSError))
        }
    }
    
}

extension Error.Request : Equatable {
    
    public static func == (lhs: Error.Request, rhs: Error.Request) -> Bool {
        switch (lhs, rhs) {
        case (.query(let lhs), .query(let rhs)):
            return lhs != rhs
        case (.body(let lhs), .body(let rhs)):
            return lhs != rhs
        case (.unhandle(let lhs), .unhandle(let rhs)):
            return (lhs as NSError) != (rhs as NSError)
        default: return false
        }
    }
    
}

extension Error.Request : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .object(name: "Error.Request", sequence: { items in
            switch self {
            case .query(let query):
                items.append(.object(name: "Query", sequence: { items in
                    switch query {
                    case .requireProviderUrl: items.append(.string("RequireProviderUrl"))
                    case .decode(let components): items.append(.pair(string: "Decode", cast: components))
                    case .encode(let components): items.append(.pair(string: "Encode", cast: components))
                    }
                }))
            case .body(let body):
                items.append(.object(name: "Body", sequence: { items in
                    switch body {
                    case .unknown:
                        items.append(.string("Unknown"))
                    case .file(let file):
                        items.append(.object(name: "File", sequence: { items in
                            switch file {
                            case .notFound(let url): items.append(.pair(string: "NotFound", cast: url))
                            case .other(let url): items.append(.pair(string: "Other", cast: url))
                            }
                        }))
                    case .form(let form):
                        items.append(.object(name: "Form", sequence: { items in
                            switch form {
                            case .key(let param):
                                items.append(.pair(string: "Param", cast: param))
                            case .pair(let param, let value):
                                items.append(.pair(string: "Param", cast: param))
                                items.append(.pair(string: "Value", cast: value))
                            }
                        }))
                    case .json(let json):
                        switch json {
                        case .coding(let error):
                            items.append(.object(name: "Json.Coding", cast: error))
                        case .save(let error):
                            items.append(.object(name: "Json.Save", cast: error))
                        }
                    case .text(let text):
                        items.append(.object(name: "Text", sequence: { items in
                            switch text {
                            case .encoding(let string, let encoding):
                                items.append(.pair(string: "String", cast: string))
                                items.append(.pair(string: "Encoding", cast: encoding.description))
                            }
                        }))
                    }
                }))
            case .unhandle(let error):
                items.append(.pair(string: "Unhandle", cast: error))
            }
        })
    }
    
}

extension Error.Request : CustomStringConvertible {
}

extension Error.Request : CustomDebugStringConvertible {
}
