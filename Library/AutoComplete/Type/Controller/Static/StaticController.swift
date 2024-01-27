//
//  KindKit
//

public final class StaticController< Item : KindAutoComplete.Item > : Controller {
    
    public let items: [Item]
    public let options: Options
    
    public init(
        items: [Item],
        options: Options = .default
    ) {
        self.items = items
        self.options = options
    }
    
    public func begin() {
    }
    
    public func update(_ input: String) -> Match? {
        guard input.isEmpty == false else {
            return nil
        }
        for item in self.items {
            if let match = item.match(input, options: self.options) {
                return match
            }
        }
        return nil
    }
    
    public func end() {
    }
    
}
