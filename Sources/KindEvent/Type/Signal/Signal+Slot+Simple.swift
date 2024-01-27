//
//  KindKit
//

extension Signal.Slot {
    
    final class Simple : Signal.Slot {
        
        let closure: (ArgumentType) -> ResultType
        
        init(
            _ source: ISignal,
            _ closure: @escaping (ArgumentType) -> ResultType
        ) {
            self.closure = closure
            super.init(source)
        }
        
        override func perform(_ argument: ArgumentType) throws -> ResultType {
            return self.closure(argument)
        }
        
    }
    
}
