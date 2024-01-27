//
//  KindKit
//

import Foundation

public final class Manager {
    
    private var _targets: [ITarget]
    
    public init(
        targets: [ITarget]
    ) {
        self._targets = targets
    }
    
}

public extension Manager {
    
    var files: [URL] {
        var files: [URL] = []
        for target in self._targets {
            files.append(contentsOf: target.files)
        }
        return files
    }
    
}

public extension Manager {
    
    func append(target: ITarget) {
        guard self._targets.contains(where: {$0 === target }) == false else { return }
        self._targets.append(target)
    }
    
    func remove(target: ITarget) {
        guard let index = self._targets.firstIndex(where: { $0 === target }) else { return }
        self._targets.remove(at: index)
    }
    
}

public extension Manager {
    
    func find< TargetType: ITarget >(_ type: TargetType.Type) -> TargetType? {
        for target in self._targets {
            guard let target = target as? TargetType else { continue }
            return target
        }
        return nil
    }
    
}

public extension Manager {
    
    func log(message: IMessage) {
        for target in self._targets {
            target.log(message: message)
        }
    }
    
}
