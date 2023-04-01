//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Progress {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Progress
        typealias Content = KKProgressView

        static var reuseIdentificator: String {
            return "UI.View.Progress"
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

final class KKProgressView : UIView {
    
    let kkProgress: UIProgressView
    
    override init(frame: CGRect) {
        self.kkProgress = UIProgressView()

        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        
        self.addSubview(self.kkProgress)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let progressSize = self.kkProgress.sizeThatFits(bounds.size)
        self.kkProgress.frame = CGRect(
            x: bounds.midX - (progressSize.width / 2),
            y: bounds.midY - (progressSize.height / 2),
            width: progressSize.width,
            height: progressSize.height
        )
    }
    
}

extension KKProgressView {
    
    func update(view: UI.View.Progress) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(progress: view.progress)
        self.update(progressColor: view.progressColor)
        self.update(trackColor: view.trackColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(progress: Double) {
        self.kkProgress.progress = Float(progress)
    }
    
    func update(progressColor: UI.Color?) {
        self.kkProgress.progressTintColor = progressColor?.native
    }
    
    func update(trackColor: UI.Color?) {
        self.kkProgress.trackTintColor = trackColor?.native
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
