//
//  KindKit
//

public protocol IFormatter {
    
    associatedtype InputType
    associatedtype OutputType

    func format(_ input: InputType) -> OutputType

}
