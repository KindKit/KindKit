//
//  KindKit
//

import KindProperty
import KindEvent
import KindMonadicMacro

@Monadic
public protocol Field : AnyObject {
    
    var id: Id { get }
    
    @MonadicField
    var form: Form? { set get }
    
    var formProperty: ParentFormProperty { get }
    
    @MonadicField
    var parent: (any Field)? { set get }
    
    var parentProperty: ParentFieldProperty { get }
    
    var pathProperty: PathProperty { get }
    
    @MonadicField
    var isHidden: Bool { set get }
    
    var hiddenProperty: ValueProperty< Bool > { get }
    
    @MonadicField
    var isLocked: Bool { set get }
    
    var lockedProperty: ValueProperty< Bool > { get }
    
    var focusFieldsProperty: AnyProperty< [any Field] > { get }
    
    @MonadicField
    var shouldFocus: Bool { set get }
    
    var shouldFocusProperty: ValueProperty< Bool > { get }
    
    @MonadicField
    var focus: Focus { set get }
    
    var focusProperty: ValueProperty< Focus > { get }
    
    var validProperty: AnyProperty< Bool > { get }
    
    var resultProperty: AnyProperty< (any Record)? > { get }
    
    func first(by id: Id) -> (any Field)?
    
}

public extension Field {
    
    @inlinable
    var root: (any Field)? {
        return self.form?.root
    }
    
    @inlinable
    var form: Form? {
        set { self.formProperty.value = newValue }
        get { self.formProperty.value }
    }
    
    @inlinable
    var parent: (any Field)? {
        set { self.parentProperty.value = newValue }
        get { self.parentProperty.value }
    }
    
    @inlinable
    var path: Path {
        return self.pathProperty.value
    }
    
    @inlinable
    var isHidden: Bool {
        set { self.hiddenProperty.value = newValue }
        get { self.hiddenProperty.value }
    }
    
    @inlinable
    var isLocked: Bool {
        set { self.lockedProperty.value = newValue }
        get { self.lockedProperty.value }
    }
    
    @inlinable
    var focusFields: [any Field] {
        return self.focusFieldsProperty.value
    }
    
    @inlinable
    var shouldFocus: Bool {
        set { self.shouldFocusProperty.value = newValue }
        get { self.shouldFocusProperty.value }
    }
    
    @inlinable
    var focus: Focus {
        set { self.focusProperty.value = newValue }
        get { self.focusProperty.value }
    }
    
    @inlinable
    var isValid: Bool {
        return self.validProperty.value
    }
    
    @inlinable
    var isNotValid: Bool {
        return !self.isValid
    }
    
    @inlinable
    var result: (any Record)? {
        return self.resultProperty.value
    }
    
}

public extension Field {
    
    @inlinable
    func first< As : Field >(by id: Id, as: As.Type) -> As? {
        guard let form = self.first(by: id) else { return nil }
        return form as? As
    }
    
    func first(by path: Path) -> (any Field)? {
        guard path.isNotEmpty else { return nil }
        var field: any Field = self
        for id in path.ids {
            guard let next = field.first(by: id) else {
                return nil
            }
            field = next
        }
        return field
    }
    
    @inlinable
    func first< As : Field >(by path: Path, as: As.Type) -> As? {
        guard let form = self.first(by: path) else { return nil }
        return form as? As
    }
    
}
