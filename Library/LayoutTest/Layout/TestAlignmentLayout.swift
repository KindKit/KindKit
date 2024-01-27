//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestAlignmentLayout : XCTestCase {
    
    func testTopLeft() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .top
                $0.horizontal = .left
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 20, height: 20),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .top
                $0.horizontal = .left
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 20)
            ]
        )
    }
    
    func testTop() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .top
                $0.horizontal = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 20),
            frames: [
                .init(x: 40, y: 0, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .top
                $0.horizontal = .center
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 30, y: 0, width: 20, height: 20)
            ]
        )
    }
    
    func testTopRight() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .top
                $0.horizontal = .right
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 20),
            frames: [
                .init(x: 80, y: 0, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .top
                $0.horizontal = .right
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 60, y: 0, width: 20, height: 20)
            ]
        )
    }
    
    func testLeft() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .center
                $0.horizontal = .left
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 100),
            frames: [
                .init(x: 0, y: 40, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .center
                $0.horizontal = .left
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 0, y: 30, width: 20, height: 20)
            ]
        )
    }
    
    func testCenter() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .center
                $0.horizontal = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 100),
            frames: [
                .init(x: 40, y: 40, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .center
                $0.horizontal = .center
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 30, y: 30, width: 20, height: 20)
            ]
        )
    }
    
    func testRight() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .center
                $0.horizontal = .right
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 100),
            frames: [
                .init(x: 80, y: 40, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .center
                $0.horizontal = .right
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 60, y: 30, width: 20, height: 20)
            ]
        )
    }
    
    func testBottomLeft() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .bottom
                $0.horizontal = .left
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 100),
            frames: [
                .init(x: 0, y: 80, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .bottom
                $0.horizontal = .left
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 0, y: 60, width: 20, height: 20)
            ]
        )
    }
    
    func testBottom() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .bottom
                $0.horizontal = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 100),
            frames: [
                .init(x: 40, y: 80, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .bottom
                $0.horizontal = .center
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 30, y: 60, width: 20, height: 20)
            ]
        )
    }
    
    func testBottomRight() {
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .bottom
                $0.horizontal = .right
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 100),
            frames: [
                .init(x: 80, y: 80, width: 20, height: 20)
            ]
        )
        XCTAssert(
            layout: AlignmentLayout({
                StaticItem(width: .fixed(20), height: .fixed(20))
            }).update(on: {
                $0.vertical = .bottom
                $0.horizontal = .right
            }),
            available: .init(width: .fixed(80), height: .fixed(80)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 80),
            frames: [
                .init(x: 60, y: 60, width: 20, height: 20)
            ]
        )
    }
    
}
