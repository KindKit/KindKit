//
//  KindKit
//

import KindEvent
import KindMath
import KindMonadicMacro

protocol KKPanGestureDelegate : AnyObject {
    
    func shouldBegin(_ gesture: NativeGesture) -> Bool
    func shouldSimultaneously(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    func shouldRequireFailureOf(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    func shouldBeRequiredToFailBy(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    
    func begin(_ gesture: NativeGesture)
    func changed(_ gesture: NativeGesture)
    func cancel(_ gesture: NativeGesture)
    func end(_ gesture: NativeGesture)
    
}

@KindMonadic
public final class PanGesture : IGesture, IGestureContinusable {
    
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
    
    public let onShouldBegin = Signal< Bool?, Void >()
    
    public let onShouldSimultaneously = Signal< Bool?, NativeGesture >()
    
    public let onShouldRequireFailure = Signal< Bool?, NativeGesture >()
    
    public let onShouldBeRequiredToFailBy = Signal< Bool?, NativeGesture >()
    
    public let onBegin = Signal< Void, Void >()
    
    public let onChange = Signal< Void, Void >()
    
    public let onCancel = Signal< Void, Void >()
    
    public let onEnd = Signal< Void, Void >()
    
    private(set) lazy var reuse = ReuseItem< Reusable >(self)

    public init() {
    }
    
    public func translation(in view: any IView) -> Point {
        return .init(self.reuse.content.translation(in: view.handle))
    }
    
    public func velocity(in view: any IView) -> Point {
        return .init(self.reuse.content.velocity(in: view.handle))
    }
    
}

extension PanGesture : KKPanGestureDelegate {
    
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
    
    func begin(_ gesture: NativeGesture) {
        self.onBegin.emit()
    }
    
    func changed(_ gesture: NativeGesture) {
        self.onChange.emit()
    }
    
    func cancel(_ gesture: NativeGesture) {
        self.onCancel.emit()
    }
    
    func end(_ gesture: NativeGesture) {
        self.onEnd.emit()
    }
    
}
