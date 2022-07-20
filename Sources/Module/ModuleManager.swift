//
//  KindKitModule
//

import Foundation

public final class ModuleManager : IModuleManager {
    
    public var modules: [IModule]
    
    public init() {
        self.modules = []
    }
    
    public func register(module: IModule) {
        guard self.modules.contains(where: { $0 === module }) else { return }
        self.modules.append(module)
    }
    
    public func unregister(module: IModule) {
        guard let index = self.modules.firstIndex(where: { $0 === module }) else { return }
        self.modules.remove(at: index)
    }
    
}
