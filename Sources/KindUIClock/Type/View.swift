//
//  KindKit
//

import KindEvent
import KindGraphics
import KindTimer
import KindUI

public final class View<
    BodyType : IView,
    ApplierType : IApplier
> : IWidgetView where
    ApplierType.InputType == Tick,
    ApplierType.TargetType == BodyType
{
    
    public var settings: Settings {
        didSet {
            self.body.content = .init(
                duration: self.settings.duration,
                elapsed: 0
            )
            self._timer.reset(
                interval: self.settings.interval,
                iterations: self.settings.iterations,
                restart: self._timer.isRunning
            )
        }
    }
    public var applier: ApplierType {
        set { self.body.applier = newValue }
        get { self.body.applier }
    }
    public let body: ApplierView< BodyType, ApplierType >
    public let onFinish = Signal< Void, Void >()
    
    private var _startedTime: DispatchTime?
    private let _timer: KindTimer.Every
    
    public init(
        settings: Settings,
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
        self._timer = .init(
            interval: settings.interval,
            iterations: settings.iterations,
            tolerance: settings.tolerance,
            queue: .main
        )
        
        self._timer.onTriggered(self, { $0.onTriggeredTimer() })
        self._timer.onFinished(self, { $0.onFinishedTimer() })
    }
    
}

public extension View {
    
    var interval: KindTimer.Interval {
        set {
            self.settings = .init(
                interval: newValue,
                iterations: self.settings.iterations,
                tolerance: self.settings.tolerance
            )
        }
        get { self._timer.interval }
    }
    
    var iterations: Int {
        set {
            self.settings = .init(
                interval: self.settings.interval,
                iterations: newValue,
                tolerance: self.settings.tolerance
            )
        }
        get { self._timer.iterations }
    }
    
    @discardableResult
    func start() -> Self {
        self._startedTime = .now()
        self._timer.start()
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        self._timer.pause()
        self._startedTime = nil
        self.body.content = .init(
            duration: self.body.content.duration,
            elapsed: 0
        )
        return self
    }
    
}

private extension View {
    
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

public extension View {
    
    @inlinable
    @discardableResult
    func settings(_ value: Settings) -> Self {
        self.settings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func settings(_ value: () -> Settings) -> Self {
        return self.settings(value())
    }
    
    @inlinable
    @discardableResult
    func settings(_ value: (Self) -> Settings) -> Self {
        return self.settings(value(self))
    }
    
}

public extension View {
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping () -> Void) -> Self {
        self.onFinish.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (Self) -> Void) -> Self {
        self.onFinish.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onFinish.add(sender, closure)
        return self
    }
    
}

extension View : IViewReusable where BodyType : IViewReusable {
}

extension View : IViewDynamicSizeable where BodyType : IViewDynamicSizeable {
}

extension View : IViewStaticSizeable where BodyType : IViewStaticSizeable {
}

extension View : IViewTextable where BodyType : IViewTextable {
}

extension View : IViewTextAttributable where BodyType : IViewTextAttributable {
}

extension View : IViewTextPlainable where BodyType : IViewTextPlainable {
}

extension View : IViewEditable where BodyType : IViewEditable {
}

extension View : IViewStyleable where BodyType : IViewStyleable {
}

extension View : IViewHighlightable where BodyType : IViewHighlightable {
}

extension View : IViewSelectable where BodyType : IViewSelectable {
}

extension View : IViewLockable where BodyType : IViewLockable {
}

extension View : IViewPressable where BodyType : IViewPressable {
}

extension View : IViewAnimatable where BodyType : IViewAnimatable {
}

extension View : IViewCornerRadiusable where BodyType : IViewCornerRadiusable {
}

extension View : IViewColorable where BodyType : IViewColorable {
}

extension View : IViewAlphable where BodyType : IViewAlphable {
}
