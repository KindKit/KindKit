//
//  KindKit
//

import Foundation

public extension Request {
    
    enum Path {
        
        case absolute(URL)
        case relative(String)
        
    }
    
}

extension Request.Path : Hashable {
}

extension Request.Path : Equatable {
}

extension Request.Path : Sendable {
}

public extension Request.Path {
    
    func urlComponents(
        provider: Provider
    ) throws -> URLComponents {
        switch self {
        case .absolute(let url):
            guard let components = URLComponents(string: url.absoluteString) else {
                throw RequestError.query(.decode(url.absoluteString))
            }
            return components
        case .relative(let path):
            guard var url = provider.url?.absoluteString else {
                throw RequestError.query(.requireProviderUrl)
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
                throw RequestError.query(.decode(url))
            }
            return components
        }
    }
    
}
