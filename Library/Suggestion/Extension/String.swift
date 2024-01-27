//
//  KindKit
//

extension String : Item {
    
    public func match(_ input: String, options: Options) -> Bool {
        let source: String
        let search: String
        guard self.count >= input.count else {
            return false
        }
        if options.contains(.caseSensitive) == true {
            source = self
            search = input
        } else {
            source = self.lowercased()
            search = input.lowercased()
        }
        return source.contains(search)
    }
    
}
