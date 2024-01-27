//
//  KindKit
//

#if os(macOS)

import AppKit
import KindTime

final class DisplayLink {
    
    let manager: Manager
    var instance: CVDisplayLink!
    
    init?(manager: Manager) {
        self.manager = manager
        guard let instance = self._makeInstance() else { return }
        self.instance = instance
        CVDisplayLinkStart(instance)
    }
    
    deinit {
        CVDisplayLinkStop(self.instance)
    }
    
}

private extension DisplayLink {
    
    func _makeInstance() -> CVDisplayLink? {
        var displayLink: CVDisplayLink!
        guard CVDisplayLinkCreateWithActiveCGDisplays(&displayLink) == kCVReturnSuccess else {
            return nil
        }
        guard CVDisplayLinkSetOutputCallback(displayLink!, AnimationDisplayLinkCallback, Unmanaged.passUnretained(self).toOpaque()) == kCVReturnSuccess else {
            return nil
        }
        guard CVDisplayLinkSetCurrentCGDisplay(displayLink!, CGMainDisplayID()) == kCVReturnSuccess else {
            return nil
        }
        return displayLink
    }
    
}

fileprivate func AnimationDisplayLinkCallback(
    _ displayLink: CVDisplayLink,
    _ nowTime: UnsafePointer< CVTimeStamp >,
    _ outputTime: UnsafePointer< CVTimeStamp >,
    _ flagsIn: CVOptionFlags,
    _ flagsOut: UnsafeMutablePointer< CVOptionFlags >,
    _ context: UnsafeMutableRawPointer?
) -> CVReturn {
    guard let context = context else { return kCVReturnSuccess }
    let displayLink = Unmanaged< DisplayLink >.fromOpaque(context).takeUnretainedValue()
    let timeScale = TimeInterval(outputTime.pointee.videoTimeScale)
    let refreshPeriod = TimeInterval(outputTime.pointee.videoRefreshPeriod)
    let delta = SecondsInterval(timeInterval: 1 / (timeScale / refreshPeriod))
    DispatchQueue.main.async(execute: {
        displayLink.manager.update(delta)
    })
    return kCVReturnSuccess
}

#endif
