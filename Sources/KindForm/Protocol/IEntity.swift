//
//  KindKit
//

import KindCondition
import KindEvent

public protocol IEntity : AnyObject {
    
    var id: Id { get }
    var parent: IEntity? { set get }
    var hidden: KindCondition.IEntity { set get }
    var locked: KindCondition.IEntity { set get }
    var valid: KindCondition.IEntity { get }
    var focusable: [IEntity] { get }
    var result: [IResult] { get }
    var onShouldFocus: Signal< Bool?, Void > { get }
    var onFocus: Signal< Void, Void > { get }
    var onChanged: Signal< Void, Void > { get }
    
    func find(by id: Id) -> IEntity?
    
}

public extension IEntity {
    
    @inlinable
    var root: IEntity {
        guard let parent = self.parent else { return self }
        return parent.root
    }
    
    @inlinable
    var shouldFocus: Bool {
        return self.onShouldFocus.emit(default: false)
    }
    
}

public extension IEntity {
    
    @inlinable
    func recursiveEmitOnChange() {
        var form: IEntity = self
        while true {
            form.onChanged.emit()
            if let parent = form.parent {
                form = parent
            } else {
                break
            }
        }
    }
    
    @inlinable
    func find< As : IEntity >(by id: Id, as: As.Type) -> As? {
        guard let form = self.find(by: id) else { return nil }
        return form as? As
    }
    
    func find(by ids: [Id]) -> IEntity? {
        guard let id = ids.first else { return nil }
        guard self.id == id else { return nil }
        var form: IEntity = self
        for id in ids.kk_removingFirst() {
            guard let next = form.find(by: id) else {
                return nil
            }
            form = next
        }
        return form
    }
    
    @inlinable
    func find< As : IEntity >(by ids: [Id], as: As.Type) -> As? {
        guard let form = self.find(by: ids) else { return nil }
        return form as? As
    }
    
    @inlinable
    func next(focus: IEntity? = nil) -> IEntity? {
        let list = self.focusable
        if let focus = focus {
            return list.kk_next(where: { $0 === focus })
        }
        if let index = list.firstIndex(where: { $0 === self }) {
            return list.kk_next(at: index)
        }
        return list.first
    }
    
    @inlinable
    func focus() {
        self.onFocus.emit()
    }
    
}

public extension IEntity {
    
    @inlinable
    @discardableResult
    func hidden(_ value: KindCondition.IEntity) -> Self {
        self.hidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func locked(_ value: KindCondition.IEntity) -> Self {
        self.locked = value
        return self
    }
    
}

public extension IEntity {
    
    @inlinable
    @discardableResult
    func onShouldFocus(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldFocus.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldFocus(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldFocus.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldFocus< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Bool?) -> Self {
        self.onShouldFocus.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldFocus(remove target: AnyObject) -> Self {
        self.onShouldFocus.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping () -> Void) -> Self {
        self.onFocus.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping (Self) -> Void) -> Self {
        self.onFocus.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onFocus.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(remove target: AnyObject) -> Self {
        self.onFocus.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged(_ closure: @escaping () -> Void) -> Self {
        self.onChanged.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged(_ closure: @escaping (Self) -> Void) -> Self {
        self.onChanged.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onChanged.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged(remove target: AnyObject) -> Self {
        self.onChanged.remove(target)
        return self
    }
    
}
