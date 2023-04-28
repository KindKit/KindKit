//
//  KindKit
//

import Foundation

public extension Api.Error {
    
    enum Request : Swift.Error {
        
        case query(Api.Error.Request.Query)
        case body(Api.Error.Request.Body)
        case unhandle(Swift.Error)
        
    }
    
}

extension Api.Error.Request : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Api.Error.Request")
        switch self {
        case .query(let query):
            let indent = indent.next
            buff.append(header: indent, value: "Query")
            switch query {
            case .requireProviderUrl: buff.append(inter: indent, value: "RequireProviderUrl")
            case .decode(let components): buff.append(inter: indent, key: "Decode", value: components)
            case .encode(let components): buff.append(inter: indent, key: "Encode", value: components)
            }
        case .body(let body):
            buff.append(header: indent, value: "Body")
            switch body {
            case .unknown:
                let indent = indent.next
                buff.append(header: indent, value: "Body.File")
                    .append(inter: indent, value: "Unknown")
            case .file(let file):
                let indent = indent.next
                buff.append(header: indent, value: "Body.File")
                switch file {
                case .notFound(let url): buff.append(inter: indent, key: "NotFound", value: url)
                case .other(let url): buff.append(inter: indent, key: "Other", value: url)
                }
            case .form(let form):
                let indent = indent.next
                buff.append(header: indent, value: "Body.Form")
                switch form {
                case .key(let param):
                    buff.append(inter: indent, key: "Param", value: param)
                case .pair(let param, let value):
                    buff.append(inter: indent, key: "Param", value: param)
                    buff.append(inter: indent, key: "Value", value: value)
                }
            case .json(let json):
                let indent = indent.next
                switch json {
                case .coding(let error):
                    buff.append(header: indent, value: "Body.Json.Coding")
                    switch error {
                    case .access(let path): buff.append(inter: indent, key: "Access", value: path.string)
                    case .cast(let path): buff.append(inter: indent, key: "Cast", value: path.string)
                    }
                case .save(let error):
                    buff.append(header: indent, value: "Body.Json.Save")
                    switch error {
                    case .empty: buff.append(inter: indent, value: "Empty")
                    case .unknown: buff.append(inter: indent, value: "Unknown")
                    }
                }
            case .text(let text):
                let indent = indent.next
                buff.append(header: indent, value: "Body.Text")
                switch text {
                case .encoding(let string, let encoding):
                    buff.append(inter: indent, key: "String", value: string)
                    buff.append(inter: indent, key: "Encoding", value: encoding)
                }
            }
        case .unhandle(let error):
            buff.append(inter: indent, key: "Unhandle", value: error)
        }
    }
    
}
