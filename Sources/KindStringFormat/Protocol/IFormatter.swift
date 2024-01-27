//
//  KindKit
//

public protocol IFormatter {
    
    associatedtype ArgumentType
    associatedtype ResultType

    func argument(_ argument: ArgumentType, specifier: Specifier) -> ResultType
    func placeholder(_ placeholder: String) -> ResultType
    func undefined() -> ResultType
    
}
