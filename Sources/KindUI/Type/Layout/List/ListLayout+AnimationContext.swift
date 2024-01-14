//
//  KindKit
//

import KindAnimation

extension ListLayout {
    
    final class AnimationContext {
        
        let delay: TimeInterval
        let duration: TimeInterval
        let ease: IEase
        let perform: (_ layout: ListLayout) -> Void
        let completion: (() -> Void)?
        
        public init(
            delay: TimeInterval,
            duration: TimeInterval,
            ease: IEase,
            perform: @escaping (_ layout: ListLayout) -> Void,
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
