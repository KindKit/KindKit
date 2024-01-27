//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension Font {
    
#if os(macOS)
    
    @available(macOS 11.0, *)
    @inlinable
    static var systemLargeTitle: Self {
        return .init(.preferredFont(forTextStyle: .largeTitle))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemTitle1: Self {
        return .init(.preferredFont(forTextStyle: .title1))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemTitle2: Self {
        return .init(.preferredFont(forTextStyle: .title2))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemTitle3: Self {
        return .init(.preferredFont(forTextStyle: .title3))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemHeadline: Self {
        return .init(.preferredFont(forTextStyle: .headline))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemSubheadline: Self {
        return .init(.preferredFont(forTextStyle: .subheadline))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemBody: Self {
        return .init(.preferredFont(forTextStyle: .body))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemCallout: Self {
        return .init(.preferredFont(forTextStyle: .callout))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemFootnote: Self {
        return .init(.preferredFont(forTextStyle: .footnote))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemCaption1: Self {
        return .init(.preferredFont(forTextStyle: .caption1))
    }

    @available(macOS 11.0, *)
    @inlinable
    static var systemCaption2: Self {
        return .init(.preferredFont(forTextStyle: .caption2))
    }
    
#elseif os(iOS)
    
    @inlinable
    static var systemLargeTitle: Self {
        return .init(.preferredFont(forTextStyle: .largeTitle))
    }

    @available(iOS 17.0, *)
    @inlinable
    static var systemExtraLargeTitle: Self {
        return .init(.preferredFont(forTextStyle: .extraLargeTitle))
    }

    @available(iOS 17.0, *)
    @inlinable
    static var systemExtraLargeTitle2: Self {
        return .init(.preferredFont(forTextStyle: .extraLargeTitle2))
    }

    @inlinable
    static var systemTitle1: Self {
        return .init(.preferredFont(forTextStyle: .title1))
    }

    @inlinable
    static var systemTitle2: Self {
        return .init(.preferredFont(forTextStyle: .title2))
    }

    @inlinable
    static var systemTitle3: Self {
        return .init(.preferredFont(forTextStyle: .title3))
    }

    @inlinable
    static var systemHeadline: Self {
        return .init(.preferredFont(forTextStyle: .headline))
    }

    @inlinable
    static var systemSubheadline: Self {
        return .init(.preferredFont(forTextStyle: .subheadline))
    }

    @inlinable
    static var systemBody: Self {
        return .init(.preferredFont(forTextStyle: .body))
    }

    @inlinable
    static var systemCallout: Self {
        return .init(.preferredFont(forTextStyle: .callout))
    }

    @inlinable
    static var systemFootnote: Self {
        return .init(.preferredFont(forTextStyle: .footnote))
    }

    @inlinable
    static var systemCaption1: Self {
        return .init(.preferredFont(forTextStyle: .caption1))
    }

    @inlinable
    static var systemCaption2: Self {
        return .init(.preferredFont(forTextStyle: .caption2))
    }
    
#endif
    
}
