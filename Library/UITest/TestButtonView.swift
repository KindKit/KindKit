//
//  KindKit-Test
//

import XCTest
import KindUI

class TestButtonView : XCTestCase {
    
    func testIcon() {
        let view = PressView(
            content: ButtonTemplate.Icon(
                background: RectView(.clear)
                    .cornerRadius(.manual(radius: 4)),
                icon: RectView(.clear)
                    .cornerRadius(.auto)
                    .width(.fixed(32))
                    .height(.fixed(32))
            ),
            styleSheet: .init(
                enabled: .init(
                    unselected: .init(
                        normal: .init(
                            background: .init(
                                fill: .blue.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .blue.with(alpha: 0.9)
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .brightBlue.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .brightBlue.with(alpha: 0.9)
                            )
                        )
                    ),
                    selected: .init(
                        normal: .init(
                            background: .init(
                                fill: .red.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .red.with(alpha: 0.9)
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .venetianRed.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .venetianRed.with(alpha: 0.9)
                            )
                        )
                    )
                ),
                disabled: .init(
                    unselected: .init(
                        normal: .init(
                            background: .init(
                                fill: .blue.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .blue.with(alpha: 0.5)
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .brightBlue.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .brightBlue.with(alpha: 0.5)
                            )
                        )
                    ),
                    selected: .init(
                        normal: .init(
                            background: .init(
                                fill: .red.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .red.with(alpha: 0.5)
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .venetianRed.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .venetianRed.with(alpha: 0.5)
                            )
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            do {
                view.isEnabled = true
                view.isHighlighted = false
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Enabled+Unselected"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = true
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Enabled+Unselected+Highlighted"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = false
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Enabled+Selected"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = true
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Enabled+Selected+Highlighted"
                )
            }
        }
        do {
            do {
                view.isEnabled = false
                view.isHighlighted = false
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Disabled+Unselected"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = true
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Disabled+Unselected+Highlighted"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = false
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Disabled+Selected"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = true
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Icon",
                    state: "Disabled+Selected+Highlighted"
                )
            }
        }
    }
    
    func testTitle() {
        let titleStyle = KindText.Style()
            .fontSize(20)
        let view = PressView(
            content: ButtonTemplate.Title(
                background: RectView(.clear)
                    .cornerRadius(.manual(radius: 4)),
                title: TextView({
                    LettersComponent("Title")
                })
            ),
            styleSheet: .init(
                enabled: .init(
                    unselected: .init(
                        normal: .init(
                            background: .init(
                                fill: .blue.with(alpha: 0.8)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.blue.with(alpha: 0.9))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .brightBlue.with(alpha: 0.8)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.brightBlue.with(alpha: 0.9))
                            )
                        )
                    ),
                    selected: .init(
                        normal: .init(
                            background: .init(
                                fill: .red.with(alpha: 0.8)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.red.with(alpha: 0.9))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .venetianRed.with(alpha: 0.8)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.venetianRed.with(alpha: 0.9))
                            )
                        )
                    )
                ),
                disabled: .init(
                    unselected: .init(
                        normal: .init(
                            background: .init(
                                fill: .blue.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.blue.with(alpha: 0.5))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .brightBlue.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.brightBlue.with(alpha: 0.5))
                            )
                        )
                    ),
                    selected: .init(
                        normal: .init(
                            background: .init(
                                fill: .red.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.red.with(alpha: 0.5))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .venetianRed.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.venetianRed.with(alpha: 0.5))
                            )
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            do {
                view.isEnabled = true
                view.isHighlighted = false
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Enabled+Unselected"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = true
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Enabled+Unselected+Highlighted"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = false
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Enabled+Selected"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = true
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Enabled+Selected+Highlighted"
                )
            }
        }
        do {
            do {
                view.isEnabled = false
                view.isHighlighted = false
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Disabled+Unselected"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = true
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Disabled+Unselected+Highlighted"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = false
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Disabled+Selected"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = true
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/Title",
                    state: "Disabled+Selected+Highlighted"
                )
            }
        }
    }
    
    func testIconTitle() {
        let titleStyle = KindText.Style()
            .fontSize(20)
        let view = PressView(
            content: ButtonTemplate.IconTitle(
                background: RectView(.clear)
                    .cornerRadius(.manual(radius: 4)),
                icon: RectView(.clear)
                    .cornerRadius(.auto)
                    .width(.fixed(32))
                    .height(.fixed(32)),
                title: TextView({
                    LettersComponent("Title")
                })
            ),
            styleSheet: .init(
                enabled: .init(
                    unselected: .init(
                        normal: .init(
                            background: .init(
                                fill: .blue.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .blue.with(alpha: 0.9)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.blue.with(alpha: 0.9))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .brightBlue.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .brightBlue.with(alpha: 0.9)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.brightBlue.with(alpha: 0.9))
                            )
                        )
                    ),
                    selected: .init(
                        normal: .init(
                            background: .init(
                                fill: .red.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .red.with(alpha: 0.9)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.red.with(alpha: 0.9))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .venetianRed.with(alpha: 0.8)
                            ),
                            icon: .init(
                                fill: .venetianRed.with(alpha: 0.9)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.venetianRed.with(alpha: 0.9))
                            )
                        )
                    )
                ),
                disabled: .init(
                    unselected: .init(
                        normal: .init(
                            background: .init(
                                fill: .blue.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .blue.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.blue.with(alpha: 0.5))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .brightBlue.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .brightBlue.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.brightBlue.with(alpha: 0.5))
                            )
                        )
                    ),
                    selected: .init(
                        normal: .init(
                            background: .init(
                                fill: .red.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .red.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.red.with(alpha: 0.5))
                            )
                        ),
                        highlighted: .init(
                            background: .init(
                                fill: .venetianRed.with(alpha: 0.5)
                            ),
                            icon: .init(
                                fill: .venetianRed.with(alpha: 0.5)
                            ),
                            title: .init(
                                style: .init().inherit(titleStyle).fontColor(.venetianRed.with(alpha: 0.5))
                            )
                        )
                    )
                )
            )
        ).color(.white)
        
        do {
            do {
                view.isEnabled = true
                view.isHighlighted = false
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Enabled+Unselected"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = true
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Enabled+Unselected+Highlighted"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = false
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Enabled+Selected"
                )
            }
            do {
                view.isEnabled = true
                view.isHighlighted = true
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Enabled+Selected+Highlighted"
                )
            }
        }
        do {
            do {
                view.isEnabled = false
                view.isHighlighted = false
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Disabled+Unselected"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = true
                view.isSelected = false
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Disabled+Unselected+Highlighted"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = false
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Disabled+Selected"
                )
            }
            do {
                view.isEnabled = false
                view.isHighlighted = true
                view.isSelected = true
                
                XCTAssert(
                    view: view,
                    name: "Button/IconTitle",
                    state: "Disabled+Selected+Highlighted"
                )
            }
        }
    }
    
}
