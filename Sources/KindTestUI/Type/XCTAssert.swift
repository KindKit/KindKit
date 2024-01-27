//
//  KindKit
//

import XCTest
import KindUI

public func XCTAssert(
    view: any IView,
    path: URL?,
    name: String,
    state: String,
    tolerance: CGFloat = 0.1,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let path = path else {
        XCTFail("Invalid base path", file: file, line: line)
        return
    }
    let currentImage = autoreleasepool(invoking: {
        CATransaction.kk_withoutActions({
            let wrapView = View(view: view)
            return wrapView.snapshot()
        })
    })
    guard let currentImage = currentImage else {
        XCTFail("Invalid creating snapshot for view '\(name)' in state \(state)", file: file, line: line)
        return
    }
    guard let expectedUrl = XCTExpectedUrl(base: path, name: name, state: state) else {
        XCTFail("Not found expected path for view '\(name)' in state \(state)", file: file, line: line)
        return
    }
    if let expectedImage = Image(url: expectedUrl) {
        if currentImage.compare(expected: expectedImage, tolerance: tolerance) == false {
            XCTContext.runActivity(named: name, block: { activity -> Void in
                let currentAttachment = XCTAttachment(image: currentImage.native)
                currentAttachment.name = "Current"
                activity.add(currentAttachment)
                  
                let expectedAttachment = XCTAttachment(image: expectedImage.native)
                expectedAttachment.name = "Expected"
                activity.add(expectedAttachment)
            })
            XCTFail("Fail compare images for view '\(name)' in state \(state)", file: file, line: line)
        }
    } else if let pngData = currentImage.pngData() {
        try! pngData.write(to: expectedUrl)
    }
}

fileprivate func XCTExpectedUrl(
    base: URL,
    name: String,
    state: String
) -> URL? {
#if os(macOS)
    let device = "macOS"
    let model = ""
#elseif os(iOS)
    let device = "iOS"
    let model = UIDevice.kk_identifier
#endif
    var url = base
    if device.isEmpty == false {
        url.appendPathComponent(device)
    }
    if model.isEmpty == false {
        url.appendPathComponent(model)
    }
    url.appendPathComponent(name)
    url.appendPathComponent(state)
    url.appendPathExtension("png")
    do {
        let folder = url.deletingLastPathComponent()
        if FileManager.default.fileExists(atPath: folder.path) == false {
            do {
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
    }
    return url
}
