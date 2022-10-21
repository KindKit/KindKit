//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.External {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.External
        typealias Content = KKExternalView

        static var reuseIdentificator: String {
            return "UI.View.External"
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

final class KKExternalView : UIView {
    
    var content: UIView? {
        willSet {
            self.content?.removeFromSuperview()
        }
        didSet {
            guard let content = self.content else { return }
            content.frame = self.bounds
            self.addSubview(content)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let content = self.content {
            content.frame = self.bounds
        }
    }
    
}

extension KKExternalView {
    
    func update(view: UI.View.External) {
        self.update(content: view.content)
    }
    
    func update(content: UIView?) {
        self.content = content
    }
    
    func cleanup() {
        self.content = nil
    }
    
}

#endif
