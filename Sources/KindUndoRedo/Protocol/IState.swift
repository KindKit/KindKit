//
//  KindKit
//

protocol IState {

    func create(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingPermanentContext) -> Void) -> Bool
    func update(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingTransformContext) -> Void) -> Bool
    func delete(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingPermanentContext) -> Void) -> Bool
    
    func undo(_ delegate: IDelegate)
    func redo(_ delegate: IDelegate)
    
    func cleanup()
    
}
