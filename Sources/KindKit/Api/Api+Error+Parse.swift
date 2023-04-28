//
//  KindKit
//

import Foundation

public extension Api.Error {
        
    struct Parse : Swift.Error, Equatable {
        
        public let statusCode: Int?
        public let response: Data?
        
        public init(
            statusCode: Int? = nil,
            response: Data? = nil
        ) {
            self.statusCode = statusCode
            self.response = response
        }
        
    }
    
}

extension Api.Error.Parse : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Api.Error.Parse")
        if let statusCode = self.statusCode {
            buff.append(inter: indent, key: "StatusCode", value: statusCode)
        }
        if let response = self.response {
            if response.isEmpty == false {
                if let json = try? JSONSerialization.jsonObject(with: response) {
                    if let root = json as? NSArray {
                        buff.append(
                            inter: indent,
                            key: "Response",
                            value: root
                        )
                    } else if let root = json as? NSDictionary {
                        buff.append(
                            inter: indent,
                            key: "Response",
                            value: root
                        )
                    }
                } else if let string = String(data: response, encoding: .utf8) {
                    buff.append(
                        inter: indent,
                        key: "Response",
                        value: string.kk_escape([ .tab, .return, .newline ])
                    )
                } else {
                    buff.append(
                        inter: indent,
                        key: "Response",
                        value: response
                    )
                }
            }
        }
    }
    
}
