//
//  KindKit
//

#if os(iOS)

import UIKit
import AVFoundation
import KindPlayer
import KindUI

extension View {
    
    struct Reusable : IReusable {
        
        typealias Owner = View
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

final class KKVideoView : UIView {
    
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
    var kkLayer: AVPlayerLayer {
        return super.layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKVideoView {
    
    func update(view: View) {
        self.update(frame: view.frame)
        self.update(player: view.player)
        self.update(mode: view.mode)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: KindMath.Rect) {
        self.frame = frame.cgRect
    }
    
    func update(player: Player?) {
        self.kkPlayer = player
    }
    
    func update(mode: View.Mode) {
        switch mode {
        case .stretch: self.kkLayer.videoGravity = .resize
        case .aspectFit: self.kkLayer.videoGravity = .resizeAspect
        case .aspectFill: self.kkLayer.videoGravity = .resizeAspectFill
        }
    }

    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkPlayer = nil
    }
    
}

#endif
