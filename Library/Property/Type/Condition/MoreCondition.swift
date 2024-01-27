//
//  KindKit
//

import KindEvent

public final class MoreCondition< Left : Property, Right : Property > : OperatorCondition where Left.Value : Comparable, Left.Value == Right.Value {
    
    public typealias Left = Left
    public typealias Right = Right
    public typealias Value = Bool
    
    public let scope: Scope
    
    public var left: Left {
        willSet {
            self.left.onChanged(disconnect: self)
        }
        didSet {
            self.left.onChanged(target: self, regular: { $0.requestChange() })
            self.requestChange()
        }
    }
    
    public var right: Right {
        willSet {
            self.right.onChanged(disconnect: self)
        }
        didSet {
            self.right.onChanged(target: self, regular: { $0.requestChange() })
            self.requestChange()
        }
    }
    
    public private(set) var value: Value {
        set {
            if self.scope.isUpdateLocked {
                self._scopeValue = newValue
            } else {
                self._value = newValue
            }
        }
        get {
            return self._value
        }
    }
    
    public let onChanged = Signal< Void, Change< Value > >()
    
    private var _value: Value {
        didSet {
            guard self._value.isNotEqual(oldValue) else { return }
            self.onChanged.emit(.init(old: oldValue, new: self._value))
        }
    }
    private var _scopeValue: Value?
    
    public init(
        scope: Scope,
        left: Left,
        right: Right
    ) {
        self.scope = scope
        self.left = left
        self.right = right
        self._value = Self.get(left, right)
        
        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
        self.left.onChanged(target: self, regular: { $0.requestChange() })
        self.right.onChanged(target: self, regular: { $0.requestChange() })
    }
    
    deinit {
        self.right.onChanged(disconnect: self)
        self.left.onChanged(disconnect: self)
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
        guard self.scope.isUpdateLocked == false else { return }
        self.value = Self.get(self.left, self.right)
    }
    
}

fileprivate extension MoreCondition {
    
    @inline(__always)
    static func get(_ left: Left, _ right: Right) -> Value {
        return left.value > right.value
    }
    
    func _scopeCommit() {
        guard let scopeValue = self._scopeValue else { return }
        self._scopeValue = nil
        self._value = scopeValue
    }
    
}
