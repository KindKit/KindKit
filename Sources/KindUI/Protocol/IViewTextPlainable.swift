//
//  KindKit
//

import KindGraphics

public protocol IViewTextPlainable : IViewTextable {
    
    var text: String { set get }
    var textFont: Font { set get }
    var textColor: Color { set get }
    var alignment: Text.Alignment { set get }
    
}

public extension IViewTextPlainable where Self : IWidgetView, Body : IViewTextPlainable {
    
    @inlinable
    var text: String {
        set { self.body.text = newValue }
        get { self.body.text }
    }
    
    @inlinable
    var textFont: Font {
        set { self.body.textFont = newValue }
        get { self.body.textFont }
    }
    
    @inlinable
    var textColor: Color {
        set { self.body.textColor = newValue }
        get { self.body.textColor }
    }
    
    @inlinable
    var alignment: Text.Alignment {
        set { self.body.alignment = newValue }
        get { self.body.alignment }
    }
    
}

public extension IViewTextPlainable {
    
    @inlinable
    @discardableResult
    func text(_ value: String) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func text(_ value: () -> String) -> Self {
        return self.text(value())
    }

    @inlinable
    @discardableResult
    func text(_ value: (Self) -> String) -> Self {
        return self.text(value(self))
    }
    
    @inlinable
    @discardableResult
    func text< Localized : IEnumLocalized >(_ value: Localized) -> Self {
        return self.text(value.localized)
    }
    
    @inlinable
    @discardableResult
    func text< Localized : IEnumLocalized >(_ value: () -> Localized) -> Self {
        return self.text(value())
    }
    
    @inlinable
    @discardableResult
    func text< Localized : IEnumLocalized >(_ value: (Self) -> Localized) -> Self {
        return self.text(value(self))
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: () -> Font) -> Self {
        return self.textFont(value())
    }

    @inlinable
    @discardableResult
    func textFont(_ value: (Self) -> Font) -> Self {
        return self.textFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: () -> Color) -> Self {
        return self.textColor(value())
    }

    @inlinable
    @discardableResult
    func textColor(_ value: (Self) -> Color) -> Self {
        return self.textColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: Text.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> Text.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> Text.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
}
