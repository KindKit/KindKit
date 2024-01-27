//
//  KindKit
//

import KindMeasure
import KindLayout
import KindStyleSheet
import KindMonadicMacro

@Monadic
public final class PressView< Template : ITemplate > : CompositorTrait, IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportPress, IViewSupportColor, IViewSupportAlpha {
    
    public let body: ControlView< Template.Layout >
    
    @MonadicField
    public var styleSheet: Template.StyleSheet {
        didSet {
            guard self.styleSheet != oldValue else { return }
            self.activeStyleSheet = self.styleSheet.resolve(self._styleState)
        }
    }
    
    public private(set) var activeStyleSheet: Template.StyleSheet.Resolve {
        didSet {
            guard self.activeStyleSheet != oldValue else { return }
            self.content.apply(self.activeStyleSheet)
        }
    }
    
    public var content: Template {
        didSet {
            guard self.content != oldValue else { return }
            self.body.content = self.content
        }
    }
    
    public var shouldPress: Bool = true
    
    public var availableMouseButtons: [Mouse.Button] = [ .primary ]
    
    public let onPress = Signal< Void, Press >()
    
    private var _styleState: KindStyleSheet.States = [] {
        didSet {
            self.activeStyleSheet = self.styleSheet.resolve(self._styleState)
        }
    }
    
    private var _isHighlighted: Bool = false {
        didSet {
            guard self._isHighlighted != oldValue else { return }
            if self._isHighlighted == true {
                self._styleState.insert(.hightlighted)
            } else {
                self._styleState.remove(.hightlighted)
            }
            self._onHighlighted.emit()
        }
    }
    
    private var _isSelected: Bool = false {
        didSet {
            guard self._isSelected != oldValue else { return }
            if self._isSelected == true {
                self._styleState.insert(.selected)
            } else {
                self._styleState.remove(.selected)
            }
            self._onSelected.emit()
        }
    }
    
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
            self._isHighlighted = self._isHover
        }
    }
    
    private let _onHighlighted = Signal< Void, Void >()
    
    private let _onSelected = Signal< Void, Void >()
    
    public init(
        content: Template,
        styleSheet: Template.StyleSheet
    ) {
        self.styleSheet = styleSheet
        self.activeStyleSheet = styleSheet.resolve([])
        self.content = content

        self.body = .init(content.layout)
        
        self.body
            .onEnabled(self, { $0._onEnabled() })
        
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
        
        self.content.apply(self.activeStyleSheet)
    }
    
}

extension PressView : IViewSupportHighlighted where Content.StyleSheet : HighlightedStyleSheetTrait {
    
    public var isHighlighted: Bool {
        set { self._isHighlighted = newValue }
        get { self._isHighlighted }
    }
    
    public var onHighlighted: Signal< Void, Void > {
        self._onHighlighted
    }

}

extension PressView : IViewSupportSelected where Content.StyleSheet : SelectedStyleSheetTrait {
    
    public var isSelected: Bool {
        set { self._isSelected = newValue }
        get { self._isSelected }
    }
    
    public var onSelected: Signal< Void, Void > {
        self._onSelected
    }
    
}

extension PressView : IViewSupportEnable where Content.StyleSheet : DisabledStyleSheetTrait {
}

private extension PressView {
    
    func _onEnabled() {
        if self.body.isEnabled == false {
            self._styleState.insert(.disabled)
        } else {
            self._styleState.remove(.disabled)
        }
    }
    
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
