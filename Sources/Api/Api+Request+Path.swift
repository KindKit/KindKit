//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Path {
        
        case absolute(URL)
        case relative(String)
        
    }
    
}

public extension Api.Request.Path {
    
    func urlComponents(provider: IApiProvider) throws -> URLComponents {
        switch self {
        case .absolute(let url):
            guard let components = URLComponents(string: url.absoluteString) else {
                throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
            }
            return components
        case .relative(let path):
            guard var url = provider.url?.absoluteString else {
                throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
            }
            if url.hasSuffix("/") == true {
                if path.hasPrefix("/") == true {
                    url.append(contentsOf: path.dropFirst())
                } else {
                    url.append(contentsOf: path)
                }
            } else if path.hasPrefix("/") == true {
                url.append(contentsOf: path)
            } else {
                url.append(contentsOf: "/\(path)")
            }
            guard let components = URLComponents(string: url) else {
                throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
            }
            return components
        }
    }
    
}
