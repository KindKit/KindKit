//
//  KindKit
//

import KindCore

extension Signal {
    
    class Slot : ICancellable {
        
        weak var source: ISignal?
        
        init(_ source: ISignal) {
            self.source = source
        }
        
        deinit {
            self.cancel()
        }
        
        func perform(_ argument: ArgumentType) throws -> ResultType {
            fatalError()
        }
        
        func contains(_ sender: AnyObject) -> Bool {
            return false
        }
        
        func cancel() {
            self.source?.remove(self)
            self.reset()
        }
        
        func reset() {
            self.source = nil
        }
        
    }
    
}
