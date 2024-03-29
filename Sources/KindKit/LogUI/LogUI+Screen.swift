//
//  KindKit
//

import Foundation

extension LogUI {
    
    final class Screen : IScreen, IScreenStackable, IScreenViewable {
        
        
        let target: LogUI.Target
        
        var container: IUIContainer?
        
        private(set) lazy var stackBar = UI.View.StackBar()
            .inset(.init(horizontal: 12, vertical: 8))
            .leadings([ self._autoScrollButton ])
            .leadingsSpacing(4)
#if os(iOS)
            .center(
                UI.View.Custom()
                    .content(.composition(
                        entity: .bubble(
                            content: .margin(
                                inset: .init(horizontal: 2, vertical: 2),
                                entity: .view(self._searchInput)
                            ),
                            bubble: .view(self._searchBorder)
                        )
                    ))
            )
            .centerSpacing(8)
#endif
            .trailings([ self._closeButton ])
            .trailingsSpacing(4)
            .color(.white)
        
        private(set) lazy var layout = UI.Layout.List()
        
        private(set) lazy var view = UI.View.Scroll()
            .content(self.layout)
            .direction(.vertical)
            .indicatorDirection(.vertical)
            .color(.white)
        
#if os(iOS)
        
        private(set) lazy var _searchBorder = UI.View.Rect()
            .border(.manual(width: 1, color: .platinum))
            .cornerRadius(.manual(radius: 4))
            .fill(.white)
        
        private(set) lazy var _searchInput = UI.View.Input.String()
            .height(.fixed(44))
            .textFont(.init(weight: .regular, size: 16))
            .textColor(.black)
            .textInset(.init(horizontal: 12, vertical: 4))
            .editingColor(.black)
            .placeholder("Enter filter")
            .placeholderFont(.init(weight: .regular, size: 16))
            .placeholderColor(.platinum)
            .keyboard(.init(
                returnKey: .search,
                enablesReturnKeyAutomatically: false
            ))
        
#endif
        
        private(set) lazy var _autoScrollButton = UI.View.Button()
            .inset(.init(horizontal: 12, vertical: 4))
            .height(.fixed(44))
            .background(
                UI.View.Rect()
                    .color(.white)
                    .fill(.glaucous)
                    .cornerRadius(.manual(radius: 4))
            )
            .primary(
                UI.View.Text()
                    .text("▼")
                    .textFont(.init(weight: .regular, size: 20))
                    .textColor(.white)
            )
            .isSelected(true)
        
        
        private(set) lazy var _closeButton = UI.View.Button()
            .inset(.init(horizontal: 12, vertical: 4))
            .height(.fixed(44))
            .background(
                UI.View.Rect()
                    .color(.white)
                    .fill(.glaucous)
                    .cornerRadius(.manual(radius: 4))
            )
            .primary(
                UI.View.Text()
                    .text("✕")
                    .textFont(.init(weight: .regular, size: 20))
                    .textColor(.white)
            )
        
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
#if os(iOS)
            self._searchInput.onPressedReturn(self, {
                $0._searchInput.endEditing()
                $0._search = $0._searchInput.value
                $0._reload()
            })
#endif
            self._autoScrollButton.onStyle(self, {
                guard let background = $0._autoScrollButton.background as? UI.View.Rect else { return }
                guard let primary = $0._autoScrollButton.primary as? UI.View.Text else { return }
                if $0._autoScrollButton.isSelected == true {
                    background.fill = .glaucous
                    primary.textColor = .white
                } else {
                    background.fill = .platinum
                    primary.textColor = .black
                }
            }).onPressed(self, {
                $0._autoScrollButton.isSelected = !$0._autoScrollButton.isSelected
                $0._scrollToBottom()
            })
            self._closeButton.onPressed(self, {
#if os(iOS)
                if $0._searchInput.isEditing == true {
                    $0._searchInput.endEditing()
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
        
        func snake() -> Bool {
            return true
        }
        
        func apply(inset: UI.Container.AccumulateInset) {
            self.view.contentInset = inset.natural
            self._scrollToBottom()
        }
        
        func finishShow(interactive: Bool) {
            self._reload()
        }
        
    }
    
}

private extension LogUI.Screen {
    
    func _pressedClose() {
        self.close()
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
        self._entities = self._entities(self.target.messages.filter({ self._filter($0) }))
        self.layout.views = self._entities.map({ $0.cell })
        self.view.layoutIfNeeded()
        self._scrollToBottom()
    }
    
    func _filter(_ message: ILogMessage) -> Bool {
        guard let search = self._search?.lowercased() else { return true }
        if search.count > 0 {
            if message.category.lowercased().contains(search) == true {
                return true
            } else if message.string(options: .pretty).lowercased().contains(search) == true {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func _entities(_ messages: [ILogMessage]) -> [Entity] {
        return messages.map({ self._entity($0) })
    }
    
    func _entity(_ message: ILogMessage) -> Entity {
        return Entity(message: message, cell: self._cell(message))
    }
    
    func _cell(_ message: ILogMessage) -> UI.View.Cell {
        return UI.View.Cell()
            .background(
                UI.View.Color()
                    .color(.white)
            )
            .content(
                UI.View.Custom().content(
                    .composition(
                        inset: .init(horizontal: 12, vertical: 8),
                        entity: .hAccessory(
                            leading: .view(
                                UI.View.Rect()
                                    .width(.fixed(4))
                                    .cornerRadius(.auto)
                                    .fill(self._color(message))
                                    .color(.white)
                            ),
                            center: .margin(
                                inset: .init(top: 0, left: 8, right: 0, bottom: 0),
                                entity: .vStack(
                                    alignment: .fill,
                                    spacing: 4,
                                    entities: [
                                        .view(
                                            UI.View.Text()
                                                .color(.white)
                                                .text(message.category)
                                                .textFont(.init(weight: .semibold, size: 16))
                                        ),
                                        .view(
                                            UI.View.Text()
                                                .color(.white)
                                                .text(message.string(options: .pretty))
                                                .textFont(.init(weight: .regular, size: 14))
                                        )
                                    ]
                                )
                            )
                        )
                    )
                )
            )
    }
    
    func _color(_ message: ILogMessage) -> UI.Color {
        switch message.level {
        case .debug: return .gray
        case .info: return .yellow
        case .error: return .red
        }
    }
    
}

extension LogUI.Screen : ILogUITargetObserver {
    
    func append(_ target: LogUI.Target, message: ILogMessage) {
        let entity = self._entity(message)
        self._entities.append(entity)
        if self._filter(entity.message) == true {
            self.layout.insert(
                index: self.layout.views.count,
                views: [ entity.cell ]
            )
            self.view.layoutIfNeeded()
            self._scrollToBottom()
        }
    }
    
    func remove(_ target: LogUI.Target, message: ILogMessage) {
        guard let index = self._entities.firstIndex(where: { $0.message.id == message.id }) else { return }
        let entity = self._entities.remove(at: index)
        self.layout.delete(views: [ entity.cell ])
        self.view.layoutIfNeeded()
        self._scrollToBottom()
    }
    
}
