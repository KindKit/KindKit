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
        self.inputAccessoryView = self.kkAccessoryView
        self.clipsToBounds = true
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadInputViews() {
        do {
            let width = UIScreen.main.bounds.width
            let height = self.kkAccessoryView.kkHeight
            self.kkAccessoryView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        super.reloadInputViews()
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
    
    func select(suggestion: String) {
        self.text = suggestion
        self.sendActions(for: .editingChanged)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
        self.kkDelegate?.pressed(self, suggestion: suggestion)
        self.endEditing(false)
    }

}

extension KKInputStringView {
    
    final class KKAccessoryView : UIInputView {
        
        weak var kkInput: KKInputStringView?
        var kkSuggestion: IInputSuggestion? {
            didSet {
                guard self.kkSuggestion !== oldValue else { return }
                if self.kkSuggestion != nil {
                    let size = self.bounds.size
                    
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .horizontal
                    layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    
                    let view = UICollectionView(
                        frame: CGRect(x: 0, y: 0, width: size.width, height: 56),
                        collectionViewLayout: layout
                    )
                    view.contentInsetAdjustmentBehavior = .never
                    view.showsHorizontalScrollIndicator = false
                    view.showsVerticalScrollIndicator = false
                    view.alwaysBounceVertical = false
                    view.backgroundColor = nil
                    view.register(KKSuggestionDataCell.self, forCellWithReuseIdentifier: Self.suggestionCellIdentifier)
                    view.register(KKSuggestionSeparatorCell.self, forCellWithReuseIdentifier: Self.separatorCellIdentifier)
                    
                    self.kkSuggestionView = view
                } else {
                    self.kkSuggestionView = nil
                }
            }
        }
        var kkSuggestionVariants: [String] = [] {
            didSet {
                guard self.kkSuggestionVariants != oldValue else { return }
                self.kkSuggestionView?.reloadData()
                self.kkInput?.reloadInputViews()
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
                self.kkInput?.reloadInputViews()
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
                self.kkInput?.reloadInputViews()
            }
        }
        var kkContentViews: [UIView] {
            var views: [UIView] = []
            if let view = self.kkToolbarView {
                views.append(view)
            }
            if let view = self.kkSuggestionView {
                views.append(view)
            }
            return views
        }
        var kkHeight: CGFloat {
            var result: CGFloat = 0
            for subview in self.kkContentViews {
                result += subview.frame.height
            }
            return result
        }
        
        init(frame: CGRect) {
            super.init(frame: frame, inputViewStyle: .keyboard)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let bounds = self.bounds
            var offset: CGFloat = 0
            for subview in self.kkContentViews {
                let height = subview.frame.height
                subview.frame = CGRect(
                    x: bounds.origin.x,
                    y: offset,
                    width: bounds.size.width,
                    height: height
                )
                offset += height
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
            
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.kkTitle)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let bounds = self.bounds
            self.kkTitle.frame = bounds.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
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
            
            super.init(frame: frame)
            
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.kkLine)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let bounds = self.bounds.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
            let width = 1.0
            let height = bounds.height * 0.45
            self.kkLine.frame = .init(
                x: bounds.midX - (width / 2),
                y: bounds.midY - (height / 2),
                width: width,
                height: height
            )
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
    
    func update(view: UI.View.Input.String) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(text: view.text)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(editingColor: view.editingColor)
        self.update(placeholder: view.placeholder)
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
    
    func update(text: Swift.String) {
        self.text = text
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
    
    func update(placeholder: UI.View.Input.Placeholder?) {
        if let placeholder = placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholder.text, attributes: [
                .font: placeholder.font.native,
                .foregroundColor: placeholder.color.native
            ])
        } else {
            self.attributedPlaceholder = nil
        }
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
        self.kkDelegate = nil
    }
    
}

extension KKInputStringView : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        if let suggestion = self.kkSuggestion {
            self.kkSuggestionVariants = suggestion.variants(text)
        }
        self.kkDelegate?.beginEditing(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        guard let range = Range< String.Index >(range, in: oldText) else {
            return false
        }
        var newText = oldText.kk_replacing(range, with: string)
        let variants: [String]
        let caretLower: String.Index
        if string.count > 0 {
            caretLower = newText.index(range.lowerBound, offsetBy: 1)
        } else {
            caretLower = range.lowerBound
        }
        var caretUpper = caretLower
        if let suggestion = self.kkSuggestion {
            variants = suggestion.variants(newText)
            if newText.isEmpty == false && string.isEmpty == false && caretLower <= newText.endIndex {
                if let autoComplete = suggestion.autoComplete(newText) {
                    caretUpper = autoComplete.endIndex
                    newText = autoComplete
                }
            }
        } else {
            variants = []
        }
        if oldText != newText {
            textField.text = newText
            textField.sendActions(for: .editingChanged)
            NotificationCenter.default.post(
                name: UITextField.textDidChangeNotification,
                object: textField
            )
        }
        do {
            let selectionLower = textField.position(
                from: textField.beginningOfDocument,
                offset: caretLower.utf16Offset(in: newText)
            )
            let selectionUpper = textField.position(
                from: textField.beginningOfDocument,
                offset: caretUpper.utf16Offset(in: newText)
            )
            if let selectionLower = selectionLower, let selectionUpper = selectionUpper {
                textField.selectedTextRange = textField.textRange(from: selectionLower, to: selectionUpper)
            }
        }
        self.kkSuggestionVariants = variants
        self.kkDelegate?.editing(self, text: newText)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.kkSuggestionVariants = []
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
            self.kkInput?.select(suggestion: variant)
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
