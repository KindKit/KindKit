//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindGeometry
import KindSuggestion

extension SuggestionView {
    
    struct Reusable : IReusable {
        
        typealias Owner = SuggestionView
        typealias Content = KKSuggestionView
        
        static func name(owner: Owner) -> String {
            return "SuggestionView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 56
            ))
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKSuggestionView : UICollectionView {
    
    weak var kkDelegate: KKSuggestionViewDelegate?
    
    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.init(frame: frame, collectionViewLayout: layout)
    }
            
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.contentInsetAdjustmentBehavior = .never
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = false
        self.backgroundColor = nil
        
        self.register(KKSuggestionDataCell.self, forCellWithReuseIdentifier: Self.suggestionCellIdentifier)
        self.register(KKSuggestionSeparatorCell.self, forCellWithReuseIdentifier: Self.separatorCellIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKSuggestionView {
    
    final func kk_update< Entity : KindSuggestion.IEntity, Formatter : KindCore.IFormatter >(view: SuggestionView< Entity, Formatter >) where Entity.Item == Formatter.Input, Formatter.Output == String {
        self.kk_update(frame: view.frame)
        self.kkDelegate = view
        self.kk_reload()
    }
    
    final func kk_cleanup() {
        self.kkDelegate = nil
    }
    
}

extension KKSuggestionView {
    
    final func kk_reload() {
        self.reloadData()
    }
    
}

extension KKSuggestionView {
    
    final class KKSuggestionDataCell : UICollectionViewCell {
        
        var kkTitle: UILabel
        
        override init(frame: CGRect) {
            self.kkTitle = UILabel(frame: .init(origin: .zero, size: frame.size))
            self.kkTitle.translatesAutoresizingMaskIntoConstraints = false
            self.kkTitle.font = UIFont.preferredFont(forTextStyle: .body)
            self.kkTitle.textColor = .label
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
        
        static func kk_size(available: CGSize, data: String) -> CGSize {
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
        
        func kk_highlight() {
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
        }
        
        func kk_unhighlight() {
            self.kkTitle.backgroundColor = .clear
        }
        
        func kk_apply(data: String) {
            self.kkTitle.text = data
        }
        
    }
    
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
        
        static func kk_size(available: CGSize) -> CGSize {
            return .init(
                width: 17,
                height: available.height
            )
        }
        
    }
    
}

extension KKSuggestionView {
    
    static let suggestionCellIdentifier = "Suggestion"
    static let separatorCellIdentifier = "Separator"
    
}

extension KKSuggestionView : UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didHighlightItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if let cell = cell as? KKSuggestionDataCell {
            cell.kk_highlight()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didUnhighlightItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if let cell = cell as? KKSuggestionDataCell {
            cell.kk_unhighlight()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let delegate = self.kkDelegate {
            let isOdd = (indexPath.item % 2 == 0)
            if isOdd == true {
                let index = indexPath.item / 2
                delegate.kk_changed(selectedIndex: index)
            }
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension KKSuggestionView : UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let delegate = self.kkDelegate else { return 0 }
        let count = delegate.kk_count()
        if count > 1 {
            return (count * 2) - 1
        }
        return count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        let isOdd = (indexPath.item % 2 == 0)
        if isOdd == true {
            let index = indexPath.item / 2
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.suggestionCellIdentifier, for: indexPath)
            if let cell = cell as? KKSuggestionDataCell {
                cell.kk_apply(data: self.kkDelegate?.kk_string(at: index) ?? "")
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.separatorCellIdentifier, for: indexPath)
        }
        return cell
    }
    
}

extension KKSuggestionView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let bounds = collectionView.bounds
        let size: CGSize
        let isOdd = (indexPath.item % 2 == 0)
        if isOdd == true {
            let index = indexPath.item / 2
            size = KKSuggestionDataCell.kk_size(
                available: bounds.size,
                data: self.kkDelegate?.kk_string(at: index) ?? ""
            )
        } else {
            size = KKSuggestionSeparatorCell.kk_size(
                available: bounds.size
            )
        }
        return size
    }
    
}

#endif
