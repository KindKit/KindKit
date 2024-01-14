//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension TextView {
    
    struct Reusable : IReusable {
        
        typealias Owner = TextView
        typealias Content = KKTextView

        static var reuseIdentificator: String {
            return "TextView"
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

final class KKTextView : UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKTextView {
    
    func update(view: TextView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(text: view.text)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.integral.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(text: String) {
        self.text = text
    }
    
    func update(textFont: Font) {
        self.font = textFont.native
    }
    
    func update(textColor: Color) {
        self.textColor = textColor.native
    }
    
    func update(alignment: Text.Alignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(lineBreak: Text.LineBreak) {
        self.lineBreakMode = lineBreak.nsLineBreakMode
    }
    
    func update(numberOfLines: UInt) {
        self.numberOfLines = Int(numberOfLines)
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
