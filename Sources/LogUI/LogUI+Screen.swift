//
//  KindKitLogUI
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

extension LogUI {
    
    final class Screen : IScreen, IScreenStackable, IScreenViewable {
        
        let target: LogUI.Target
        var onClose: (() -> Void)?
        
        var container: IContainer?
        
        private(set) lazy var stackBarView = StackBarView(
            inset: InsetFloat(horizontal: 12, vertical: 8),
            leadingViews: [
                self._autoScrollButton
            ],
            leadingViewSpacing: 4,
            centerView: self._searchView,
            centerSpacing: 8,
            trailingViews: [
                self._closeButton
            ],
            trailingViewSpacing: 4,
            color: Color(rgb: 0xffffff)
        )
        private(set) lazy var view: ScrollView< ListLayout > = {
            let view = ScrollView(
                direction: [ .vertical ],
                indicatorDirection: [ .vertical ],
                contentLayout: ListLayout(
                    direction: .vertical
                ),
                color: Color(rgb: 0xffffff)
            )
            view.onBeginScrolling({ [unowned self] in
                self._autoScrollButton.isSelected = false
            })
            return view
        }()
        private(set) lazy var _searchView: InputStringView = {
            let inputView = InputStringView(
                width: .fill,
                height: .fixed(44),
                text: "",
                textFont: Font(weight: .regular, size: 16),
                textColor: Color(rgb: 0x000000),
                textInset: InsetFloat(horizontal: 12, vertical: 4),
                editingColor: Color(rgb: 0x000000),
                placeholder: InputPlaceholder(
                    text: "Enter filter",
                    font: Font(weight: .regular, size: 16),
                    color: Color(rgb: 0xA9AEBA)
                ),
                alignment: .left,
                color: Color(rgb: 0xffffff),
                border: .manual(width: 1, color: Color(rgb: 0xA9AEBA)),
                cornerRadius: .manual(radius: 4)
            ).keyboard(InputKeyboard(
                type: .default,
                appearance: .default,
                autocapitalization: .none,
                autocorrection: .no,
                spellChecking: .no,
                returnKey: .search,
                enablesReturnKeyAutomatically: false
            ))
            inputView.onPressedReturn({ [unowned self, unowned inputView] in
                inputView.endEditing()
                self._search = inputView.text
                self._reload()
            })
            return inputView
        }()
        private(set) lazy var _autoScrollButton: ButtonView = {
            let backgroundView = EmptyView(
                width: .fill,
                height: .fill,
                color: Color(rgb: 0xFFCF38),
                cornerRadius: .manual(radius: 4)
            )
            let textView = TextView(
                text: "▼",
                textFont: Font(weight: .regular, size: 20),
                textColor: Color(rgb: 0x000000)
            )
            let button = ButtonView(
                inset: InsetFloat(horizontal: 12, vertical: 4),
                height: .static(.fixed(44)),
                backgroundView: backgroundView,
                primaryView: textView,
                isSelected: true
            )
            button.onChangeStyle({ [unowned button, unowned backgroundView] _ in
                if button.isSelected == true {
                    backgroundView.color = Color(rgb: 0xFFCF38)
                } else {
                    backgroundView.color = Color(rgb: 0xA9AEBA)
                }
            })
            button.onPressed({ [unowned self, unowned button] in
                button.isSelected = !button.isSelected
                self._scrollToBottom()
            })
            return button
        }()
        private(set) lazy var _closeButton: ButtonView = {
            let backgroundView = EmptyView(
                width: .fill,
                height: .fill,
                color: Color(rgb: 0xA9AEBA),
                cornerRadius: .manual(radius: 4)
            )
            let textView = TextView(
                text: "✕",
                textFont: Font(weight: .regular, size: 20),
                textColor: Color(rgb: 0x000000)
            )
            let button = ButtonView(
                inset: InsetFloat(horizontal: 12, vertical: 4),
                height: .static(.fixed(44)),
                backgroundView: backgroundView,
                primaryView: textView
            )
            button.onPressed({ [unowned self] in
                if self._searchView.isEditing == true {
                    self._searchView.endEditing()
                } else {
                    self._pressedClose()
                }
            })
            return button
        }()
        private var _entities: [Entity]
        private var _search: String?
        
