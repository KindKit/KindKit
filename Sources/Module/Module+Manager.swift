//
//  KindKit
//

import Foundation

public extension Module {
    
    final class Manager : IModuleManager {
        
        public var modules: [IModuleInstance]
        
        public init() {
            self.modules = []
        }
        
        public func register(module: IModuleInstance) {
            guard self.modules.contains(where: { $0 === module }) else { return }
            self.modules.append(module)
        }
        
        public func unregister(module: IModuleInstance) {
            guard let index = self.modules.firstIndex(where: { $0 === module }) else { return }
            self.modules.remove(at: index)
        }
        
    }
    
}
