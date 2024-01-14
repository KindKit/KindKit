//
//  KindKit
//

#if os(iOS) && canImport(XCTest)

import XCTest
import KindScreenUI

public extension XCTestCase {
    
    func kk_makeWindow<
        ScreenType : IScreen & IScreenDialogable & IScreenViewable
    >(
        screen: ScreenType,
        stylization: (UIWindow) -> Void = { _ in }
    ) -> UIWindow {
        let container = Container.Dialog()
        let window = self.kk_makeWindow(
            container: container,
            stylization: stylization
        )
        container.present(
            container: Container.Screen(screen),
            animated: false,
            completion: nil
        )
        return window
    }
    
    func kk_makeWindow< ContainerType : IRootContentContainer >(
        container: ContainerType,
        stylization: (UIWindow) -> Void = { _ in }
    ) -> UIWindow {
        return self.kk_makeWindow(
            container: Container.Root(content: container),
            stylization: stylization
        )
    }
    
    func kk_makeWindow(
        container: Container.Root,
        stylization: (UIWindow) -> Void = { _ in }
    ) -> UIWindow {
        return self.kk_makeWindow(
            viewController: ViewController(container),
            stylization: stylization
        )
    }
    
    func kk_makeWindow(
        viewController: ViewController,
        stylization: (UIWindow) -> Void = { _ in }
    ) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        stylization(window)
        window.makeKeyAndVisible()
        return window
    }
    
    func kk_wait(
        duration: TimeInterval
    ) {
        let expectation = XCTestExpectation(description: "Wait")
        DispatchQueue.main.asyncAfter(
            deadline: .now() + duration,
            execute: { expectation.fulfill() }
        )
        _ = XCTWaiter.wait(for: [expectation], timeout: duration + 0.1)
    }
    
    func kk_validation(
        window: UIWindow,
        delay: TimeInterval,
        path: URL,
        screen: String,
        variant: String,
        tolerance: CGFloat = 0.1,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if delay > 0 {
            window.setNeedsLayout()
            window.layoutIfNeeded()
            self.kk_wait(duration: delay)
        }
        guard let currentImage = window.kk_snapshot() else {
            XCTFail("Invalid creating snapshot for screen '\(screen)' in state \(variant)", file: file, line: line)
            return
        }
        guard let expectedUrl = self._expectedUrl(base: path, screen: screen, variant: variant) else {
            XCTFail("Not found expected path for screen '\(screen)' in state \(variant)", file: file, line: line)
            return
        }
        if let expectedImage = UIImage(contentsOfFile: expectedUrl.path) {
            if currentImage.kk_compare(expected: expectedImage, tolerance: tolerance) == false {
                XCTContext.runActivity(named: screen, block: { activity -> Void in
                    let currentAttachment = XCTAttachment(image: currentImage)
                    currentAttachment.name = "Current"
                    activity.add(currentAttachment)
                      
                    let expectedAttachment = XCTAttachment(image: expectedImage)
                    expectedAttachment.name = "Expected"
                    activity.add(expectedAttachment)
                })
                XCTFail("Fail compare images for screen '\(screen)' in state \(variant)", file: file, line: line)
            }
        } else if let pngData = currentImage.pngData() {
            try! pngData.write(to: expectedUrl)
        }
    }
    
}

fileprivate extension XCTestCase {
    
    func _expectedUrl(
        base: URL,
        screen: String,
        variant: String
    ) -> URL? {
        let url = base.appendingPathComponent(UIDevice.kk_identifier).appendingPathComponent(screen)
        if FileManager.default.fileExists(atPath: url.path) == false {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        return url.appendingPathComponent("\(variant).png")
    }
    
}

#endif
