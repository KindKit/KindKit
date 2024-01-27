//
//  KindKit
//

import KindTimer
import KindUI
import KindMonadicMacro

@KindMonadic
public final class ClockView<
    BodyType : IView,
    ApplierType : IApplier,
    UnitType : KindTime.IUnit
> : IComposite, IView where
    ApplierType.InputType == ClockTick< UnitType >,
    ApplierType.TargetType == BodyType
{
    
    public let body: ApplierView< BodyType, ApplierType >
    
    @KindMonadicProperty
    public var settings: Settings {
        didSet {
            self.body.content = .init(
                duration: self.settings.duration,
                elapsed: .zero
            )
            self._timer.reset(
                interval: self.settings.interval,
                iterations: self.settings.iterations,
                restart: self._timer.isRunning
            )
        }
    }
    
    @KindMonadicProperty
    public var interval: Interval< UnitType > {
        set {
            self.settings = .init(
                tolerance: self.settings.tolerance,
                interval: newValue,
                iterations: self.settings.iterations
            )
        }
        get { self._timer.interval }
    }
    
    @KindMonadicProperty
    public var iterations: Int {
        set {
            self.settings = .init(
                tolerance: self.settings.tolerance,
                interval: self.settings.interval,
                iterations: newValue
            )
        }
        get { self._timer.iterations }
    }
    
    @KindMonadicProperty
    public var applier: ApplierType {
        set { self.body.applier = newValue }
        get { self.body.applier }
    }
    
    @KindMonadicSignal
    public let onFinish = Signal< Void, Void >()
    
    private var _started: Interval< UnitType >?
    private let _timer: KindTimer.Every< UnitType >
    
    public init(
        settings: Settings,
        applier: ApplierType,
        body: BodyType
    ) {
        self.settings = settings
        
        self.body = .init(
            content: .init(
                duration: settings.duration,
                elapsed: .zero
            ),
            applier: applier,
            body: body
        )
        
        self._timer = .init(
            tolerance: settings.tolerance,
            interval: settings.interval,
            iterations: settings.iterations,
            queue: .main
        )
        
        self._timer
            .onTriggered(self, { $0._onTimerTriggered() })
            .onFinished(self, { $0._onTimerFinished() })
    }
    
}

public extension ClockView {
    
    @discardableResult
    func start() -> Self {
        self._started = .now
        self._timer.start()
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        self._timer.pause()
        self._started = nil
        self.body.content = .init(
            duration: self.body.content.duration,
            elapsed: .zero
        )
        return self
    }
    
}

private extension ClockView {
    
    func _onTimerTriggered() {
        guard let started = self._started else { return }
        self.body.content = .init(
            duration: self.body.content.duration,
            elapsed: .now - started
        )
    }
    
    func _onTimerFinished() {
        self.onFinish.emit()
    }
    
}

extension ClockView : IViewDynamicSizeable where BodyType : IViewDynamicSizeable {
}

extension ClockView : IViewStaticSizeable where BodyType : IViewStaticSizeable {
}

extension ClockView : IViewTextable where BodyType : IViewTextable {
}

extension ClockView : IViewEditable where BodyType : IViewEditable {
}

extension ClockView : IViewHighlightable where BodyType : IViewHighlightable {
}

extension ClockView : IViewSelectable where BodyType : IViewSelectable {
}

extension ClockView : IViewEnableable where BodyType : IViewEnableable {
}

extension ClockView : IViewPressable where BodyType : IViewPressable {
}

extension ClockView : IViewAnimatable where BodyType : IViewAnimatable {
}

extension ClockView : IViewCornerRadiusable where BodyType : IViewCornerRadiusable {
}

extension ClockView : IViewColorable where BodyType : IViewColorable {
}

extension ClockView : IViewAlphable where BodyType : IViewAlphable {
}
