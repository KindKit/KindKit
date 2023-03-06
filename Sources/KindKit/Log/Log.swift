//
//  KindKit
//

import Foundation

public final class Log {
    
    private var _targets: [ILogTarget]
    
    public init(
        targets: [ILogTarget]
    ) {
        self._targets = targets
    }
    
}

public extension Log {
    
    static let shared = Log(
        targets: [
            Target.Default()
        ]
    )
    
    var files: [URL] {
        var files: [URL] = []
        for target in self._targets {
            files.append(contentsOf: target.files)
        }
        return files
    }
    
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
    
    func find< TargetType: ILogTarget >(_ type: TargetType.Type) -> TargetType? {
        for target in self._targets {
            guard let target = target as? TargetType else { continue }
            return target
        }
        return nil
    }
    
}

public extension Log {
    
    func log(level: Log.Level, category: String, message: String) {
        for target in self._targets {
            target.log(level: level, category: category, message: message)
        }
    }
    
    @inlinable
    func log< Sender : AnyObject >(level: Log.Level, object: Sender.Type, message: String) {
        self.log(level: level, category: String(describing: object), message: message)
    }
    
    @inlinable
    func log< Sender : AnyObject >(level: Log.Level, object: Sender, message: String) {
        self.log(level: level, category: String(describing: type(of: object)), message: message)
    }
    
}
