//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class GestureView : IView, IViewSupportStaticSize, IViewSupportEnable {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: StaticSize = .fill {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    @KindMonadicProperty
    public var gestures: [IGesture] {
        set {
            for gesture in self._gestures {
                gesture.owned = nil
            }
            self._gestures = newValue
            for gesture in self._gestures {
                gesture.owned = self
            }
            if self.isLoaded == true {
                self._layout.view.kk_update(gestures: newValue)
            }
        }
        get { self._gestures }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(enabled: self.isEnabled)
            }
        }
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    private var _gestures: [IGesture] = []
    
    public init() {
        self._layout = .init(self)
    }
    
    deinit {
        for gesture in self._gestures {
            gesture.owned = nil
        }
    }

}

public extension GestureView {
    
    @discardableResult
    func add(gesture: IGesture) -> Self {
        if self._gestures.contains(where: { $0 === gesture }) == false {
            self._gestures.append(gesture)
            gesture.owned = self
            if self.isLoaded == true {
                self._layout.view.kk_add(gesture: gesture)
            }
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func add(gesture: (Self) -> IGesture) -> Self {
        return self.add(gesture: gesture(self))
    }
    
    @discardableResult
    func remove(gesture: IGesture) -> Self {
        if let index = self._gestures.firstIndex(where: { $0 === gesture }) {
            self._gestures.remove(at: index)
            if self.isLoaded == true {
                self._layout.view.kk_remove(gesture: gesture)
            }
            gesture.owned = nil
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func remove(gesture: (Self) -> IGesture) -> Self {
        return self.remove(gesture: gesture(self))
    }
    
}
