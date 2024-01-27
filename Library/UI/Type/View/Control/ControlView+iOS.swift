//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindGeometry

extension ControlView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ControlView
        typealias Content = KKControlView
        
        static func name(owner: Owner) -> String {
            return "ControlView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKControlView : UIView, UTextInputTraits {
    
    var autocapitalization: UITextAutocapitalization = .sentences
    var autocorrection: UITextAutocorrection = .default
    var spellChecking: UITextSpellChecking = .default
    var smartQuotes: UITextSmartQuotes = .default
    var smartDashes: UITextSmartDashes = .default
    var smartInsertDelete: UITextSmartInsertDelete = .default
    var keyboard: UIKeyboard = .default
    var keyboardAppearance: UIKeyboardAppearance = .default
    var returnKey: UIReturnKey = .default
    var enablesReturnKeyAutomatically: Bool = false
    var isSecureTextEntry: Bool = false
    var textContent: UITextContent! = nil
    var passwordRules: UITextInputPasswordRules? = nil
    
    weak var kkDelegate: KKControlViewDelegate?
    
    var kkToucheMaps: [UITouch : UUID] = [:]
    
    override var canBecomeFirstResponder: Bool {
        return self.kkDelegate?.kk_shouldEditing() ?? false
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.kkDelegate?.kk_began(touches: self._touches(touches))
    }
    
    override func touchesMoved(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.kkDelegate?.kk_moved(touches: self._touches(touches))
    }
    
    override func touchesEnded(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.kkDelegate?.kk_ended(touches: self._touches(touches, removing: true))
    }
    
    override func touchesCancelled(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.kkDelegate?.kk_cancelled(touches: self._touches(touches, removing: true))
    }
    
}

extension KKControlView : UIKeyInput {
    
    var hasText: Bool {
        return self.kkDelegate?.kk_inputIsEmpty() ?? false
    }

    func insertText(_ text: String) {
        self.kkDelegate?.kk_virtualInput(command: .insert(text))
    }

    func deleteBackward() {
        self.kkDelegate?.kk_virtualInput(command: .backward)
    }
    
}

extension KKControlView {
    
    final func kk_update< Layout : ILayout >(view: ControlView< Layout >) {
        self.kk_update(frame: view.frame)
        self.kk_update(editing: view.isEditing)
        self.kk_update(enabled: view.isEnabled)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
        view.holder = LayoutHolder(self)
    }
    
    final func kk_cleanup< Layout : ILayout >(view: ControlView< Layout >) {
        view.holder = nil
        self.kkToucheMaps.removeAll()
        self.kkDelegate = nil
    }
    
}

extension KKControlView {
    
    final func kk_update(virtualInputStyle: VirtualInput.Style?) {
        self.keyboard = virtualInputStyle?.type ?? .default
        self.keyboardAppearance = virtualInputStyle?.appearance ?? .default
        self.autocapitalization = virtualInputStyle?.autocapitalization ?? .sentences
        self.autocorrection = virtualInputStyle?.autocorrection ?? .default
        self.spellChecking = virtualInputStyle?.spellChecking ?? .default
        self.returnKey = virtualInputStyle?.returnKey ?? .default
        self.enablesReturnKeyAutomatically = virtualInputStyle?.enablesReturnKeyAutomatically ?? true
        self.textContent = virtualInputStyle?.textContent
        self.reloadInputViews()
    }
    
    final func kk_update(editing: Bool) {
        if editing == true {
            self.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
    
    final func kk_update(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

fileprivate extension KKControlView {
    
    final func _touches(_ uiTouches: Set< UITouch >, removing: Bool = false) -> [Touch] {
        var affected: [Touch] = []
        for uiTouch in uiTouches {
            if let uuid = self.kkToucheMaps[uiTouch] {
                if removing == true {
                    self.kkToucheMaps[uiTouch] = nil
                }
                affected.append(.init(
                    uuid: uuid,
                    touch: uiTouch,
                    view: self
                ))
            } else {
                affected.append(.init(
                    touch: uiTouch,
                    view: self
                ))
            }
        }
        return affected
    }
    
}

#endif
