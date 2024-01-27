//
//  KindKit
//

public protocol Item : Equatable {
    
    func match(_ input: String, options: Options) -> Bool

}
