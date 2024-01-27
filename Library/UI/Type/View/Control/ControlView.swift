//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMeasure
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

@Monadic
public final class ControlView< Layout : ILayout > : IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportEdit, IViewSupportEnable, IViewSupportColor, IViewSupportAlpha {
    
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
    
    @MonadicField(default: EmptyLayout.self)
    public var content: Layout {
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
            if self.isEditing == true {
                self.onBeginEditing.emit()
            } else {
                self.onEndEditing.emit()
            }
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
            self.onEnabled.emit()
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
    
    public let onEnabled = Signal< Void, Void >()
    
    public let onBeginEditing = Signal< Void, Void >()
    
    public let onEndEditing = Signal< Void, Void >()
    
#if os(macOS)
    
    @MonadicSignal
    public let onKeyboard = Signal< Void, Keyboard >()
    
    @MonadicSignal
    public let onMouse = Signal< Void, Mouse >()
    
#elseif os(iOS)
    
    @MonadicSignal
    public let isEmptyInput = Signal< Bool?, Void >()
    
    @MonadicSignal
    public let onInputCommand = Signal< Void, VirtualInput.Command >()
    
    @MonadicSignal
    public let onBeganTouches = Signal< Void, [Touch] >()
    
    @MonadicSignal
    public let onMovedTouches = Signal< Void, [Touch] >()
    
    @MonadicSignal
    public let onEndedTouches = Signal< Void, [Touch] >()
    
    @MonadicSignal
    public let onCancelledTouches = Signal< Void, [Touch] >()
    
#endif
    
    var holder: IHolder? {
        set { self._layout.manager.holder = newValue }
        get { self._layout.manager.holder }
    }
    
    private var _layout: ReuseRootLayoutItem< Reusable, Layout >!
    
    public init(
        _ content: Content
    ) {
        self.content = content
        self._layout = .init(self)
        self._layout.manager.content = content
    }
    
    public convenience init< Init: ILayout >(
        _ content: Init
    ) where Content == AnyLayout {
        self.init(.init(content))
    }
    
    public convenience init(
        _ view: any IView
    ) where Content == AnyViewLayout {
        self.init(.init(view))
    }
    
    public convenience init< View: IView >(
        _ view: View
    ) where Content == ViewLayout< View > {
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
