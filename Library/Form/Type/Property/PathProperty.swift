//
//  KindKit
//

import KindProperty
import KindEvent

public final class PathProperty : Property {
    
    public typealias Value = Path
    
    public var scope: Scope {
        return self._property.scope
    }
    
    public var value: Value {
        return self._property.value
    }
    
    public let id: Id
    
    public let parent: ParentFieldProperty
    
    public var onChanged: Signal< Void, Change< Value > > {
        return self._property.onChanged
    }
    
    private let _property: LazyProperty< Path >
    private let _propertyCallback: OptionalCallback< Path, Void >
    
    public init(
        scope: Scope,
        id: Id,
        parent: ParentFieldProperty
    ) {
        self.id = id
        self.parent = parent
        self._propertyCallback = .init(default: .init())
        self._property = .init(
            scope: scope,
            dependencies: [ self.parent ],
            callback: self._propertyCallback
        )
        
        self._setup()
    }
    
    public func requestChange() {
        self._property.requestChange()
    }
    
}

fileprivate extension PathProperty {
    
    func _setup() {
        self._propertyCallback.callback = RegularTargetCallback(
            capture: .weak(self, default: .init()),
            callback: { $0._compute() }
        )
    }
    
    func _compute() -> Path {
        var ids: [Id] = [ self.id ]
        var field = self.parent.value
        while field != nil {
            if let field = field {
                ids.append(field.id)
            }
            field = field?.parent
        }
        return .init(ids: ids.reversed())
    }
    
}
