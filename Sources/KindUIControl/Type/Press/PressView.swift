//
//  KindKit
//

import KindTime
import KindUI
import KindMonadicMacro

@KindMonadic
public final class PressView< ContentType : ILayout > : IComposite, IView {
    
    public let body: ControlView< ContentType >

    public var isHighlighted: Bool = false {
        didSet {
            guard self.isHighlighted != oldValue else { return }
            self.onChange.emit()
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            guard self.isSelected != oldValue else { return }
            self.onChange.emit()
        }
    }
    
    public var content: ContentType {
        set { self.body.content = newValue }
        get { self.body.content }
    }
    
    public var shouldPress: Bool = true
    
    public var availableMouseButtons: [Mouse.Button] = [ .primary ]
    
    public let onPress = Signal< Void, Press >()
    
#if os(macOS)
    
    private var _shouldClick: [Mouse.Button] = [ .primary ]
    private var _mouse: Mouse? {
        didSet {
            guard self._mouse != oldValue else { return }
            self._isHover = self.isContains(self._mouse)
        }
    }
    private var _clickInfo: [Mouse.Button : SecondsInterval] = [:]

#elseif os(iOS)
    
    private var _touches: [Touch] = [] {
        didSet {
            guard self._touches != oldValue else { return }
            self._isHover = self.isContains(self._touches)
        }
    }
    
#endif
    
    private var _isHover: Bool = false {
        didSet {
            guard self._isHover != oldValue else { return }
            self.isHighlighted = self._isHover
        }
    }
    
    public init(
        _ content: ContentType
    ) {
        self.body = .init(content)
#if os(macOS)
        self.body
            .onMouse(self, { $0._on(mouse: $1) })
#elseif os(iOS)
        self.body
            .onBeganTouches(self, { $0._onProcessing(touches: $1) })
            .onMovedTouches(self, { $0._onProcessing(touches: $1) })
            .onEndedTouches(self, { $0._onEnded(touches: $1) })
            .onCancelledTouches(self, { $0._onCancelled(touches: $1) })
#endif
    }
    
    public convenience init< InitType: ILayout >(
        _ content: InitType
    ) where ContentType == AnyLayout {
        self.init(AnyLayout(content))
    }
    
    public convenience init(
        _ view: any IView
    ) where ContentType == AnyViewLayout {
        self.init(AnyViewLayout(view))
    }
    
    public convenience init< ViewType: IView >(
        _ view: ViewType
    ) where ContentType == ViewLayout< ViewType > {
        self.init(ViewLayout(view))
    }
    
}

extension PressView : IViewSupportDynamicSize {
}

extension PressView : IViewSupportContent {
}

extension PressView : IViewSupportChange {
}

extension PressView : IViewSupportPress {
}

extension PressView : IViewSupportHighlighted {
}

extension PressView : IViewSupportSelected {
}

extension PressView : IViewSupportEnable {
}

extension PressView : IViewSupportAlpha {
}

#if os(macOS)

private extension PressView {
    
    func _clicks(new: Mouse, old: Mouse?) -> [Mouse.Click] {
        guard let old = old else { return [] }
        var clicks: [Mouse.Click] = []
        let diff = old.buttons.kk_difference(new.buttons)
        if self.isContains(new) == true {
            for button in diff.added {
                self._clickInfo[button] = .now
            }
        }
        if self.isContains(old) == true {
            for button in diff.removed {
                guard let point = self._clickInfo.removeValue(forKey: button) else { continue }
                clicks.append(.init(
                    location: new.location,
                    button: button,
                    duration: point.delta(from: .now)
                ))
            }
        }
        return clicks
    }
    
    func _set(mouse: Mouse) -> [Mouse.Click] {
        let clicks = self._clicks(new: mouse, old: self._mouse)
        self._mouse = mouse
        return clicks
    }

    func _on(mouse: Mouse) {
        let clicks = self._set(mouse: mouse)
        guard clicks.isEmpty == false else { return }
        for click in clicks {
            guard self.availableMouseButtons.contains(click.button) == true else { return }
            self.onPress.emit(.mouse(click))
        }
    }
    
}

#elseif os(iOS)

private extension PressView {
    
    func _onProcessing(touches: [Touch]) {
        var copy = self._touches
        for touch in touches {
            if let index = copy.firstIndex(where: { $0.uuid == touch.uuid }) {
                copy[index] = touch
            } else {
                copy.append(touch)
            }
        }
        self._touches = copy
    }
    
    func _onEnded(touches: [Touch]) {
        let isHover = self._isHover
        self._onCancelled(touches: touches)
        if isHover == true {
            if self._touches.isEmpty == true && self.shouldPress == true {
                self.onPress.emit(.tap(
                    location: touches.map(\.location).kk_center()
                ))
            }
        }
    }
    
    func _onCancelled(touches: [Touch]) {
        var copy = self._touches
        for touch in touches {
            copy.removeAll(where: { $0.uuid == touch.uuid })
        }
        self._touches = copy
    }
}

#endif
