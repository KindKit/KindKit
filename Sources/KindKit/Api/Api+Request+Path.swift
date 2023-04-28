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
    
    func urlComponents(
        provider: Api.Provider
    ) throws -> URLComponents {
        switch self {
        case .absolute(let url):
            guard let components = URLComponents(string: url.absoluteString) else {
                throw Api.Error.Request.query(.decode(url.absoluteString))
            }
            return components
        case .relative(let path):
            guard var url = provider.url?.absoluteString else {
                throw Api.Error.Request.query(.requireProviderUrl)
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
                throw Api.Error.Request.query(.decode(url))
            }
            return components
        }
    }
    
}
