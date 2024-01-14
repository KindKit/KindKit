//
//  KindKit-Test
//

import XCTest
import KindMarkdown

class TestBase : XCTestCase {
    
    func testTrim() {
        let parsed = Parser.blocks(" \n\t A B \n C \n\n")
        let expected: [Block] = [
            .paragraph(content: .text([
                .plain(text: "A B\nC")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockCode1() {
        let parsed = Parser.blocks(
            """
            $ Code 1
            """
        )
        let expected: [Block] = [
            .code(level: 1, content: .text([
                .plain(text: "Code 1")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockCode2() {
        let parsed = Parser.blocks(
            """
            $ Code 1
            $$ Code 2
            """
        )
        let expected: [Block] = [
            .code(level: 1, content: .text([
                .plain(text: "Code 1")
            ])),
            .code(level: 2, content: .text([
                .plain(text: "Code 2")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockHeading1() {
        let parsed = Parser.blocks(
            """
            # Heading 1
            """
        )
        let expected: [Block] = [
            .heading(level: 1, content: .text([
                .plain(text: "Heading 1")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockHeading2() {
        let parsed = Parser.blocks(
            """
            # Heading 1
            ## Heading 2
            """
        )
        let expected: [Block] = [
            .heading(level: 1, content: .text([
                .plain(text: "Heading 1")
            ])),
            .heading(level: 2, content: .text([
                .plain(text: "Heading 2")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockList1() {
        let parsed = Parser.blocks(
            """
            [ 1 ] List 1
            """
        )
        let expected: [Block] = [
            .list(
                marker: .text([
                    .plain(text: "1")
                ]),
                content: .text([
                    .plain(text: "List 1")
                ])
            )
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockList2() {
        let parsed = Parser.blocks(
            """
            [1] List 1
            [ 2 ] List 2
            """
        )
        let expected: [Block] = [
            .list(
                marker: .text([
                    .plain(text: "1")
                ]),
                content: .text([
                    .plain(text: "List 1")
                ])
            ),
            .list(
                marker: .text([
                    .plain(text: "2")
                ]),
                content: .text([
                    .plain(text: "List 2")
                ])
            )
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockParagraph1() {
        let parsed = Parser.blocks(
            """
            Paragraph
            1
            """
        )
        let expected: [Block] = [
            .paragraph(content: .text([
                .plain(text: "Paragraph\n1")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockParagraph2() {
        let parsed = Parser.blocks(
            """
            Paragraph 1
            
            Paragraph 2
            """
        )
        let expected: [Block] = [
            .paragraph(content: .text([
                .plain(text: "Paragraph 1")
            ])),
            .paragraph(content: .text([
                .plain(text: "Paragraph 2")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockQuote1() {
        let parsed = Parser.blocks(
            """
            > Quote 1
            """
        )
        let expected: [Block] = [
            .quote(level: 1, content: .text([
                .plain(text: "Quote 1")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testBlockQuote2() {
        let parsed = Parser.blocks(
            """
            > Quote 1
            >> Quote 2
            """
        )
        let expected: [Block] = [
            .quote(level: 1, content: .text([
                .plain(text: "Quote 1")
            ])),
            .quote(level: 2, content: .text([
                .plain(text: "Quote 2")
            ]))
        ]
        XCTAssert(parsed == expected)
    }
    
    func testText() {
        let parsed = Parser.text("text")
        let expected: Text = .text([
            .plain(text: "text")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextItalic1() {
        let parsed = Parser.text("//text//")
        let expected: Text = .text([
            .plain(options: .italic, text: "text")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextItalic2() {
        let parsed = Parser.text("pre //text// suf")
        let expected: Text = .text([
            .plain(text: "pre "),
            .plain(options: .italic, text: "text"),
            .plain(text: " suf")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextBold1() {
        let parsed = Parser.text("**text**")
        let expected: Text = .text([
            .plain(options: .bold, text: "text")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextBold2() {
        let parsed = Parser.text("pre **text** suf")
        let expected: Text = .text([
            .plain(text: "pre "),
            .plain(options: .bold, text: "text"),
            .plain(text: " suf")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextUnderline1() {
        let parsed = Parser.text("__text__")
        let expected: Text = .text([
            .plain(options: .underline, text: "text")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextUnderline2() {
        let parsed = Parser.text("pre __text__ suf")
        let expected: Text = .text([
            .plain(text: "pre "),
            .plain(options: .underline, text: "text"),
            .plain(text: " suf")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextStrikethrough1() {
        let parsed = Parser.text("--text--")
        let expected: Text = .text([
            .plain(options: .strikethrough, text: "text")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextStrikethrough2() {
        let parsed = Parser.text("pre --text-- suf")
        let expected: Text = .text([
            .plain(text: "pre "),
            .plain(options: .strikethrough, text: "text"),
            .plain(text: " suf")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextLink1() {
        let parsed = Parser.text("[title](url)")
        let expected: Text = .text([
            .link(
                text: .text([
                    .plain(text: "title")
                ]),
                url: URL(string: "url")
            )
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextLink2() {
        let parsed = Parser.text("pre [title](url) suf")
        let expected: Text = .text([
            .plain(text: "pre "),
            .link(
                text: .text([
                    .plain(text: "title")
                ]),
                url: URL(string: "url")
            ),
            .plain(text: " suf")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextAll1() {
        let parsed = Parser.text("__--**//text//**--__")
        let expected: Text = .text([
            .plain(
                options: [ .strikethrough, .underline, .bold, .italic ],
                text: "text"
            )
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextAll2() {
        let parsed = Parser.text("pre __--**//text//**--__ suf")
        let expected: Text = .text([
            .plain(text: "pre "),
            .plain(
                options: [ .strikethrough, .underline, .bold, .italic ],
                text: "text"
            ),
            .plain(text: " suf")
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextAll3() {
        let parsed = Parser.text("__--**//[title](url)//**--__")
        let expected: Text = .text([
            .link(
                text: .text([
                    .plain(
                        options: [ .strikethrough, .underline, .bold, .italic ],
                        text: "title"
                    )
                ]),
                url: URL(string: "url")
            )
            
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextOverlay1() {
        let parsed = Parser.text("__--**//1__ 2-- 3** 4// 5")
        let expected: Text = .text([
            .plain(
                options: [ .strikethrough, .underline, .bold, .italic ],
                text: "1"
            ),
            .plain(
                options: [ .strikethrough, .bold, .italic ],
                text: " 2"
            ),
            .plain(
                options: [ .bold, .italic ],
                text: " 3"
            ),
            .plain(
                options: [ .italic ],
                text: " 4"
            ),
            .plain(
                text: " 5"
            )
        ])
        XCTAssert(parsed == expected)
    }
    
    func testTextOverlay2() {
        let parsed = Parser.text("__--**//[1__ 2](url)-- 3** 4// 5")
        let expected: Text = .text([
            .link(
                text: .text([
                    .plain(
                        options: [ .strikethrough, .underline, .bold, .italic ],
                        text: "1"
                    ),
                    .plain(
                        options: [ .strikethrough, .bold, .italic ],
                        text: " 2"
                    )
                ]),
                url: URL(string: "url")
            ),
            .plain(
                options: [ .bold, .italic ],
                text: " 3"
            ),
            .plain(
                options: [ .italic ],
                text: " 4"
            ),
            .plain(
                text: " 5"
            )
        ])
        XCTAssert(parsed == expected)
    }
    
}
