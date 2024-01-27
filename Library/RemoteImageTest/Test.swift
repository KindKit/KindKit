//
//  KindKit-Test
//

import XCTest
import KindRemoteImage

class Test : XCTestCase {
    
    func testLoad() {
        let loader = Loader(
            provider: Provider(
                authenticationChallenge: .allowUntrusted,
                configuration: .default
            )
        )
        let expectation1 = self.expectation(description: "Test")
        let target1 = SimpleTarget()
            .onImage(regular: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation1.fulfill()
            })
            .onError(regular: {
                expectation1.fulfill()
            })
        let expectation2 = self.expectation(description: "Test")
        let target2 = SimpleTarget()
            .onImage(regular: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation2.fulfill()
            })
            .onError(regular: {
                expectation2.fulfill()
            })
        let url = URL(string: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")!
        loader.cleanup(before: .zero)
        loader.download(
            target: target1,
            query: Query(url: url)
        )
        loader.download(
            target: target2,
            query: Query(url: url)
        )
        self.wait(for: [ expectation1, expectation2 ], timeout: 60 * 2)
    }
    
    func testFilter() {
        let loader = Loader(
            provider: Provider(
                authenticationChallenge: .allowUntrusted,
                configuration: .default
            )
        )
        let expectation1 = self.expectation(description: "Test")
        let target1 = SimpleTarget()
            .onImage(regular: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation1.fulfill()
            })
            .onError(regular: {
                expectation1.fulfill()
            })
        let expectation2 = self.expectation(description: "Test")
        let target2 = SimpleTarget()
            .onImage(regular: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation2.fulfill()
            })
            .onError(regular: {
                expectation2.fulfill()
            })
        let url = URL(string: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")!
        loader.cleanup(before: .zero)
        loader.download(
            target: target1,
            query: Query(url: url)
        )
        loader.download(
            target: target2,
            query: Query(url: url),
            filter: SequenceFilter([
                ThumbnailFilter(Size(width: 512, height: 512)),
                GrayscaleFilter()
            ])
        )
        self.wait(for: [ expectation1, expectation2 ], timeout: 60 * 2)
    }

}
