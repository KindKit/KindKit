//
//  KindKit
//

import Foundation

extension LogUI {
    
    final class Screen : IUIScreen, IUIScreenStackable, IUIScreenViewable {
        
        let target: LogUI.Target
        var onClose: (() -> Void)?
        
        var container: IUIContainer?
        
        private(set) lazy var stackBarView = UI.View.StackBar()
            .inset(Inset(horizontal: 12, vertical: 8))
            .leadingViews([ self._autoScrollButton ])
            .leadingViewSpacing(4)
#if os(iOS)
            .centerView(self._searchView)
            .centerSpacing(8)
#endif
            .trailingViews([ self._closeButton ])
            .trailingViewSpacing(4)
            .color(Color(rgb: 0xffffff))
        
        private(set) lazy var layout = UI.Layout.List(direction: .vertical)
        
        private(set) lazy var view = UI.View.Scroll(self.layout)
            .direction(.vertical)
            .indicatorDirection(.vertical)
            .color(Color(rgb: 0xffffff))
            .onBeginScrolling({ [unowned self] _ in
                self._autoScrollButton.isSelected = false
            })
        
#if os(iOS)
        
        private(set) lazy var _searchView = UI.View.Input.String()
            .height(.fixed(44))
            .textFont(Font(weight: .regular, size: 16))
            .textColor(Color(rgb: 0x000000))
            .textInset(InsetFloat(horizontal: 12, vertical: 4))
            .editingColor(Color(rgb: 0x000000))
            .placeholder(UI.View.Input.Placeholder(
                text: "Enter filter",
                font: Font(weight: .regular, size: 16),
                color: Color(rgb: 0xA9AEBA)
            ))
            .color(Color(rgb: 0xffffff))
            .border(.manual(width: 1, color: Color(rgb: 0xA9AEBA)))
            .cornerRadius(.manual(radius: 4))
            .onPressedReturn({ [unowned self] in
                $0.endEditing()
                self._search = $0.text
                self._reload()
            })
        
#endif
        
        private(set) lazy var _autoScrollButton = UI.View.Button()
            .inset(.init(horizontal: 12, vertical: 4))
            .height(.static(.fixed(44)))
            .backgroundView(UI.View.Empty()
                .color(.init(rgb: 0xFFCF38))
                .cornerRadius(.manual(radius: 4)))
            .primaryView(UI.View.Text("▼")
                .textFont(.init(weight: .regular, size: 20))
                .textColor(.init(rgb: 0x000000)))
            .select(true)
            .onChangeStyle({ button, _ in
                guard let backgroundView = button.backgroundView as? IUIViewColorable else { return }
                if button.isSelected == true {
                    backgroundView.color = Color(rgb: 0xFFCF38)
                } else {
                    backgroundView.color = Color(rgb: 0xA9AEBA)
                }
            })
            .onPressed({ [unowned self] in
                $0.isSelected = !$0.isSelected
                self._scrollToBottom()
            })
        
        private(set) lazy var _closeButton = UI.View.Button()
            .inset(.init(horizontal: 12, vertical: 4))
            .height(.static(.fixed(44)))
            .backgroundView(UI.View.Empty()
                .color(.init(rgb: 0xA9AEBA))
                .cornerRadius(.manual(radius: 4)))
            .primaryView(UI.View.Text("✕")
                .textFont(.init(weight: .regular, size: 20))
                .textColor(.init(rgb: 0x000000)))
            .onPressed({ [unowned self] _ in
#if os(iOS)
                if self._searchView.isEditing == true {
                    self._searchView.endEditing()
                } else {
                    self._pressedClose()
                }
#else
                self._pressedClose()
#endif
            })
        
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
        let cell: UI.View.Cell
        
    }
    
}

private extension LogUI.Screen {
    
    func _pressedClose() {
        self.onClose?()
    }
    
    func _scrollToBottom() {
        guard self._autoScrollButton.isSelected == true else { return }
        guard let view = self.layout.views.last else { return }
        guard let contentOffset = self.view.contentOffset(with: view, horizontal: .leading, vertical: .trailing) else { return }
        self.view.contentOffset = contentOffset
    }
    
}

private extension LogUI.Screen {
    
    func _reload() {
        self._entities = self._entities(self.target.items.filter({ self._filter($0) }))
        self.layout.views = self._entities.compactMap({ $0.cell })
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
    
    func _cell(_ item: LogUI.Target.Item) -> UI.View.Cell {
        return UI.View.Cell(
            customView: .composition(
                inset: .init(horizontal: 12, vertical: 8),
                entity: .hAccessory(
                    leading: .view(
                        UI.View.Empty()
                            .width(.fixed(4))
                            .color(self._color(item))
                            .cornerRadius(.auto)
                    ),
                    center: .margin(
                        inset: .init(top: 0, left: 8, right: 0, bottom: 0),
                        entity: .vStack(
                            alignment: .fill,
                            spacing: 4,
                            entities: [
                                .view(
                                    UI.View.Text(item.category)
                                        .textFont(Font(weight: .regular, size: 16))
                                        .textColor(Color(rgb: 0x000000))
                                ),
                                .view(
                                    UI.View.Text(item.message)
                                        .textFont(Font(weight: .regular, size: 14))
                                        .textColor(Color(rgb: 0x000000))
                                )
                            ]
                        )
                    ),
                    filling: true
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
            self.layout.insert(
                index: self.layout.items.count - 1,
                views: [ entity.cell ]
            )
            self.view.layoutIfNeeded()
            self._scrollToBottom()
        }
    }
    
    func remove(_ target: LogUI.Target, item: LogUI.Target.Item) {
        guard let index = self._entities.firstIndex(where: { $0.item == item }) else { return }
        let entity = self._entities.remove(at: index)
        self.layout.delete(views: [ entity.cell ])
        self.view.layoutIfNeeded()
        self._scrollToBottom()
    }
    
}
