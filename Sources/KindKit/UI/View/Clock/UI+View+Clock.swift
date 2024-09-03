//
//  KindKit
//

import Foundation

extension UI.View {
    
    public final class Clock<
        BodyType : IUIView,
        ApplierType : IApplier
    > : IUIWidgetView where
        ApplierType.InputType == ClockTick,
        ApplierType.TargetType == BodyType
    {
        
        public var settings: ClockSettings {
            didSet {
                let isStarted = self._timer != nil
                self.stop()
                self.body.content = .init(
                    duration: self.settings.duration,
                    elapsed: 0
                )
                if isStarted == true {
                    self.start()
                }
            }
        }
        public var applier: ApplierType {
            set { self.body.applier = newValue }
            get { self.body.applier }
        }
        public let body: UI.View.Applier< BodyType, ApplierType >
        public let onFinish = Signal.Empty< Void >()
        
        private var _startedTime: DispatchTime?
        private var _timer: Timer.Every? {
            didSet {
                if let timer = self._timer {
                    self._startedTime = .now()
                    timer.onTriggered(self, { $0.onTriggeredTimer() })
                    timer.onFinished(self, { $0.onFinishedTimer() })
                    timer.start()
                } else if let timer = oldValue {
                    timer.pause()
                    self._startedTime = nil
                } else {
                    self._startedTime = nil
                }
                self.body.content = .init(
                    duration: self.body.content.duration,
                    elapsed: 0
                )
            }
        }
        
        public init(
            settings: ClockSettings,
            applier: ApplierType,
            body: BodyType
        ) {
            self.settings = settings
            self.body = .init(
                content: .init(
                    duration: settings.duration,
                    elapsed: 0
                ),
                applier: applier,
                body: body
            )
        }
        
    }
    
}

public extension UI.View.Clock {
    
    var interval: Timer.Interval {
        set {
            self.settings = .init(
                interval: newValue,
                iterations: self.settings.iterations,
                tolerance: self.settings.tolerance
            )
        }
        get { self.settings.interval }
    }
    
    var iterations: Int {
        set {
            self.settings = .init(
                interval: self.settings.interval,
                iterations: newValue,
                tolerance: self.settings.tolerance
            )
        }
        get { self.settings.iterations }
    }
    
    @discardableResult
    func start() -> Self {
        self._timer = Timer.Every(
            interval: self.settings.interval,
            iterations: self.settings.iterations,
            tolerance: self.settings.tolerance,
            queue: .main
        )
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        self._timer = nil
        return self
    }
    
}

private extension UI.View.Clock {
    
    func onTriggeredTimer() {
        guard let startedTime = self._startedTime else { return }
        let now = DispatchTime.now()
        self.body.content = .init(
            duration: self.body.content.duration,
            elapsed: TimeInterval((now.uptimeNanoseconds - startedTime.uptimeNanoseconds)) / 1_000_000_000
        )
    }
    
    func onFinishedTimer() {
        self.onFinish.emit()
    }
    
}

public extension UI.View.Clock {
    
    @inlinable
    @discardableResult
    func settings(_ value: UI.View.ClockSettings) -> Self {
        self.settings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func settings(_ value: () -> UI.View.ClockSettings) -> Self {
        return self.settings(value())
    }
    
    @inlinable
    @discardableResult
    func settings(_ value: (Self) -> UI.View.ClockSettings) -> Self {
        return self.settings(value(self))
    }
    
}

public extension UI.View.Clock {
    
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

public extension UI.View.Clock where BodyType == UI.View.AttributedText {
    
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

public extension UI.View.Clock where BodyType == UI.View.Text {
    
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

extension UI.View.Clock : IUIViewReusable where BodyType : IUIViewReusable {
}

extension UI.View.Clock : IUIViewDynamicSizeable where BodyType : IUIViewDynamicSizeable {
}

extension UI.View.Clock : IUIViewStaticSizeable where BodyType : IUIViewStaticSizeable {
}

extension UI.View.Clock : IUIViewEditable where BodyType : IUIViewEditable {
}

extension UI.View.Clock : IUIViewStyleable where BodyType : IUIViewStyleable {
}

extension UI.View.Clock : IUIViewHighlightable where BodyType : IUIViewHighlightable {
}

extension UI.View.Clock : IUIViewSelectable where BodyType : IUIViewSelectable {
}

extension UI.View.Clock : IUIViewLockable where BodyType : IUIViewLockable {
}

extension UI.View.Clock : IUIViewPressable where BodyType : IUIViewPressable {
}

extension UI.View.Clock : IUIViewAnimatable where BodyType : IUIViewAnimatable {
}

extension UI.View.Clock : IUIViewCornerRadiusable where BodyType : IUIViewCornerRadiusable {
}

extension UI.View.Clock : IUIViewColorable where BodyType : IUIViewColorable {
}

extension UI.View.Clock : IUIViewAlphable where BodyType : IUIViewAlphable {
}
