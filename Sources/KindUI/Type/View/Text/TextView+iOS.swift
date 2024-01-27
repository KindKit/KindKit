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
        
        static func name(owner: Owner) -> String {
            return "TextView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: CGRect.zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKTextView : UILabel {
    
    weak var kkDelegate: KKTextViewDelegate?
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
        let shouldTap = self.kkDelegate?.kk_shouldTap()
        if shouldTap == true {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
}

extension KKTextView {
    
    func kk_update(view: TextView) {
        self.kk_update(frame: view.frame)
        self.kk_update(attributed: view.attributed)
        self.kk_update(numberOfLines: view.numberOfLines)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    final func kk_cleanup(view: TextView) {
        self.kkDelegate = nil
    }
    
}

extension KKTextView {
    
    func kk_update(attributed: NSAttributedString) {
        self.attributedText = attributed
    }
    
    func kk_update(numberOfLines: UInt) {
        self.numberOfLines = Int(numberOfLines)
    }
    
    func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

private extension KKTextView {
    
    @objc
    func _tapHandle(_ target: Any) {
        guard let index = self._tapCharacterIndex() else { return }
        self.kkDelegate?.kk_tap(at: index)
    }
    
    func _tapCharacterIndex() -> Int? {
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
        return indexOfCharacter
    }
    
}

#endif
