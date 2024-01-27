//
//  KindKit
//

import Foundation
import KindEvent
import KindLayout
import KindText

protocol KKTextViewDelegate : AnyObject {
    
    func kk_shouldTap() -> Bool
    
    func kk_tap(at index: Text.Index)
    
}

public final class TextView : IView, IViewDynamicSizeable, IViewTextable, IViewColorable, IViewAlphable {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return self._layout.isLoaded
    }

    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var style: Style = .default {
        didSet {
            guard self.style != oldValue else { return }
            self._attributed = nil
            if self.isLoaded == true {
                self._layout.view.kk_update(attributed: self.attributed)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var text = Text() {
        didSet {
            guard self.text != oldValue else { return }
            self._attributed = nil
            if self.isLoaded == true {
                self._layout.view.kk_update(attributed: self.attributed)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var numberOfLines: UInt = 0 {
        didSet {
            guard self.numberOfLines != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(numberOfLines: self.numberOfLines)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var color: Color? = .clear {
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
    
    public let onTap = Signal< Void, URL >()
    
    var attributed: NSAttributedString {
        if self._attributed == nil {
            self._attributed = .kk_make(self.text, base: self.style)
        }
        return self._attributed!
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    private var _attributed: NSAttributedString?
    
    public init() {
        self._layout = .init(self)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            calculate: {
                return self.attributed.kk_size(
                    numberOfLines: self.numberOfLines,
                    available: $0
                )
            }
        )
    }

}

extension TextView : KKTextViewDelegate {
    
    func kk_shouldTap() -> Bool {
        return self.text.shouldLink
    }
    
    func kk_tap(at index: Text.Index) {
        guard let url = self.text.link(at: index) else { return }
        self.onTap.emit(url)
    }
    
}
