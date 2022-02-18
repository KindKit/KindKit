//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension ProgressView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ProgressView
        typealias Content = NativeProgressView

        static var reuseIdentificator: String {
            return "ProgressView"
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

final class NativeProgressView : UIProgressView {
    
    private unowned var _view: ProgressView?
    private var _progress: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        
        self._progress = UIProgressView()
        self.addSubview(self._progress)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let progressSize = self._progress.sizeThatFits(bounds.size)
        self._progress.frame = CGRect(
            x: bounds.midX - (progressSize.width / 2),
            y: bounds.midY - (progressSize.height / 2),
            width: progressSize.width,
            height: progressSize.height
        )
    }
    
}

extension NativeProgressView {
    
    func update(view: ProgressView) {
        self._view = view
        self.update(progressColor: view.progressColor)
        self.update(trackColor: view.trackColor)
        self.update(progress: view.progress)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(progressColor: Color) {
        self._progress.progressTintColor = progressColor.native
    }
    
    func update(trackColor: Color) {
        self._progress.trackTintColor = trackColor.native
    }
    
    func update(progress: Float) {
        self._progress.progress = progress
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
