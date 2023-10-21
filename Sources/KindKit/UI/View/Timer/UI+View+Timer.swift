//
//  KindKit
//

import Foundation

extension UI.View {
    
    public final class Timer< 
        BodyType : IUIView,
        ApplierType : IApplier
    > : IUIWidgetView where
        ApplierType.InputType == UI.View.TimerSettings,
        ApplierType.TargetType == BodyType
    {
        
        public let body: BodyType
        public var settings: TimerSettings {
            didSet {
                self.applier.apply(self.settings, self.body)
            }
        }
        public var applier: ApplierType {
            didSet {
                self.applier.apply(self.settings, self.body)
            }
        }
        public let onFinish = Signal.Empty< Void >()
        
        private var _current: TimerSettings?
        private var _timer: KindKit.Timer.Every? {
            willSet { self._timer?.pause() }
            didSet { self._timer?.start() }
        }
        
        public init(
            settings: TimerSettings,
            applier: ApplierType,
            body: BodyType
        ) {
            self.settings = settings
            self.applier = applier
            self.body = body
        }
        
    }
    
}

public extension UI.View.Timer {
    
    @discardableResult
    func start() -> Self {
        self._current = self.settings
        self._timer = .init(interval: .timeInterval(self.settings.interval), iterations: self.settings.repeat)
            .onTriggered(self, { $0._onTimer($1) })
            .start()
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        self.applier.apply(self.settings, self.body)
        self._current = nil
        self._timer = nil
        return self
    }
    
}

private extension UI.View.Timer {
    
    func _onTimer(_ delta: TimeInterval) {
        guard let current = self._current else { return }
        let next = current.next(delta)
        self.applier.apply(next, self.body)
        self._current = next
        if next.isDone == true {
            self.onFinish.emit()
        }
    }
    
}

public extension UI.View.Timer {
    
    @inlinable
    @discardableResult
    func settings(_ value: UI.View.TimerSettings) -> Self {
        self.settings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func settings(_ value: () -> UI.View.TimerSettings) -> Self {
        return self.settings(value())
    }
    
    @inlinable
    @discardableResult
    func settings(_ value: (Self) -> UI.View.TimerSettings) -> Self {
        return self.settings(value(self))
    }
    
}

public extension UI.View.Timer {
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: (() -> Void)?) -> Self {
        self.onFinish.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((Self) -> Void)?) -> Self {
        self.onFinish.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onFinish.link(sender, closure)
        return self
    }
    
}

public extension UI.View.Timer where BodyType == UI.View.AttributedText {
    
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

public extension UI.View.Timer where BodyType == UI.View.Text {
    
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

extension UI.View.Timer : IUIViewReusable where BodyType : IUIViewReusable {
}

extension UI.View.Timer : IUIViewDynamicSizeable where BodyType : IUIViewDynamicSizeable {
}

extension UI.View.Timer : IUIViewStaticSizeable where BodyType : IUIViewStaticSizeable {
}

extension UI.View.Timer : IUIViewAnimatable where BodyType : IUIViewAnimatable {
}

extension UI.View.Timer : IUIViewStyleable where BodyType : IUIViewStyleable {
}

extension UI.View.Timer : IUIViewHighlightable where BodyType : IUIViewHighlightable {
}

extension UI.View.Timer : IUIViewSelectable where BodyType : IUIViewSelectable {
}

extension UI.View.Timer : IUIViewLockable where BodyType : IUIViewLockable {
}

extension UI.View.Timer : IUIViewPressable where BodyType : IUIViewPressable {
}

extension UI.View.Timer : IUIViewCornerRadiusable where BodyType : IUIViewCornerRadiusable {
}

extension UI.View.Timer : IUIViewColorable where BodyType : IUIViewColorable {
}

extension UI.View.Timer : IUIViewAlphable where BodyType : IUIViewAlphable {
}
