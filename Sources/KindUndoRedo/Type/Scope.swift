//
//  KindKit
//

final class Scope : IScope {
    
    var isValid: Bool {
        return self._states.isEmpty == false
    }
    private var _states: [IState]

    init() {
        self._states = []
    }
    
    func create(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingPermanentContext) -> Void) {
        let appended: Bool
        if let state = self._states.last {
            appended = state.create(command, object, closure)
        } else {
            appended = false
        }
        if appended == false {
            self._states.append(CreateState(command, object, closure))
        }
    }
    
    func update(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingTransformContext) -> Void) {
        let appended: Bool
        if let state = self._states.last {
            appended = state.update(command, object, closure)
        } else {
            appended = false
        }
        if appended == false {
            self._states.append(UpdateState(command, object, closure))
        }
    }
    
    func delete(_ command: String, _ object: String, _ closure: (_ context: inout IMutatingPermanentContext) -> Void) {
        let appended: Bool
        if let state = self._states.last {
            appended = state.delete(command, object, closure)
        } else {
            appended = false
        }
        if appended == false {
            self._states.append(DeleteState(command, object, closure))
        }
    }
    
    func undo(_ delegate: IDelegate) {
        for state in self._states.reversed() {
            state.undo(delegate)
        }
    }
    
    func redo(_ delegate: IDelegate) {
        for state in self._states {
            state.redo(delegate)
        }
    }
    
    func cleanup() {
        for state in self._states {
            state.cleanup()
        }
    }
    
}
