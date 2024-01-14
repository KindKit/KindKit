//
//  KindKit
//

#if os(macOS)

import AppKit

final class DisplayLink {
    
    weak var delegate: IQueueDelegate?
    
    var isRunning: Bool {
        guard let instance = self._instance else { return false }
        return CVDisplayLinkIsRunning(instance)
    }
    
    fileprivate var _instance: CVDisplayLink?
    
    deinit {
        self.stop()
    }
    
    func start() {
        if self._instance == nil {
            self._instance = self._makeInstance()
        }
        if let instance = self._instance {
            CVDisplayLinkStart(instance)
        }
    }
    
    func stop() {
        guard let instance = self._instance else { return }
        CVDisplayLinkStop(instance)
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
    let delta = 1 / (timeScale / refreshPeriod)
    DispatchQueue.main.async(execute: {
        displayLink.delegate?.update(delta)
    })
    return kCVReturnSuccess
}

#endif
