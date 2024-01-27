//
//  KindKit
//

extension Signal.Slot {
    
    final class Target< TargetType : AnyObject > : Signal.Slot {
        
        weak var target: TargetType!
        let closure: (TargetType, ArgumentType) -> ResultType
        
        init(
            _ source: ISignal,
            _ target: TargetType,
            _ closure: @escaping (TargetType, ArgumentType) -> ResultType
        ) {
            self.target = target
            self.closure = closure
            super.init(source)
        }
        
        override func contains(_ target: AnyObject) -> Bool {
            return self.target === target
        }
        
        override func perform(_ argument: ArgumentType) throws -> ResultType {
            guard let target = self.target else { throw Signal.Slot.Error.notHaveTarget }
            return self.closure(target, argument)
        }
        
    }
    
}
