//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.AttributedText {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.AttributedText
        typealias Content = KKAttributedTextView

        static var reuseIdentificator: String {
            return "UI.View.AttributedText"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: CGRect.zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKAttributedTextView : UILabel {
    
    weak var kkDelegate: KKAttributedTextViewDelegate?
    var kkTapGesture: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        self.kkTapGesture = UITapGestureRecognizer(target: self, action: #selector(self._tapHandle(_:)))
        self.addGestureRecognizer(self.kkTapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let shouldTap = self.kkDelegate?.shouldTap(self)
        if shouldTap == true {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
}

extension KKAttributedTextView {
    
    func update(view: UI.View.AttributedText) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(text: view.text, alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.integral.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(text: NSAttributedString?, alignment: UI.Text.Alignment?) {
        self.attributedText = text
        if let alignment = alignment {
            self.textAlignment = alignment.nsTextAlignment
        }
    }
    
    func update(alignment: UI.Text.Alignment?) {
        if let alignment = alignment {
            self.textAlignment = alignment.nsTextAlignment
        }
    }
    
    func update(lineBreak: UI.Text.LineBreak) {
        self.lineBreakMode = lineBreak.nsLineBreakMode
    }
    
    func update(numberOfLines: UInt) {
        self.numberOfLines = Int(numberOfLines)
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKAttributedTextView {
    
    @objc
    func _tapHandle(_ sender: Any) {
        guard let attributes = self._tapAttributes() else { return }
        self.kkDelegate?.tap(self, attributes: attributes)
    }
    
    func _tapAttributes() -> [NSAttributedString.Key: Any]? {
        let layoutManager = NSLayoutManager()
        
        let textContainer = NSTextContainer(size: self.bounds.size)
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        textStorage.addLayoutManager(layoutManager)
        
        let location = self.kkTapGesture.location(in: self)
        let indexOfCharacter = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if indexOfCharacter >= textStorage.string.count {
            return nil
        }
        return textStorage.attributes(at: indexOfCharacter, effectiveRange: nil)
    }
    
}

#endif
