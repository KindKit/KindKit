//
//  KindKit
//

public final class Manager {
    
    public private(set) var modules: [IInstance]
    
    public init() {
        self.modules = []
    }
    
    public func register(module: IInstance) {
        guard self.modules.contains(where: { $0 === module }) else { return }
        self.modules.append(module)
    }
    
    public func unregister(module: IInstance) {
        guard let index = self.modules.firstIndex(where: { $0 === module }) else { return }
        self.modules.remove(at: index)
    }
    
}

public extension Manager {
    
    @inlinable
    var callToAction: ICallToAction? {
        for module in self.modules {
            if let callToAction = module.activeCallToAction {
                return callToAction
            }
        }
        return nil
    }
    
    @inlinable
    func showCallToActionIfNeeded() {
        self.callToAction?.show()
    }
    
}
