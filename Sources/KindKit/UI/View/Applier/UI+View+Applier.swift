//
//  KindKit
//

import Foundation

extension UI.View {
    
    public final class Applier<
        BodyType : IUIView,
        ApplierType : IApplier
    > : IUIWidgetView where
        ApplierType.TargetType == BodyType
    {
        
        public var content: ApplierType.InputType {
            didSet {
                self.applier.apply(self.content, self.body)
            }
        }
        public var applier: ApplierType {
            didSet {
                self.applier.apply(self.content, self.body)
            }
        }
        public let body: BodyType
        
        public init(
            content: ApplierType.InputType,
            applier: ApplierType,
            body: BodyType
        ) {
            self.content = content
            self.applier = applier
            self.body = body
            
            self.apply()
        }
        
    }
    
}

public extension UI.View.Applier {
    
    @inlinable
    func apply() {
        self.applier.apply(self.content, self.body)
    }
    
}

public extension UI.View.Applier where BodyType == UI.View.AttributedText {
    
    @inlinable
    var alignment: UI.Text.Alignment? {
        set { self.body.alignment = newValue }
        get { self.body.alignment }
    }
    
    @inlinable
    var lineBreak: UI.Text.LineBreak {
        set { self.body.lineBreak = newValue }
        get { self.body.lineBreak }
    }
    
    @inlinable
    var numberOfLines: UInt {
        set { self.body.numberOfLines = newValue }
        get { self.body.numberOfLines }
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment?) -> Self {
        self.body.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> UI.Text.Alignment?) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> UI.Text.Alignment?) -> Self {
        return self.alignment(value(self))
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: UI.Text.LineBreak) -> Self {
        self.body.lineBreak = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: () -> UI.Text.LineBreak) -> Self {
        return self.lineBreak(value())
    }

    @inlinable
    @discardableResult
    func lineBreak(_ value: (Self) -> UI.Text.LineBreak) -> Self {
        return self.lineBreak(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self {
        self.body.numberOfLines = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: () -> UInt) -> Self {
        return self.numberOfLines(value())
    }

    @inlinable
    @discardableResult
    func numberOfLines(_ value: (Self) -> UInt) -> Self {
        return self.numberOfLines(value(self))
    }
    
}

public extension UI.View.Applier where BodyType == UI.View.Text {
    
    @inlinable
    var textFont: UI.Font {
        set { self.body.textFont = newValue }
        get { self.body.textFont }
    }
    
    @inlinable
    var textColor: UI.Color {
        set { self.body.textColor = newValue }
        get { self.body.textColor }
    }
    
    @inlinable
    var alignment: UI.Text.Alignment {
        set { self.body.alignment = newValue }
        get { self.body.alignment }
    }
    
    @inlinable
    var lineBreak: UI.Text.LineBreak {
        set { self.body.lineBreak = newValue }
        get { self.body.lineBreak }
    }
    
    @inlinable
    var numberOfLines: UInt {
        set { self.body.numberOfLines = newValue }
        get { self.body.numberOfLines }
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: UI.Font) -> Self {
        self.body.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: () -> UI.Font) -> Self {
        return self.textFont(value())
    }

    @inlinable
    @discardableResult
    func textFont(_ value: (Self) -> UI.Font) -> Self {
        return self.textFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: UI.Color) -> Self {
        self.body.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: () -> UI.Color) -> Self {
        return self.textColor(value())
    }

    @inlinable
    @discardableResult
    func textColor(_ value: (Self) -> UI.Color) -> Self {
        return self.textColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment) -> Self {
        self.body.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> UI.Text.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> UI.Text.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: UI.Text.LineBreak) -> Self {
        self.body.lineBreak = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: () -> UI.Text.LineBreak) -> Self {
        return self.lineBreak(value())
    }

    @inlinable
    @discardableResult
    func lineBreak(_ value: (Self) -> UI.Text.LineBreak) -> Self {
        return self.lineBreak(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self {
        self.body.numberOfLines = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: () -> UInt) -> Self {
        return self.numberOfLines(value())
    }

    @inlinable
    @discardableResult
    func numberOfLines(_ value: (Self) -> UInt) -> Self {
        return self.numberOfLines(value(self))
    }
    
}

extension UI.View.Applier : IUIViewReusable where BodyType : IUIViewReusable {
}

extension UI.View.Applier : IUIViewDynamicSizeable where BodyType : IUIViewDynamicSizeable {
}

extension UI.View.Applier : IUIViewStaticSizeable where BodyType : IUIViewStaticSizeable {
}

extension UI.View.Applier : IUIViewEditable where BodyType : IUIViewEditable {
}

extension UI.View.Applier : IUIViewStyleable where BodyType : IUIViewStyleable {
}

extension UI.View.Applier : IUIViewHighlightable where BodyType : IUIViewHighlightable {
}

extension UI.View.Applier : IUIViewSelectable where BodyType : IUIViewSelectable {
}

extension UI.View.Applier : IUIViewLockable where BodyType : IUIViewLockable {
}

extension UI.View.Applier : IUIViewPressable where BodyType : IUIViewPressable {
}

extension UI.View.Applier : IUIViewAnimatable where BodyType : IUIViewAnimatable {
}

extension UI.View.Applier : IUIViewCornerRadiusable where BodyType : IUIViewCornerRadiusable {
}

extension UI.View.Applier : IUIViewColorable where BodyType : IUIViewColorable {
}

extension UI.View.Applier : IUIViewAlphable where BodyType : IUIViewAlphable {
}
