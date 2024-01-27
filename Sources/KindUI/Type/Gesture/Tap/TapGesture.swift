//
//  KindKit
//

import KindEvent
import KindMonadicMacro

protocol KKTapGestureDelegate : AnyObject {
    
    func shouldBegin(_ gesture: NativeGesture) -> Bool
    func shouldSimultaneously(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    func shouldRequireFailureOf(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    func shouldBeRequiredToFailBy(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    
    func triggered(_ gesture: NativeGesture)
    
}

@KindMonadic
public final class TapGesture : IGesture, IGestureTriggerable {
    
    public unowned var owned: (any IView)? {
        didSet {
            guard self.owned !== oldValue else { return }
            if self.owned == nil {
                self.reuse.disappear()
            }
        }
    }
    
    public var handle: NativeGesture {
        return self.reuse.content
    }
    
    public var isLoaded: Bool {
        return self.reuse.isLoaded
    }

    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(enabled: self.isEnabled)
            }
        }
    }
    
#if os(iOS)
    
    public var cancelsInView: Bool = false {
        didSet {
            guard self.cancelsInView != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(cancelsInView: self.cancelsInView)
            }
        }
    }
    
    public var delaysBegan: Bool = false {
        didSet {
            guard self.delaysBegan != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(delaysBegan: self.delaysBegan)
            }
        }
    }
    
    public var delaysEnded: Bool = true {
        didSet {
            guard self.delaysEnded != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(delaysEnded: self.delaysEnded)
            }
        }
    }
    
    public var requiresExclusive: Bool = true {
        didSet {
            guard self.requiresExclusive != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(requiresExclusive: self.requiresExclusive)
            }
        }
    }
    
#endif
    
#if os(macOS)
    
    @KindMonadicProperty
    public var delays: Bool = false {
        didSet {
            guard self.delays != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(delays: self.delays, button: self.button)
            }
        }
    }
    
    @KindMonadicProperty
    public var button: Mouse.Button = .primary {
        didSet {
            guard self.button != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(delays: self.delays, button: self.button)
            }
        }
    }
    
#endif
    
    @KindMonadicProperty
    public var numberOfTapsRequired: UInt = 1 {
        didSet {
            guard self.numberOfTapsRequired != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(numberOfTapsRequired: self.numberOfTapsRequired)
            }
        }
    }
    
    @KindMonadicProperty
    public var numberOfTouchesRequired: UInt = 1 {
        didSet {
            guard self.numberOfTouchesRequired != oldValue else { return }
            if self.isLoaded == true {
                self.reuse.content.kk_update(numberOfTouchesRequired: self.numberOfTouchesRequired)
            }
        }
    }
    
    public let onShouldBegin = Signal< Bool?, Void >()
    
    public let onShouldSimultaneously = Signal< Bool?, NativeGesture >()
    
    public let onShouldRequireFailure = Signal< Bool?, NativeGesture >()
    
    public let onShouldBeRequiredToFailBy = Signal< Bool?, NativeGesture >()
    
    public let onTriggered = Signal< Void, Void >()
    
    private(set) lazy var reuse = ReuseItem< Reusable >(self)
    
    public init() {
    }
    
}

extension TapGesture : KKTapGestureDelegate {
    
    func shouldBegin(_ gesture: NativeGesture) -> Bool {
        return self.onShouldBegin.emit(default: true)
    }
    
    func shouldSimultaneously(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self.onShouldSimultaneously.emit(otherGesture, default: false)
    }
    
    func shouldRequireFailureOf(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self.onShouldRequireFailure.emit(otherGesture, default: false)
    }
    
    func shouldBeRequiredToFailBy(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self.onShouldBeRequiredToFailBy.emit(otherGesture, default: false)
    }
    
    func triggered(_ gesture: NativeGesture) {
        self.onTriggered.emit()
    }
    
}
