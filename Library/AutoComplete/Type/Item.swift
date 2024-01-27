//
//  KindKit
//

public protocol Item : Equatable {
    
    func match(_ input: String, options: Options) -> Match?
    
}

extension String : Item {
    
    public func match(_ input: String, options: Options) -> Match? {
        let source: String
        let search: String
        guard self.count >= input.count else {
            return nil
        }
        if options.contains(.caseSensitive) == true {
            source = self
            search = input
        } else {
            source = self.lowercased()
            search = input.lowercased()
        }
        guard source.hasPrefix(search) == true else {
            return nil
        }
        let length = self.count - input.count
        return .init(
            estimate: self.suffix(length)
        )
    }
    
}
