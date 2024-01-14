//
//  KindKit
//

protocol KKGestureDelegate : AnyObject {
    
    func shouldBegin(_ gesture: NativeGesture) -> Bool
    func shouldSimultaneously(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    func shouldRequireFailureOf(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    func shouldBeRequiredToFailBy(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool
    
}