        init(
            target: LogUI.Target
        ) {
            self.target = target
            self._entities = []
        }
        
        func setup() {
            self.target.add(observer: self, priority: .public)
        }
        
        func destroy() {
            self.target.remove(observer: self)
        }
        
        func didChangeInsets() {
            let inheritedInsets = self.inheritedInsets()
            self.view.contentInset = inheritedInsets
            self._scrollToBottom()
        }
        
        func finishShow(interactive: Bool) {
            self._reload()
        }

    }
    
}

private extension LogUI.Screen {
    
    struct Entity {
        
        let item: LogUI.Target.Item
        let cell: ICellView
        
    }
    
}

private extension LogUI.Screen {
    
    func _pressedClose() {
        self.onClose?()
    }
    
    func _scrollToBottom() {
        guard self._autoScrollButton.isSelected == true else { return }
        guard let view = self.view.contentLayout.views.last else { return }
        guard let contentOffset = self.view.contentOffset(with: view, horizontal: .leading, vertical: .trailing) else { return }
        self.view.contentOffset = contentOffset
    }
    
}

private extension LogUI.Screen {
    
    func _reload() {
        self._entities = self._entities(self.target.items.filter({ self._filter($0) }))
        self.view.contentLayout.views = self._entities.compactMap({ $0.cell })
        self.view.layoutIfNeeded()
        self._scrollToBottom()
    }
    
    func _filter(_ item: LogUI.Target.Item) -> Bool {
        guard let search = self._search?.lowercased() else { return true }
        if search.count > 0 {
            if item.category.lowercased().contains(search) == true {
                return true
            } else if item.message.lowercased().contains(search) == true {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func _entities(_ items: [LogUI.Target.Item]) -> [Entity] {
        return items.compactMap({ self._entity($0) })
    }
    
    func _entity(_ item: LogUI.Target.Item) -> Entity {
        return Entity(item: item, cell: self._cell(item))
    }
    
    func _cell(_ item: LogUI.Target.Item) -> ICellView {
        return CellView(
            contentView: CustomView(
                contentLayout: CompositionLayout(
                    inset: InsetFloat(horizontal: 12, vertical: 8),
                    entity: CompositionLayout.HAccessory(
                        leading: CompositionLayout.View(EmptyView(
                            width: .fixed(4),
                            height: .fill,
                            color: self._color(item),
                            cornerRadius: .auto
                        )),
                        center: CompositionLayout.Margin(
                            inset: InsetFloat.init(top: 0, left: 8, right: 0, bottom: 0),
                            entity: CompositionLayout.VStack(
                                alignment: .fill,
                                spacing: 4,
                                entities: [
                                    CompositionLayout.View(TextView(
                                        text: item.category,
                                        textFont: Font(weight: .regular, size: 16),
                                        textColor: Color(rgb: 0x000000)
                                    )),
                                    CompositionLayout.View(TextView(
                                        text: item.message,
                                        textFont: Font(weight: .regular, size: 14),
                                        textColor: Color(rgb: 0x000000)
                                    ))
                                ]
                            )
                        ),
                        filling: true
                    )
                )
            )
        )
    }
    
    func _color(_ item: LogUI.Target.Item) -> Color {
        switch item.level {
        case .debug: return Color(rgb: 0x808080)
        case .info: return Color(rgb: 0xffff00)
        case .error: return Color(rgb: 0xff0000)
        }
    }
    
}

extension LogUI.Screen : ILogUITargetObserver {
    
    func append(_ target: LogUI.Target, item: LogUI.Target.Item) {
        let entity = self._entity(item)
        self._entities.append(entity)
        if self._filter(entity.item) == true {
            self.view.contentLayout.insert(
                index: self.view.contentLayout.items.count - 1,
                views: [ entity.cell ]
            )
            self.view.layoutIfNeeded()
            self._scrollToBottom()
        }
    }
    
    func remove(_ target: LogUI.Target, item: LogUI.Target.Item) {
        guard let index = self._entities.firstIndex(where: { $0.item == item }) else { return }
        let entity = self._entities.remove(at: index)
        self.view.contentLayout.delete(views: [ entity.cell ])
        self.view.layoutIfNeeded()
        self._scrollToBottom()
    }

}
