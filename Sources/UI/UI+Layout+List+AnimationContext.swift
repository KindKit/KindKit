//
//  KindKit
//

import Foundation

extension UI.Layout.List {
    
    final class AnimationContext {
        
        let delay: TimeInterval
        let duration: TimeInterval
        let ease: IAnimationEase
        let perform: (_ layout: UI.Layout.List) -> Void
        let completion: (() -> Void)?
        
        public init(
            delay: TimeInterval,
            duration: TimeInterval,
            ease: IAnimationEase,
            perform: @escaping (_ layout: UI.Layout.List) -> Void,
            completion: (() -> Void)?
        ) {
            self.delay = delay
            self.duration = duration
            self.ease = ease
            self.perform = perform
            self.completion = completion
        }

    }
    
}
