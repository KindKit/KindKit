//
//  KindKit
//

import Foundation

public protocol IForm : AnyObject {
    
    var id: Form.Id { get }
    var parent: IForm? { set get }
    var hidden: ICondition { set get }
    var locked: ICondition { set get }
    var valid: ICondition { get }
    var focusable: [IForm] { get }
    var result: [IFormResult] { get }
    var onShouldFocus: Signal.Empty< Bool? > { get }
    var onFocus: Signal.Empty< Void > { get }
    var onChanged: Signal.Empty< Void > { get }
    
    func find(by id: Form.Id) -> IForm?
    
}

public extension IForm {
    
    @inlinable
    var root: IForm {
        guard let parent = self.parent else { return self }
        return parent.root
    }
    
    @inlinable
    var shouldFocus: Bool {
        return self.onShouldFocus.emit(default: false)
    }
    
}

public extension IForm {
    
    @inlinable
    func recursiveEmitOnChange() {
        var form: IForm = self
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
    func find< As : IForm >(by id: Form.Id, as: As.Type) -> As? {
        guard let form = self.find(by: id) else { return nil }
        return form as? As
    }
    
    func find(by ids: [Form.Id]) -> IForm? {
        guard let id = ids.first else { return nil }
        guard self.id == id else { return nil }
        var form: IForm = self
        for id in ids.kk_removingFirst() {
            guard let next = form.find(by: id) else {
                return nil
            }
            form = next
        }
        return form
    }
    
    @inlinable
    func find< As : IForm >(by ids: [Form.Id], as: As.Type) -> As? {
        guard let form = self.find(by: ids) else { return nil }
        return form as? As
    }
    
    @inlinable
    func next(focus: IForm? = nil) -> IForm? {
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

public extension IForm {
    
    @inlinable
    @discardableResult
    func hidden(_ value: ICondition) -> Self {
        self.hidden = value
        return self
    }
    
    @inlinable
    @discardableResult
    func locked(_ value: ICondition) -> Self {
        self.locked = value
        return self
    }
    
}

public extension IForm {
    
    @inlinable
    @discardableResult
    func onShouldFocus(_ closure: (() -> Bool?)?) -> Self {
        self.onShouldFocus.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldFocus(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldFocus.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldFocus< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool?) -> Self {
        self.onShouldFocus.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: (() -> Void)?) -> Self {
        self.onFocus.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping (Self) -> Void) -> Self {
        self.onFocus.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onFocus.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged(_ closure: (() -> Void)?) -> Self {
        self.onChanged.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged(_ closure: @escaping (Self) -> Void) -> Self {
        self.onChanged.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChanged< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onChanged.link(sender, closure)
        return self
    }
    
}
