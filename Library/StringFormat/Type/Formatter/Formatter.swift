//
//  KindKit
//

public protocol Formatter {
    
    associatedtype Argument
    associatedtype Result

    func argument(_ argument: Argument, specifier: Specifier) -> Result
    func placeholder(_ placeholder: String) -> Result
    func undefined() -> Result
    
}
