//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.String {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.String
        typealias Content = KKInputStringView

        static var reuseIdentificator: String {
            return "UI.View.Input.String"
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

final class KKInputStringView : UITextField {
    
    weak var kkDelegate: KKInputStringViewDelegate?
    let kkAccessoryView: KKAccessoryView
    var kkTextInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkTextInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkPlaceholder: String? {
        didSet {
            guard self.kkPlaceholder != oldValue else { return }
            self.attributedPlaceholder = self._placeholder()
        }
    }
    var kkPlaceholderFont: UIFont? {
        didSet {
            guard self.kkPlaceholderFont != oldValue else { return }
            self.attributedPlaceholder = self._placeholder()
        }
    }
    var kkPlaceholderColor: UIColor? {
        didSet {
            guard self.kkPlaceholderColor != oldValue else { return }
            self.attributedPlaceholder = self._placeholder()
        }
    }
    var kkPlaceholderInset: UIEdgeInsets? {
        didSet {
            guard self.kkPlaceholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkSuggestion: IInputSuggestion? {
        set { self.kkAccessoryView.kkSuggestion = newValue }
        get { self.kkAccessoryView.kkSuggestion }
    }
    var kkSuggestionVariants: [String] {
        set { self.kkAccessoryView.kkSuggestionVariants = newValue }
        get { self.kkAccessoryView.kkSuggestionVariants }
    }
    var kkDisableSuggestion: Bool = false
    override var text: String? {
        didSet {
            let newText = self.text ?? ""
            guard newText != oldValue else { return }
            if self.kkDisableSuggestion == false {
                self.kkSuggestion?.variants(newText)
            }
        }
    }

    override init(frame: CGRect) {
        self.kkAccessoryView = .init(
            frame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 0
            )
        )
        
        super.init(frame: frame)
        
        self.kkAccessoryView.kkInput = self
        
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.kkTextInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.kkTextInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = self.kkPlaceholderInset ?? self.kkTextInset
        return bounds.inset(by: inset)
    }
    
    func select(suggestion: String, index: Int) {
        self._lockSuggestion({
            self.text = suggestion
        })
        self.kkDelegate?.pressed(self, suggestion: suggestion, index: index)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        guard self.canBecomeFirstResponder == true else {
            return false
        }
        self.inputAccessoryView = self.kkAccessoryView
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        guard self.canResignFirstResponder == true else {
            return false
        }
        guard super.resignFirstResponder() == true else {
            return false
        }
        self.inputAccessoryView = nil
        return true
    }

}

extension KKInputStringView {
    
    final class KKAccessoryView : UIInputView {
        
        weak var kkInput: KKInputStringView?
        var kkSuggestion: IInputSuggestion? {
            didSet {
                guard self.kkSuggestion !== oldValue else { return }
                if let suggestion = self.kkSuggestion {
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .horizontal
                    layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    
                    let view = UICollectionView(
                        frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 56),
                        collectionViewLayout: layout
                    )
                    view.contentInsetAdjustmentBehavior = .never
                    view.showsHorizontalScrollIndicator = false
                    view.showsVerticalScrollIndicator = false
                    view.alwaysBounceVertical = false
                    view.backgroundColor = nil
                    view.register(KKSuggestionDataCell.self, forCellWithReuseIdentifier: Self.suggestionCellIdentifier)
                    view.register(KKSuggestionSeparatorCell.self, forCellWithReuseIdentifier: Self.separatorCellIdentifier)
                    
                    self.kkSuggestionSubscribe = suggestion.onVariants.subscribe(self, {
                        $0.kkSuggestionVariants = $1
                    })
                    self.kkSuggestionView = view
                } else {
                    self.kkSuggestionSubscribe = nil
                    self.kkSuggestionView = nil
                }
            }
        }
        var kkSuggestionSubscribe: ICancellable? {
            willSet { self.kkSuggestionSubscribe?.cancel() }
        }
        var kkSuggestionVariants: [String] = [] {
            didSet {
                guard self.kkSuggestionVariants != oldValue else { return }
                self.kkSuggestionView?.reloadData()
            }
        }
        var kkToolbarView: UIView? {
            willSet {
                guard self.kkToolbarView !== newValue else { return }
                self.kkToolbarView?.removeFromSuperview()
            }
            didSet {
                guard self.kkToolbarView !== oldValue else { return }
                if let view = self.kkToolbarView {
                    self.addSubview(view)
                }
            }
        }
        var kkSuggestionView: UICollectionView? {
            willSet {
                guard self.kkSuggestionView !== newValue else { return }
                self.kkSuggestionView?.removeFromSuperview()
            }
            didSet {
                guard self.kkSuggestionView !== oldValue else { return }
                if let view = self.kkSuggestionView {
                    view.delegate = self
                    view.dataSource = self
                    self.addSubview(view)
                }
            }
        }
        
        init(frame: CGRect) {
            super.init(frame: frame, inputViewStyle: .keyboard)
            
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            var height = CGFloat.zero
            do {
                let insets = self.safeAreaInsets
                let baseBounds = self.bounds
                let safeBounds = baseBounds.inset(by: insets)
                if let view = self.kkToolbarView {
                    let viewHeight = view.frame.height
                    view.frame = CGRect(
                        x: safeBounds.origin.x,
                        y: safeBounds.origin.y + height,
                        width: safeBounds.size.width,
                        height: viewHeight
                    )
                    height += viewHeight
                }
                if let view = self.kkSuggestionView {
                    let viewHeight = view.frame.height
                    view.frame = CGRect(
                        x: baseBounds.origin.x,
                        y: safeBounds.origin.y + height,
                        width: baseBounds.size.width,
                        height: viewHeight
                    )
                    height += viewHeight
                }
                if height > .leastNormalMagnitude {
                    height += insets.top + insets.bottom
                }
            }
            if height > .leastNormalMagnitude {
                let oldFrame = self.frame
                let newFrame = CGRect(x: 0, y: 0, width: oldFrame.width, height: height)
                if oldFrame != newFrame {
                    self.frame = newFrame
                    self.kkInput?.reloadInputViews()
                }
            }
        }
        
        override func safeAreaInsetsDidChange() {
            super.safeAreaInsetsDidChange()
            
            let insets = self.safeAreaInsets
            if let view = self.kkSuggestionView {
                view.contentInset = .init(top: 0, left: insets.left, bottom: 0, right: insets.right)
            }
        }
        
    }
    
}

extension KKInputStringView.KKAccessoryView {
    
    final class KKSuggestionDataCell : UICollectionViewCell {
        
        var kkTitle: UILabel
        
        override init(frame: CGRect) {
            self.kkTitle = UILabel(frame: .init(origin: .zero, size: frame.size))
            self.kkTitle.translatesAutoresizingMaskIntoConstraints = false
            self.kkTitle.font = UIFont.preferredFont(forTextStyle: .body)
            if #available(iOS 13.0, *) {
                self.kkTitle.textColor = .label
            } else {
                self.kkTitle.textColor = .black
            }
            self.kkTitle.textAlignment = .center
            self.kkTitle.clipsToBounds = true
            self.kkTitle.layer.cornerRadius = 6
            
            super.init(frame: frame)
            
            self.contentView.addSubview(self.kkTitle)
            self.contentView.addConstraints([
                .init(item: self.kkTitle, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 8),
                .init(item: self.kkTitle, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0),
                .init(item: self.contentView, attribute: .trailing, relatedBy: .equal, toItem: self.kkTitle, attribute: .trailing, multiplier: 1, constant: 0),
                .init(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self.kkTitle, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        static func kkSize(data: String, available: CGSize) -> CGSize {
            let textSize = data.kk_size(
                font: UIFont.preferredFont(forTextStyle: .body),
                numberOfLines: 0,
                available: available
            )
            return .init(
                width: ceil(textSize.width) + 24,
                height: available.height
            )
        }
        
        func kkHighlight() {
            if #available(iOS 13.0, *) {
                self.kkTitle.backgroundColor = .init(dynamicProvider: {
                    switch $0.userInterfaceStyle {
                    case .unspecified, .light:
                        return .white.withAlphaComponent(0.6)
                    case .dark:
                        return .lightGray.withAlphaComponent(0.4)
                    @unknown default:
                        return .white.withAlphaComponent(0.6)
                    }
                })
            } else {
                self.kkTitle.backgroundColor = .systemGray.withAlphaComponent(0.8)
            }
        }
        
        func kkUnhighlight() {
            self.kkTitle.backgroundColor = .clear
        }
        
        func kkApply(data: String) {
            self.kkTitle.text = data
        }
        
    }
    
}

extension KKInputStringView.KKAccessoryView {
    
    final class KKSuggestionSeparatorCell : UICollectionViewCell {
        
        var kkLine: UIView
        
        override init(frame: CGRect) {
            self.kkLine = .init(frame: .zero)
            self.kkLine.translatesAutoresizingMaskIntoConstraints = false
            self.kkLine.backgroundColor = .systemGray
            self.kkLine.alpha = 0.4
            self.kkLine.addConstraints([
                .init(item: self.kkLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
            ])
            
            super.init(frame: frame)
            
            self.contentView.addSubview(self.kkLine)
            self.contentView.addConstraints([
                .init(item: self.kkLine, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.45, constant: 0),
                .init(item: self.kkLine, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0),
                .init(item: self.kkLine, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 4)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        static func kkSize(available: CGSize) -> CGSize {
            return .init(
                width: 17,
                height: available.height
            )
        }
        
    }
    
}

extension KKInputStringView {
    
    func _lockSuggestion(_ block: () -> Void) {
        self.kkDisableSuggestion = true
        block()
        self.kkDisableSuggestion = false
    }
    
}

extension KKInputStringView {
    
    func update(view: UI.View.Input.String) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(value: view.value)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(editingColor: view.editingColor)
        self.update(placeholder: view.placeholder)
        self.update(placeholderFont: view.placeholderFont)
        self.update(placeholderColor: view.placeholderColor)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.update(keyboard: view.keyboard, suggestion: view.suggestion)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(value: Swift.String) {
        self.text = value
    }
    
    func update(textFont: UI.Font) {
        self.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.textColor = textColor.native
    }
    
    func update(textInset: Inset) {
        self.kkTextInset = textInset.uiEdgeInsets
    }
    
    func update(editingColor: UI.Color?) {
        self.tintColor = editingColor?.native
    }
    
    func update(placeholder: String?) {
        self.kkPlaceholder = placeholder
    }
    
    func update(placeholderFont: UI.Font?) {
        self.kkPlaceholderFont = placeholderFont?.native
    }
    
    func update(placeholderColor: UI.Color?) {
        self.kkPlaceholderColor = placeholderColor?.native
    }
    
    func update(placeholderInset: Inset?) {
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.kkAccessoryView.kkToolbarView = toolbar?.native
    }
    
    func update(keyboard: UI.View.Input.Keyboard?, suggestion: IInputSuggestion?) {
        self.keyboardType = keyboard?.type ?? .default
        self.keyboardAppearance = keyboard?.appearance ?? .default
        self.autocapitalizationType = keyboard?.autocapitalization ?? .sentences
        if suggestion != nil {
            self.autocorrectionType = .no
            self.spellCheckingType = .no
        } else {
            self.autocorrectionType = keyboard?.autocorrection ?? .default
            self.spellCheckingType = keyboard?.spellChecking ?? .default
        }
        self.returnKeyType = keyboard?.returnKey ?? .default
        self.enablesReturnKeyAutomatically = keyboard?.enablesReturnKeyAutomatically ?? true
        self.textContentType = keyboard?.textContent
        self.kkSuggestion = suggestion
    }
    
    func cleanup() {
        self.kkAccessoryView.kkToolbarView = nil
        self.kkSuggestion = nil
        self.kkDelegate = nil
    }
    
}

private extension KKInputStringView {
    
    func _placeholder() -> NSAttributedString? {
        guard let string = self.kkPlaceholder else {
            return nil
        }
        guard let font = self.kkPlaceholderFont ?? self.font else {
            return nil
        }
        guard let color = self.kkPlaceholderColor ?? self.textColor else {
            return nil
        }
        return NSAttributedString(string: string, attributes: [
            .font: font,
            .foregroundColor: color
        ])
    }
    
}

extension KKInputStringView : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
        self.kkSuggestion?.variants(textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString replacement: String) -> Bool {
        guard let delegate = self.kkDelegate else {
            return false
        }
        let oldText = textField.text ?? ""
        guard let range = Range< String.Index >(range, in: oldText) else {
            return false
        }
        let info = UI.View.Input.String.ShouldReplace(
            text: oldText,
            range: range,
            replacement: replacement
        )
        guard delegate.shouldReplace(self, info: info) == true else {
            return false
        }
        let newText = oldText.kk_replacing(range, with: replacement)
        var modidfyText = newText
        let caretLower: String.Index
        if replacement.count > 0 {
            caretLower = newText.index(range.lowerBound, offsetBy: 1)
        } else {
            caretLower = range.lowerBound
        }
        var caretUpper = caretLower
        if let suggestion = self.kkSuggestion {
            if newText.isEmpty == false && replacement.isEmpty == false && caretLower <= newText.endIndex {
                if let autoComplete = suggestion.autoComplete(newText) {
                    caretUpper = autoComplete.endIndex
                    modidfyText = autoComplete
                }
            }
        }
        self.kkSuggestion?.variants(newText)
        self.kkDelegate?.editing(self, value: newText)
        if newText == modidfyText {
            return true
        }
        self._lockSuggestion({
            textField.text = modidfyText
            if caretLower != caretUpper {
                let selectionLower = textField.position(
                    from: textField.beginningOfDocument,
                    offset: caretLower.utf16Offset(in: modidfyText)
                )
                let selectionUpper = textField.position(
                    from: textField.beginningOfDocument,
                    offset: caretUpper.utf16Offset(in: modidfyText)
                )
                if let selectionLower = selectionLower, let selectionUpper = selectionUpper {
                    textField.selectedTextRange = textField.textRange(from: selectionLower, to: selectionUpper)
                }
            }
        })
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.kkSuggestionVariants = []
        self.kkDelegate?.editing(self, value: textField.text ?? "")
        self.kkDelegate?.endEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.kkDelegate?.pressedReturn(self)
        return true
    }

}

extension KKInputStringView.KKAccessoryView {
    
    static let suggestionCellIdentifier = "Suggestion"
    static let separatorCellIdentifier = "Separator"
    
}

extension KKInputStringView.KKAccessoryView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if let cell = cell as? KKSuggestionDataCell {
            cell.kkHighlight()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if let cell = cell as? KKSuggestionDataCell {
            cell.kkUnhighlight()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {let isOdd = (indexPath.item % 2 == 0)
        if isOdd == true {
            let index = indexPath.item / 2
            let variant = self.kkSuggestionVariants[index]
            self.kkInput?.select(suggestion: variant, index: index)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension KKInputStringView.KKAccessoryView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.kkSuggestionVariants.isEmpty == false else {
            return 0
        }
        if self.kkSuggestionVariants.count > 1 {
            return (self.kkSuggestionVariants.count * 2) - 1
        }
        return self.kkSuggestionVariants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        let isOdd = (indexPath.item % 2 == 0)
        if isOdd == true {
            let index = indexPath.item / 2
            let variant = self.kkSuggestionVariants[index]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.suggestionCellIdentifier, for: indexPath)
            if let cell = cell as? KKSuggestionDataCell {
                cell.kkApply(data: variant)
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.separatorCellIdentifier, for: indexPath)
        }
        return cell
    }
    
}

extension KKInputStringView.KKAccessoryView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let size: CGSize
        let isOdd = (indexPath.item % 2 == 0)
        if isOdd == true {
            let index = indexPath.item / 2
            let variant = self.kkSuggestionVariants[index]
            size = KKSuggestionDataCell.kkSize(data: variant, available: bounds.size)
        } else {
            size = KKSuggestionSeparatorCell.kkSize(available: bounds.size)
        }
        return size
    }
    
}

#endif
