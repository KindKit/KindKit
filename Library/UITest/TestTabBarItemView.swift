//
//  KindKit-Test
//

import XCTest
import KindUI

class TestTabBarItemView : XCTestCase {
    
    func testIcon() {
        let view = PressView(
            content: TabBarItemTemplate.Icon(
                icon: RectView(.clear)
                    .cornerRadius(.auto)
                    .width(.fixed(32))
                    .height(.fixed(32))
            ),
            styleSheet: .init(
                unselected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .blue
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .brightBlue
                        )
                    )
                ),
                selected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .red
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .venetianRed
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            XCTAssert(
                view: view,
                name: "TabBarItem/Icon",
                state: "Normal"
            )
        }
        do {
            view.isHighlighted = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/Icon",
                state: "Normal+Highlighted"
            )
        }
        do {
            view.isHighlighted = false
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/Icon",
                state: "Selected"
            )
        }
        do {
            view.isHighlighted = true
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/Icon",
                state: "Selected+Highlighted"
            )
        }
    }
    
    func testIconBadge() {
        let view = PressView(
            content: TabBarItemTemplate.IconBadge(
                inset: .init(horizontal: 20, vertical: 20),
                icon: RectView(.clear)
                    .cornerRadius(.auto)
                    .width(.fixed(32))
                    .height(.fixed(32)),
                badgeSubstrate: RectView(.white).cornerRadius(.auto),
                badge: TextView({
                    LettersComponent("1")
                })
            ),
            styleSheet: .init(
                unselected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .blue
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.blue)
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .brightBlue
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.brightBlue)
                        )
                    )
                ),
                selected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .red
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.red)
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .venetianRed
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.venetianRed)
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            XCTAssert(
                view: view,
                name: "TabBarItem/IconBadge",
                state: "Normal"
            )
        }
        do {
            view.isHighlighted = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconBadge",
                state: "Normal+Highlighted"
            )
        }
        do {
            view.isHighlighted = false
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconBadge",
                state: "Selected"
            )
        }
        do {
            view.isHighlighted = true
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconBadge",
                state: "Selected+Highlighted"
            )
        }
    }
    
    func testIconTitle() {
        let view = PressView(
            content: TabBarItemTemplate.IconTitle(
                icon: RectView(.clear)
                    .cornerRadius(.auto)
                    .width(.fixed(32))
                    .height(.fixed(32)),
                title: TextView({
                    LettersComponent("title")
                })
            ),
            styleSheet: .init(
                unselected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .blue
                        ),
                        title: .init(
                            style: .init().fontColor(.blue)
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .brightBlue
                        ),
                        title: .init(
                            style: .init().fontColor(.brightBlue)
                        )
                    )
                ),
                selected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .red
                        ),
                        title: .init(
                            style: .init().fontColor(.red)
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .venetianRed
                        ),
                        title: .init(
                            style: .init().fontColor(.venetianRed)
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitle",
                state: "Normal"
            )
        }
        do {
            view.isHighlighted = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitle",
                state: "Normal+Highlighted"
            )
        }
        do {
            view.isHighlighted = false
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitle",
                state: "Selected"
            )
        }
        do {
            view.isHighlighted = true
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitle",
                state: "Selected+Highlighted"
            )
        }
    }
    
    func testIconTitleBadge() {
        let view = PressView(
            content: TabBarItemTemplate.IconTitleBadge(
                inset: .init(horizontal: 20, vertical: 20),
                icon: RectView(.clear)
                    .cornerRadius(.auto)
                    .width(.fixed(32))
                    .height(.fixed(32)),
                title: TextView({
                    LettersComponent("title")
                }),
                badgeSubstrate: RectView(.white).cornerRadius(.auto),
                badge: TextView({
                    LettersComponent("1")
                })
            ),
            styleSheet: .init(
                unselected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .blue
                        ),
                        title: .init(
                            style: .init().fontColor(.blue)
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.blue)
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .brightBlue
                        ),
                        title: .init(
                            style: .init().fontColor(.brightBlue)
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.brightBlue)
                        )
                    )
                ),
                selected: .init(
                    normal: .init(
                        icon: .init(
                            fill: .red
                        ),
                        title: .init(
                            style: .init().fontColor(.red)
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.red)
                        )
                    ),
                    highlighted: .init(
                        icon: .init(
                            fill: .venetianRed
                        ),
                        title: .init(
                            style: .init().fontColor(.venetianRed)
                        ),
                        badgeSubstrate: .init(),
                        badge: .init(
                            style: .init().fontColor(.venetianRed)
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitleBadge",
                state: "Normal"
            )
        }
        do {
            view.isHighlighted = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitleBadge",
                state: "Normal+Highlighted"
            )
        }
        do {
            view.isHighlighted = false
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitleBadge",
                state: "Selected"
            )
        }
        do {
            view.isHighlighted = true
            view.isSelected = true
            
            XCTAssert(
                view: view,
                name: "TabBarItem/IconTitleBadge",
                state: "Selected+Highlighted"
            )
        }
    }
    
}
