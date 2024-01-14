//
//  KindKit
//

protocol IScope {
    
    var isValid: Bool { get }
    
    func create(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingPermanentContext) -> Void)
    func update(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingTransformContext) -> Void)
    func delete(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingPermanentContext) -> Void)
    
    func undo(_ delegate: IDelegate)
    func redo(_ delegate: IDelegate)
    
    func cleanup()
    
}
