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
    public var settings: ClockSettings< UnitType > {
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
        settings: ClockSettings< UnitType >,
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

// MARK: Supporting standart features

extension ClockView : IViewSupportAlpha where BodyType : IViewSupportAlpha {
}

extension ClockView : IViewSupportAnimate where BodyType : IViewSupportAnimate {
}

extension ClockView : IViewSupportBorder where BodyType : IViewSupportBorder {
}

extension ClockView : IViewSupportChange where BodyType : IViewSupportChange {
}

extension ClockView : IViewSupportColor where BodyType : IViewSupportColor {
}

extension ClockView : IViewSupportContent where BodyType : IViewSupportContent {
}

extension ClockView : IViewSupportCornerRadius where BodyType : IViewSupportCornerRadius {
}

extension ClockView : IViewSupportDragDestination where BodyType : IViewSupportDragDestination {
}

extension ClockView : IViewSupportDragSource where BodyType : IViewSupportDragSource {
}

extension ClockView : IViewSupportDynamicSize where BodyType : IViewSupportDynamicSize {
}

extension ClockView : IViewSupportEdit where BodyType : IViewSupportEdit {
}

extension ClockView : IViewSupportEnable where BodyType : IViewSupportEnable {
}

extension ClockView : IViewSupportHighlighted where BodyType : IViewSupportHighlighted {
}

extension ClockView : IViewSupportPages where BodyType : IViewSupportPages {
}

extension ClockView : IViewSupportPress where BodyType : IViewSupportPress {
}

extension ClockView : IViewSupportProgress where BodyType : IViewSupportProgress {
}

extension ClockView : IViewSupportScroll where BodyType : IViewSupportScroll {
}

extension ClockView : IViewSupportSelected where BodyType : IViewSupportSelected {
}

extension ClockView : IViewSupportShadow where BodyType : IViewSupportShadow {
}

extension ClockView : IViewSupportStaticSize where BodyType : IViewSupportStaticSize {
}

extension ClockView : IViewSupportText where BodyType : IViewSupportText {
}

extension ClockView : IViewSupportTintColor where BodyType : IViewSupportTintColor {
}

extension ClockView : IViewSupportTransform where BodyType : IViewSupportTransform {
}

extension ClockView : IViewSupportZoom where BodyType : IViewSupportZoom {
}

// MARK: Supporting control features

extension ClockView : IViewSupportBackground where BodyType : IViewSupportBackground {
}

extension ClockView : IViewSupportInset where BodyType : IViewSupportInset {
}

extension ClockView : IViewSupportItems where BodyType : IViewSupportItems {
}

extension ClockView : IViewSupportPlacement where BodyType : IViewSupportPlacement {
}

extension ClockView : IViewSupportSeparator where BodyType : IViewSupportSeparator {
}
