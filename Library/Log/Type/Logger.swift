//
//  KindKit
//

import Foundation

final class Logger {
    
    var targets: [Target]
    
    init(
        _ targets: [Target]
    ) {
        self.targets = targets
    }
    
}

extension Logger : @unchecked Sendable {
}

extension Logger {
    
    static let `default` = Logger([
        DefaultTarget()
    ])
    
}

extension Logger {
    
    var files: [URL] {
        var files: [URL] = []
        for target in self.targets {
            files.append(contentsOf: target.files)
        }
        return files
    }
    
}

extension Logger {
    
    func register(target: Target) {
        guard self.targets.contains(where: {$0 === target }) == false else { return }
        self.targets.append(target)
    }
    
    func unregister(target: Target) {
        guard let index = self.targets.firstIndex(where: { $0 === target }) else { return }
        self.targets.remove(at: index)
    }
    
    func find< TargetType: Target >(_ type: TargetType.Type) -> TargetType? {
        for target in self.targets {
            guard let target = target as? TargetType else { continue }
            return target
        }
        return nil
    }
    
    func log(_ message: Message) {
        for target in self.targets {
            target.log(message: message)
        }
    }
    
}
