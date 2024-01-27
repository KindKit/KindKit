//
//  KindKit
//

import Foundation

public struct URLDecodeOptions : CodingOptions {
    
    public let require: URLComponentOptions
    public let base: URL?
    
    fileprivate init(
        require: URLComponentOptions,
        base: URL?
    ) {
        self.require = require
        self.base = base
    }
    
}

public extension URLDecodeOptions {
    
    static func require(_ require: URLComponentOptions) -> Self {
        return .init(require: require, base: nil)
    }
    
    static func base(_ base: URL) -> Self {
        return .init(require: [], base: base)
    }
    
    func require(_ require: URLComponentOptions) -> Self {
        return .init(require: require, base: self.base)
    }
    
    func base(_ base: URL) -> Self {
        return .init(require: self.require, base: base)
    }
    
}

extension URLDecodeOptions : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(require: [ .scheme, .host ], base: nil)
    }
    
}
