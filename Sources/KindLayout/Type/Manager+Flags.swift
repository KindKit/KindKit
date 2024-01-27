//
//  KindKit
//

extension Manager {
    
    struct Flags : OptionSet {
        
        var rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

extension Manager.Flags {
    
    static var arrange: Self { .init(rawValue: 1 << 0) }
    static var collect: Self { .init(rawValue: 1 << 1) }
    
}
