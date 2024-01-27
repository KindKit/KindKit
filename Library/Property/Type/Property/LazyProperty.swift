//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public final class LazyProperty< Value > : Property {
    
    public typealias Value = Value
    public typealias Dependency = any Property
    
    public let scope: Scope
    
    public private(set) var value: Value {
        set {
            if self.scope.isUpdateLocked {
                self._scopeValue = newValue
            } else {
                self._value = newValue
            }
        }
        get {
            if let value = self._value {
                return value
            }
            let value = self.callback.perform()
            self._value = value
            return value
        }
    }
    
    @MonadicField
    public var dependencies: [Dependency] {
        set {
            if self.scope.isUpdateLocked {
                self._scopeDependencies = newValue
            } else {
                self._dependencies = newValue
            }
        }
        get {
            return self._dependencies
        }
    }
    
    public let callback: Callback< Value, Void >
    
    public let onChanged = Signal< Void, Change< Value > >()
    
    private var _value: Value? {
        didSet {
            self.onChanged.emit(.init(old: oldValue ?? self.value, new: self.value))
        }
    }
    private var _scopeValue: Value?
    private var _dependencies: [Dependency] = [] {
        didSet {
            for dependency in oldValue {
                dependency.onChanged(disconnect: self)
            }
            for dependency in self._dependencies {
                dependency.onChanged(target: self, regular: { $0.requestChange() })
            }
            self.requestChange()
        }
    }
    private var _scopeDependencies: [Dependency]?
    private var _skipRequestChange: Bool = false
    
    public init(
        scope: Scope,
        dependencies: [Dependency] = [],
        callback: Callback< Value, Void >
    ) {
        self.scope = scope
        self._dependencies = dependencies.kk_uniqued(where: { $0 === $1 })
        self.callback = callback
        
        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
        for dependency in self._dependencies {
            dependency.onChanged(target: self, regular: { $0.requestChange() })
        }
    }
    
    deinit {
        for dependency in self._dependencies {
            dependency.onChanged(disconnect: self)
        }
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
        guard self._skipRequestChange == false && self.scope.isUpdateLocked == false else { return }
        self.value = self.callback.perform()
    }
    
}

public extension LazyProperty {
    
    @discardableResult
    func insert(dependency: Dependency, at index: Int) -> Self {
        if self._dependencies.contains(where: { $0 === dependency }) == false {
            self._dependencies.insert(dependency, at: index)
        }
        return self
    }
    
    @discardableResult
    func prepend(dependency: Dependency) -> Self {
        return self.insert(dependency: dependency, at: self._dependencies.startIndex)
    }
    
    @discardableResult
    func append(dependency: Dependency) -> Self {
        return self.insert(dependency: dependency, at: self._dependencies.endIndex)
    }
    
    @discardableResult
    func remove(dependency: Dependency) -> Self {
        if let index = self._dependencies.firstIndex(where: { $0 === dependency }) {
            self._dependencies.remove(at: index)
        }
        return self
    }
    
}

fileprivate extension LazyProperty {
    
    func _scopeCommit() {
        if let dependecies = self._scopeDependencies {
            self._skipRequestChange = true
            self._scopeDependencies = nil
            self._dependencies = dependecies
            self._skipRequestChange = false
        }
        if let scopeValue = self._scopeValue {
            self._scopeValue = nil
            self._value = scopeValue
        }
    }
    
}
