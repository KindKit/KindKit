//
//  KindKit
//

extension String : IEntity {
    
    public func debugInfo() -> Info {
        return .string("\"\(self.kk_escape([ .tab, .newline, .return, .doubleQuote ]))\"")
    }

}
