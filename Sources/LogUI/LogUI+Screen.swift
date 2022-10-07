//
//  KindKit
//

import Foundation

extension LogUI {
    
    final class Screen : IUIScreen, IUIScreenStackable, IUIScreenViewable {
        
        let target: LogUI.Target
        var onClose: (() -> Void)?
        
        var container: IUIContainer?
        
        private(set) lazy var stackBar = UI.View.StackBar(configure: {
            $0.inset = .init(horizontal: 12, vertical: 8)
            $0.leadings = [ self._autoScrollButton ]
            $0.leadingsSpacing = 4
#if os(iOS)
            $0.center = self._searchView
            $0.centerSpacing = 8
#endif
            $0.trailings = [ self._closeButton ]
            $0.trailingsSpacing = 4
            $0.color = .clear
        })
        
        private(set) lazy var layout = UI.Layout.List(direction: .vertical)
        
        private(set) lazy var view = UI.View.Scroll(
            content: self.layout,
            configure: {
                $0.direction = .vertical
                $0.indicatorDirection = .vertical
                $0.color = .white
            }
        )
        
#if os(iOS)
        
        private(set) lazy var _searchView = UI.View.Input.String(configure: {
            $0.height = .fixed(44)
            $0.textFont = .init(weight: .regular, size: 16)
            $0.textColor = .black
            $0.textInset = .init(horizontal: 12, vertical: 4)
            $0.editingColor = .black
            $0.placeholder = .init(
                text: "Enter filter",
                font: .init(weight: .regular, size: 16),
                color: .platinum
            )
            $0.color = .white
            $0.border = .manual(width: 1, color: .platinum)
            $0.cornerRadius = .manual(radius: 4)
        })
        
#endif
        
        private(set) lazy var _autoScrollButton = UI.View.Button(configure: {
            $0.inset = .init(horizontal: 12, vertical: 4)
            $0.height = .fixed(44)
            $0.background = UI.View.Empty(configure: {
                $0.cornerRadius = .manual(radius: 4)
                $0.color = .glaucous
            })
            $0.primary = UI.View.Text(
                text: "▼",
                configure: {
                    $0.textFont = .init(weight: .regular, size: 20)
                    $0.textColor = .white
                }
            )
            $0.isSelected = true
        })
        
        private(set) lazy var _closeButton: UI.View.Button = {
            UI.View.Button(configure: {
                $0.inset = .init(horizontal: 12, vertical: 4)
                $0.height = .fixed(44)
                $0.background = UI.View.Empty(configure: {
                    $0.cornerRadius = .manual(radius: 4)
                    $0.color = .glaucous
                })
                $0.primary = UI.View.Text(
                    text: "✕",
                    configure: {
                        $0.textFont = .init(weight: .regular, size: 20)
                        $0.textColor = .white
                    }
                )
            })
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
            self.view.onBeginDragging(self, {
                $0._autoScrollButton.isSelected = false
            })
            self._searchView.onPressedReturn(self, {
                $0._searchView.endEditing()
                $0._search = $0._searchView.text
                $0._reload()
            })
            self._autoScrollButton.onChangeStyle(self, {
                guard let background = $0._autoScrollButton.background as? UI.View.Empty else { return }
                guard let primary = $0._autoScrollButton.primary as? UI.View.Text else { return }
                if $0._autoScrollButton.isSelected == true {
                    background.color = .glaucous
                    primary.textColor = .white
                } else {
                    background.color = .platinum
                    primary.textColor = .black
                }
            }).onPressed(self, {
                $0._autoScrollButton.isSelected = !$0._autoScrollButton.isSelected
                $0._scrollToBottom()
            })
            self._closeButton.onPressed(self, {
#if os(iOS)
                if $0._searchView.isEditing == true {
                    $0._searchView.endEditing()
                } else {
                    $0._pressedClose()
                }
#else
                $0._pressedClose()
#endif
            })
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
        self.layout.views = self._entities.map({ $0.cell })
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
        return items.map({ self._entity($0) })
    }
    
    func _entity(_ item: LogUI.Target.Item) -> Entity {
        return Entity(item: item, cell: self._cell(item))
    }
    
    func _cell(_ item: LogUI.Target.Item) -> UI.View.Cell {
        return UI.View.Cell(
            UI.View.Custom(.composition(
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
                                        .textFont(.init(weight: .regular, size: 16))
                                ),
                                .view(
                                    UI.View.Text(item.message)
                                        .textFont(.init(weight: .regular, size: 14))
                                )
                            ]
                        )
                    ),
                    filling: true
                )
            ))
        )
    }
    
    func _color(_ item: LogUI.Target.Item) -> UI.Color {
        switch item.level {
        case .debug: return .gray
        case .info: return .yellow
        case .error: return .red
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
