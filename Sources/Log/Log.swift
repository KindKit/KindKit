//
//  KindKitLog
//

import Foundation

public class Log {
    
    private var _targets: [ILogTarget]
    
    public init(
        targets: [ILogTarget]
    ) {
        self._targets = targets
    }
    
}

public extension Log {
    
    static var shared = Log(
        targets: [
            Target.Default()
        ]
    )
    
}

public extension Log {
    
    func append(target: ILogTarget) {
        guard self._targets.contains(where: {$0 === target }) == false else { return }
        self._targets.append(target)
    }
    
    func remove(target: ILogTarget) {
        guard let index = self._targets.firstIndex(where: { $0 === target }) else { return }
        self._targets.remove(at: index)
    }
    
}

public extension Log {
    
    func log(level: Log.Level, category: String, message: String) {
        for target in self._targets {
            target.log(level: level, category: category, message: message)
        }
    }
    
    @inlinable
    func log< Sender : AnyObject >(level: Log.Level, module object: Sender, message: String) {
        self.log(level: level, category: String(describing: object), message: message)
    }
    
    @inlinable
    func log< Sender : AnyObject >(level: Log.Level, class object: Sender, message: String) {
        self.log(level: level, category: String(describing: type(of: object)), message: message)
    }
    
}
