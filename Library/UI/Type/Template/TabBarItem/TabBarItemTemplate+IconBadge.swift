//
//  KindKit
//

import KindLayout
import KindStyleSheet
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let inset = Inset(horizontal: 4, vertical: 4)
    static let badgeSubstrateInset = Inset(horizontal: 4, vertical: 4)
    static let badgeTarget = Anchor(x: .one, y: .zero)
    static let badgeTargetOffset = Point.zero
    static let badgeOrigin = Anchor(x: .half, y: .half)
    static let badgeOriginOffset = Point.zero
    
}

extension TabBarItemTemplate {
    
    public struct IconBadge<
        Icon : IView & IViewSupportStyleSheet,
        BadgeSubstrate : IView & IViewSupportStyleSheet,
        Badge : IView & IViewSupportStyleSheet
    > : ITemplate {
        
        public typealias Layout = MarginLayout<
            AnchorLayout<
                ViewLayout< Icon >,
                SubstrateLayout<
                    ViewLayout< BadgeSubstrate >,
                    MarginLayout<
                        ViewLayout< Badge >
                    >
                >
            >
        >
        
        public typealias StyleSheet = Selected< Highlighted< StyleSheet > >
        
        public let layout: Layout
        
        public var inset: Inset {
            nonmutating set { self.layout.inset = newValue }
            get { self.layout.inset }
        }
        
        public var icon: Icon {
            nonmutating set { self.layout.content.content.content = newValue }
            get { self.layout.content.content.content }
        }
        
        public var badgeSubstrate: BadgeSubstrate {
            nonmutating set { self.layout.content.overlay.substrate.content = newValue }
            get { self.layout.content.overlay.substrate.content }
        }
        
        public var badgeSubstrateInset: Inset {
            nonmutating set { self.layout.content.overlay.content.inset = newValue }
            get { self.layout.content.overlay.content.inset }
        }
        
        public var badge: Badge {
            nonmutating set { self.layout.content.overlay.content.content.content = newValue }
            get { self.layout.content.overlay.content.content.content }
        }
        
        public var badgeTarget: Anchor {
            nonmutating set { self.layout.content.contentAnchor = newValue }
            get { self.layout.content.contentAnchor }
        }
        
        public var badgeTargetOffset: Point {
            nonmutating set { self.layout.content.contentOffset = newValue }
            get { self.layout.content.contentOffset }
        }
        
        public var badgeOrigin: Anchor {
            nonmutating set { self.layout.content.overlayAnchor = newValue }
            get { self.layout.content.overlayAnchor }
        }
        
        public var badgeOriginOffset: Point {
            nonmutating set { self.layout.content.overlayOffset = newValue }
            get { self.layout.content.overlayOffset }
        }
        
        public init(
            inset: Inset? = nil,
            icon: Icon,
            badgeSubstrate: BadgeSubstrate,
            badgeSubstrateInset: Inset? = nil,
            badge: Badge,
            badgeTarget: Anchor? = nil,
            badgeTargetOffset: Point? = nil,
            badgeOrigin: Anchor? = nil,
            badgeOriginOffset: Point? = nil
        ) {
            self.layout = MarginLayout(
                AnchorLayout(
                    content: ViewLayout(icon),
                    overlay: SubstrateLayout(
                        substrate: ViewLayout(badgeSubstrate),
                        content: MarginLayout(
                            ViewLayout(badge)
                        ).update(on: {
                            $0.inset = badgeSubstrateInset ?? Defaults.badgeSubstrateInset
                        })
                    )
                ).update(on: {
                    $0.contentAnchor = badgeTarget ?? Defaults.badgeTarget
                    $0.contentOffset = badgeTargetOffset ?? Defaults.badgeTargetOffset
                    $0.overlayAnchor = badgeOrigin ?? Defaults.badgeOrigin
                    $0.overlayOffset = badgeOriginOffset ?? Defaults.badgeOriginOffset
                })
            ).update(on: {
                $0.inset = inset ?? Defaults.inset
            })
        }
        
        public func apply(_ styleSheet: StyleSheet.Resolve) {
            self.layout.update(on: {
                if let inset = styleSheet.inset {
                    self.inset = inset
                }
                self.icon.apply(styleSheet.icon)
                self.badgeSubstrate.apply(styleSheet.badgeSubstrate)
                if let badgeSubstrateInset = styleSheet.badgeSubstrateInset {
                    self.badgeSubstrateInset = badgeSubstrateInset
                }
                self.badge.apply(styleSheet.badge)
                if let badgeTarget = styleSheet.badgeTarget {
                    self.badgeTarget = badgeTarget
                }
                if let badgeTargetOffset = styleSheet.badgeTargetOffset {
                    self.badgeTargetOffset = badgeTargetOffset
                }
                if let badgeOrigin = styleSheet.badgeOrigin {
                    self.badgeOrigin = badgeOrigin
                }
                if let badgeOriginOffset = styleSheet.badgeOriginOffset {
                    self.badgeOriginOffset = badgeOriginOffset
                }
            })
        }
        
    }
    
}

extension TabBarItemTemplate.IconBadge {
    
    public struct StyleSheet : StyleSheetTrait {
        
        public let inset: Inset?
        
        public let icon: Icon.StyleSheet
        
        public let badgeSubstrate: BadgeSubstrate.StyleSheet
        
        public let badgeSubstrateInset: Inset?
        
        public let badge: Badge.StyleSheet
        
        public let badgeTarget: Anchor?
        
        public let badgeTargetOffset: Point?
        
        public let badgeOrigin: Anchor?
        
        public let badgeOriginOffset: Point?
        
        public init(
            inset: Inset? = nil,
            icon: Icon.StyleSheet,
            badgeSubstrate: BadgeSubstrate.StyleSheet,
            badgeSubstrateInset: Inset? = nil,
            badge: Badge.StyleSheet,
            badgeTarget: Anchor? = nil,
            badgeTargetOffset: Point? = nil,
            badgeOrigin: Anchor? = nil,
            badgeOriginOffset: Point? = nil
        ) {
            self.inset = inset
            self.icon = icon
            self.badgeSubstrate = badgeSubstrate
            self.badgeSubstrateInset = badgeSubstrateInset
            self.badge = badge
            self.badgeTarget = badgeOrigin
            self.badgeTargetOffset = badgeOriginOffset
            self.badgeOrigin = badgeOrigin
            self.badgeOriginOffset = badgeOriginOffset
        }
        
    }
    
}
