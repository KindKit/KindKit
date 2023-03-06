//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Body {
        
        case multipart(boundary: String, params: [Api.Request.Multipart])
        case form([Api.Request.Parameter])
        case data(Api.Request.Data)
        
    }
    
}

public extension Api.Request.Body {
    
    static func multipart(_ params: [Api.Request.Multipart]) -> Api.Request.Body {
        return .multipart(boundary: UUID().uuidString, params: params)
    }
    
}

public extension Api.Request.Body {
    
    func build() throws -> (data: Foundation.Data, headers: [Api.Request.Header]) {
        switch self {
        case .multipart(let boundary, let params):
            var data = Data()
            for param in params {
                let paramData = try param.data.build()
                do {
                    var headerString = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(try param.name.encoded)\""
                    if let filename = try param.filename?.encoded {
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
                    if let headerData = headerString.data(using: .ascii) {
                        data.append(headerData)
                    } else {
                        throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
                    }
                }
                do {
                    data.append(paramData.raw)
                }
                do {
                    let footerString = "\r\n"
                    if let footerData = footerString.data(using: .ascii) {
                        data.append(footerData)
                    } else {
                        throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
                    }
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
                let name = try param.name.encoded
                let value = try param.value.encoded
                if string.count > 0 {
                    string.append("&\(name)=\(value)")
                } else {
                    string.append("\(name)=\(value)")
                }
            }
            guard let data = string.data(using: .ascii) else {
                throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
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
