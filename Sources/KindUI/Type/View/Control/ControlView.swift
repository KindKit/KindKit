//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindTime
import KindMonadicMacro

protocol KKControlViewDelegate : AnyObject {
    
    func kk_shouldEditing() -> Bool
    
#if os(macOS)
    
    func kk_update(keyboard: Keyboard)
    
    func kk_update(mouse: Mouse)
    
#elseif os(iOS)
    
    func kk_inputIsEmpty() -> Bool
    
    func kk_virtualInput(command: VirtualInput.Command)
    
    func kk_began(touches: [Touch])
    
    func kk_moved(touches: [Touch])
    
    func kk_ended(touches: [Touch])
    
    func kk_cancelled(touches: [Touch])
    
#endif
    
}

@KindMonadic
public final class ControlView< LayoutType : ILayout > : IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportChange, IViewSupportEdit, IViewSupportEnable, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self._layout.manager.available = self.size
            self.updateLayout(force: true)
        }
    }
    
    @KindMonadicProperty(default: EmptyLayout.self)
    public var content: LayoutType {
        didSet {
            guard self.content !== oldValue else { return }
            self._layout.manager.content = self.content
        }
    }
    
    public var shouldEditing: Bool = false
    
    public var isEditing: Bool = false {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(editing: self.isEditing)
            }
            self.onChange.emit()
        }
    }
    
#if os(iOS)
    
    public var virtualInputStyle: VirtualInput.Style? {
        didSet {
            guard self.virtualInputStyle != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(virtualInputStyle: self.virtualInputStyle)
            }
        }
    }
    
#endif
    
    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(enabled: self.isEnabled)
            }
            self.onChange.emit()
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
    
    public let onChange = Signal< Void, Void >()
    
#if os(macOS)
    
    @KindMonadicSignal
    public let onKeyboard = Signal< Void, Keyboard >()
    
    @KindMonadicSignal
    public let onMouse = Signal< Void, Mouse >()
    
#elseif os(iOS)
    
    @KindMonadicSignal
    public let isEmptyInput = Signal< Bool?, Void >()
    
    @KindMonadicSignal
    public let onInputCommand = Signal< Void, VirtualInput.Command >()
    
    @KindMonadicSignal
    public let onBeganTouches = Signal< Void, [Touch] >()
    
    @KindMonadicSignal
    public let onMovedTouches = Signal< Void, [Touch] >()
    
    @KindMonadicSignal
    public let onEndedTouches = Signal< Void, [Touch] >()
    
    @KindMonadicSignal
    public let onCancelledTouches = Signal< Void, [Touch] >()
    
#endif
    
    var holder: IHolder? {
        set { self._layout.manager.holder = newValue }
        get { self._layout.manager.holder }
    }
    
    private var _layout: ReuseRootLayoutItem< Reusable, LayoutType >!
    
    public init(
        _ content: ContentType
    ) {
        self.content = content
        self._layout = .init(self)
        self._layout.manager.content = content
    }
    
    public convenience init< InitType: ILayout >(
        _ content: InitType
    ) where ContentType == AnyLayout {
        self.init(.init(content))
    }
    
    public convenience init(
        _ view: any IView
    ) where ContentType == AnyViewLayout {
        self.init(.init(view))
    }
    
    public convenience init< ViewType: IView >(
        _ view: ViewType
    ) where ContentType == ViewLayout< ViewType > {
        self.init(.init(view))
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self._layout.sizeOf(request)
    }
    
}

extension ControlView : KKControlViewDelegate {
    
    func kk_shouldEditing() -> Bool {
        return self.shouldEditing
    }
    
#if os(macOS)
    
    func kk_update(keyboard: Keyboard) {
        self.onKeyboard.emit(keyboard)
    }
    
    func kk_update(mouse: Mouse) {
        self.onMouse.emit(mouse)
    }
    
#elseif os(iOS)
    
    func kk_inputIsEmpty() -> Bool {
        return self.isEmptyInput.emit(default: true)
    }
    
    func kk_virtualInput(command: VirtualInput.Command) {
        self.onInputCommand.emit(command)
    }
    
    func kk_began(touches: [Touch]) {
        self.onBeganTouches.emit(touches)
    }
    
    func kk_moved(touches: [Touch]) {
        self.onMovedTouches.emit(touches)
    }
    
    func kk_ended(touches: [Touch]) {
        self.onEndedTouches.emit(touches)
    }
    
    func kk_cancelled(touches: [Touch]) {
        self.onCancelledTouches.emit(touches)
    }
    
#endif
    
}
