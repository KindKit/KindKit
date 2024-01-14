//
//  KindKit
//

extension Signal.Slot {
    
    final class Sender< Sender : AnyObject > : Signal.Slot {
        
        weak var sender: Sender!
        let closure: (Sender, ArgumentType) -> ResultType
        
        init(
            _ source: ISignal,
            _ sender: Sender,
            _ closure: @escaping (Sender, ArgumentType) -> ResultType
        ) {
            self.sender = sender
            self.closure = closure
            super.init(source)
        }
        
        deinit {
            self.cancel()
        }
        
        override func contains(_ sender: AnyObject) -> Bool {
            return self.sender === sender
        }
        
        override func perform(_ argument: ArgumentType) throws -> ResultType {
            guard let sender = self.sender else { throw Signal.Slot.Error.notHaveSender }
            return self.closure(sender, argument)
        }
        
    }
    
}
