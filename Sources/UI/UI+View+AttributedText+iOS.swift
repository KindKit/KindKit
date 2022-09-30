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
        
    unowned var kkDelegate: KKAttributedTextViewDelegate?
    
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.update(cornerRadius: view.cornerRadius)
                self.updateShadowPath()
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: UI.View.AttributedText?
    private var _tapGesture: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        self._tapGesture = UITapGestureRecognizer(target: self, action: #selector(self._tapHandle(_:)))
        self.addGestureRecognizer(self._tapGesture)
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
        self._view = view
        self.update(text: view.text, alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(text: NSAttributedString, alignment: UI.Text.Alignment?) {
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
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
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
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        let labelSize = self.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self._tapGesture.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if indexOfCharacter >= textStorage.string.count {
            return nil
        }
        return textStorage.attributes(at: indexOfCharacter, effectiveRange: nil)
    }
    
}

#endif
