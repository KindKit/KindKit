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
        let target1 = Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation1.fulfill()
            },
            onError: { error in
                expectation1.fulfill()
            }
        )
        let expectation2 = self.expectation(description: "Test")
        let target2 = Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation2.fulfill()
            },
            onError: { error in
                expectation2.fulfill()
            }
        )
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
        let target1 = Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation1.fulfill()
            },
            onError: { error in
                expectation1.fulfill()
            }
        )
        let expectation2 = self.expectation(description: "Test")
        let target2 = Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation2.fulfill()
            },
            onError: { error in
                expectation2.fulfill()
            }
        )
        let url = URL(string: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")!
        loader.cleanup(before: .zero)
        loader.download(
            target: target1,
            query: Query(url: url)
        )
        loader.download(
            target: target2,
            query: Query(url: url),
            filter: Filter.Group([
                Filter.Thumbnail(Size(width: 512, height: 512)),
                Filter.Grayscale()
            ])
        )
        self.wait(for: [ expectation1, expectation2 ], timeout: 60 * 2)
    }

}
