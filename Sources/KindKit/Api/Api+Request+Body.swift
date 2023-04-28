//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Body {
        
        case multipart(boundary: String, params: [Api.Request.Body.Multipart])
        case form([Api.Request.Parameter])
        case data(Api.Request.Body.Data)
        
    }
    
}

public extension Api.Request.Body {
    
    @inlinable
    static func multipart(_ params: [Api.Request.Body.Multipart]) -> Api.Request.Body {
        return .multipart(boundary: UUID().uuidString, params: params)
    }
    
}

public extension Api.Request.Body {
    
    func build() throws -> (data: Foundation.Data, headers: [Api.Request.Header]) {
        switch self {
        case .multipart(let boundary, let params):
            var data = Foundation.Data()
            for param in params {
                let paramData = try param.data.build()
                do {
                    guard let name = param.name.encoded else {
                        throw Api.Error.Request.body(
                            .form(
                                .key(param.name.string)
                            )
                        )
                    }
                    var headerString = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\""
                    if let filename = param.filename {
                        guard let filename = filename.encoded else {
                            throw Api.Error.Request.body(
                                .form(
                                    .pair(name, filename.string)
                                )
                            )
                        }
                        headerString += "; filename=\"\(filename)\"\r\n"
                    } else {
                        headerString += "\r\n"
                    }
                    if let mimetype = param.mimetype {
                        headerString += "Content-Type: \(mimetype)\r\n"
                    } else {
                        headerString += "Content-Type: \(paramData.mimetype)\r\n"
                    }
                    headerString += "\r\n"
                    guard let headerData = headerString.data(using: .ascii) else {
                        throw Api.Error.Request.body(.unknown)
                    }
                    data.append(headerData)
                }
                do {
                    data.append(paramData.raw)
                }
                do {
                    let footerString = "\r\n"
                    guard let footerData = footerString.data(using: .ascii) else {
                        throw Api.Error.Request.body(.unknown)
                    }
                    data.append(footerData)
                }
            }
            do {
                let footerString = "--\(boundary)--\r\n"
                if let footerData = footerString.data(using: .ascii) {
                    data.append(footerData)
                }
            }
            return (data: data, [
                .contentType("multipart/form-data; boundary=\(boundary)"),
                .contentLength(data.count)
            ])
        case .form(let params):
            var string = String()
            for param in params {
                guard let name = param.name.encoded else {
                    throw Api.Error.Request.body(
                        .form(
                            .key(param.name.string)
                        )
                    )
                }
                guard let value = param.value.encoded else {
                    throw Api.Error.Request.body(
                        .form(
                            .pair(name, param.value.string)
                        )
                    )
                }
                if string.count > 0 {
                    string.append("&\(name)=\(value)")
                } else {
                    string.append("\(name)=\(value)")
                }
            }
            guard let data = string.data(using: .ascii) else {
                throw Api.Error.Request.body(.unknown)
            }
            return (data: data, [
                .contentType("application/x-www-form-urlencoded"),
                .contentLength(data.count)
            ])
        case .data(let params):
            let build = try params.build()
            return (data: build.raw, [
                .contentType(build.mimetype),
                .contentLength(build.raw.count)
            ])
        }
    }
    
}
