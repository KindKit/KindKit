//
//  KindKit
//

#if os(macOS)

import AppKit
import AVFoundation

extension UI.View.Video {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Video
        typealias Content = KKVideoView

        static var reuseIdentificator: String {
            return "KKVideoView"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKVideoView : NSView {
    
    var kkPlayer: Player? {
        didSet {
            guard self.kkPlayer !== oldValue else { return }
            if let player = self.kkPlayer {
                self.kkLayer.player = player.native
            } else {
                self.kkLayer.player = nil
            }
        }
    }
    let kkLayer = AVPlayerLayer()

    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer = self.kkLayer
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKVideoView {
    
    func update(view: UI.View.Video) {
        self.update(frame: view.frame)
        self.update(player: view.player)
        self.update(mode: view.mode)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: KindKit.Rect) {
        self.frame = frame.cgRect
    }
    
    func update(player: Player?) {
        self.kkPlayer = player
    }
    
    func update(mode: UI.View.Video.Mode) {
        switch mode {
        case .stretch: self.kkLayer.videoGravity = .resize
        case .aspectFit: self.kkLayer.videoGravity = .resizeAspect
        case .aspectFill: self.kkLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func update(color: UI.Color?) {
        self.kkLayer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
