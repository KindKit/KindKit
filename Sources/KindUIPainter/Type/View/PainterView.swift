//
//  KindKit
//

import KindUI
import KindMonadicMacro

protocol KKPainterViewDelegate : AnyObject {
    
    func kk_draw(_ context: Context)
    
    func kk_should(event: ShouldEvent) -> Bool
    func kk_handle(event: Event)
    
}

@KindMonadic
public final class PainterView : IView, IViewSupportStaticSize, IViewSupportEnable, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return self._layout.isLoaded
    }
    
    public var size: StaticSize = .fill {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(enabled: self.isEnabled)
            }
        }
    }
    
    public var color: Color = .clear {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(color: self.color)
            }
        }
    }
    
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(alpha: self.alpha)
            }
        }
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    @KindMonadicSignal
    public let onDraw = Signal< Void, Context >()
    
    @KindMonadicSignal
    public let onShouldEvent = Signal< Bool?, ShouldEvent >()
    
    @KindMonadicSignal
    public let onEvent = Signal< Void, Event >()
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
    }
    
}

extension PainterView : KKPainterViewDelegate {
    
    func kk_draw(_ context: Context) {
        self.onDraw.emit(context)
    }
    
    func kk_should(event: ShouldEvent) -> Bool {
        return self.onShouldEvent.emit(event) ?? false
    }
    
    func kk_handle(event: Event) {
        self.onEvent.emit(event)
    }
    
}
