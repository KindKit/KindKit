//
//  KindKit-Test
//

import XCTest
import KindLayout

func XCTAssert< LayoutType : ILayout >(
    layout : LayoutType,
    available: DynamicSize,
    bounds: Size,
    size: Size,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertPass(
        layout: layout,
        available: available,
        bounds: bounds,
        size: size,
        file: file,
        line: line
    )
    
    let holder = Holder()
    
    let manager = Manager< LayoutType >()
        .holder(holder)
        .available(available)
        .viewSize(bounds)
        .content(layout)
    
    XCTAssertPass(
        manager: manager,
        size: size,
        file: file,
        line: line
    )
    
    manager.content = nil
}

func XCTAssert< LayoutType : ILayout >(
    layout : LayoutType,
    available: DynamicSize,
    bounds: Size,
    size: Size,
    frames: [(origin: Point, frames: [Rect])],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertPass(
        layout: layout,
        available: available,
        bounds: bounds,
        size: size,
        file: file,
        line: line
    )
    
    let holder = Holder()
    
    let manager = Manager< LayoutType >()
        .holder(holder)
        .available(available)
        .viewSize(bounds)
        .content(layout)

    XCTAssertPass(
        manager: manager,
        size: size,
        file: file,
        line: line
    )
    
    XCTAssertPass(
        manager: manager,
        size: size,
        file: file,
        line: line
    )
    
    for info in frames {
        manager.viewOrigin(info.origin)
        
        XCTAssertPass(
            manager: manager,
            frames: info.frames,
            file: file,
            line: line
        )
    }
    
    manager.content = nil
}

func XCTAssert< LayoutType : ILayout >(
    layout : LayoutType,
    available: DynamicSize,
    bounds: Size,
    size: Size,
    frames: [Rect],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertPass(
        layout: layout,
        available: available,
        bounds: bounds,
        size: size,
        file: file,
        line: line
    )
    
    let holder = Holder()
    
    let manager = Manager< LayoutType >()
        .holder(holder)
        .available(available)
        .viewSize(bounds)
        .content(layout)
    
    XCTAssertPass(
        manager: manager,
        size: size,
        file: file,
        line: line
    )
    
    XCTAssertPass(
        manager: manager,
        frames: frames,
        file: file,
        line: line
    )
    
    manager.content = nil
}

func XCTAssertPass< LayoutType : ILayout >(
    layout : LayoutType,
    available: DynamicSize,
    bounds: Size,
    size expectSize: Size,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let selfSize = layout.sizeOf(.init(
        container: bounds,
        available: available.resolve(by: bounds)
    ))
    if selfSize !~ expectSize {
        let sString = "{ \(selfSize.width), \(selfSize.height) }"
        let eString = "{ \(expectSize.width), \(expectSize.height) }"
        XCTFail("Does not match sizes:\n\tLayout = { \(sString) }\n\tExpect = { \(eString) }", file: file, line: line)
    }
}

func XCTAssertPass< LayoutType : ILayout >(
    manager: Manager< LayoutType >,
    size expectSize: Size,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if manager.contentSize !~ expectSize {
        let cString = "{ \(manager.contentSize.width), \(manager.contentSize.height) }"
        let eString = "{ \(expectSize.width), \(expectSize.height) }"
        XCTFail("Does not match sizes:\n\tCurrent = { \(cString) }\n\tExpect = { \(eString) }", file: file, line: line)
    }
}

func XCTAssertPass< LayoutType : ILayout >(
    manager: Manager< LayoutType >,
    frames expectFrames: [Rect],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard expectFrames.count > 0 else { return }
    let managerFrames = manager.contentItems.map({ $0.frame })
    if managerFrames.count > expectFrames.count {
        for index in 0 ..< expectFrames.count {
            let cFrame = managerFrames[index]
            let eFrame = expectFrames[index]
            if cFrame !~ eFrame {
                let cString = "{ \(cFrame.x), \(cFrame.y) }, { \(cFrame.width), \(cFrame.height) }"
                let eString = "{ \(eFrame.x), \(eFrame.y) }, { \(eFrame.width), \(eFrame.height) }"
                XCTFail("Does not match:\n\tIndex = \(index)/\(managerFrames.count - 1)\n\tCurrent = { \(cString) }\n\tExpect = { \(eString) }", file: file, line: line)
            }
        }
        for index in expectFrames.count ..< managerFrames.count {
            let cFrame = managerFrames[index]
            let cString = "Origin = { \(cFrame.x), \(cFrame.y) }, Size = { \(cFrame.width), \(cFrame.height) }"
            XCTFail("Missing:\n\tCurrent = { \(cString) }", file: file, line: line)
        }
    } else if managerFrames.count < expectFrames.count {
        for index in 0 ..< managerFrames.count {
            let cFrame = managerFrames[index]
            let eFrame = expectFrames[index]
            if cFrame !~ eFrame {
                let cString = "{ \(cFrame.x), \(cFrame.y) }, { \(cFrame.width), \(cFrame.height) }"
                let eString = "{ \(eFrame.x), \(eFrame.y) }, { \(eFrame.width), \(eFrame.height) }"
                XCTFail("Does not match:\n\tIndex = \(index)/\(managerFrames.count - 1)\n\tCurrent = { \(cString) }\n\tExpect = { \(eString) }", file: file, line: line)
            }
        }
        for index in managerFrames.count ..< expectFrames.count {
            let eFrame = expectFrames[index]
            let eString = "Origin = { \(eFrame.x), \(eFrame.y) }, Size = { \(eFrame.width), \(eFrame.height) }"
            XCTFail("Missing:\n\tExpect = { \(eString) }", file: file, line: line)
        }
    } else {
        for index in 0 ..< managerFrames.count {
            let cFrame = managerFrames[index]
            let eFrame = expectFrames[index]
            if cFrame !~ eFrame {
                let cString = "{ \(cFrame.x), \(cFrame.y) }, { \(cFrame.width), \(cFrame.height) }"
                let eString = "{ \(eFrame.x), \(eFrame.y) }, { \(eFrame.width), \(eFrame.height) }"
                XCTFail("Does not match:\n\tIndex = \(index)/\(managerFrames.count - 1)\n\tCurrent = { \(cString) }\n\tExpect = { \(eString) }", file: file, line: line)
            }
        }
    }
}
