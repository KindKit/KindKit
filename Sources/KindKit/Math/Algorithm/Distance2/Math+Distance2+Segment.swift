//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct SegmentToSegment : Equatable {
        
        public let segment1: PointIntoLine
        public let segment2: PointIntoLine
        public let squaredDistance: Distance.Squared
        
        public init(
            segment1: PointIntoLine,
            segment2: PointIntoLine
        ) {
            self.segment1 = segment1
            self.segment2 = segment2
            self.squaredDistance = segment1.point.squaredLength(segment2.point)
        }
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ segment1: Segment2, _ segment2: Segment2) -> SegmentToSegment {
        let s1d = segment1.end - segment1.start
        let s2d = segment2.end - segment2.start
        let s1s_s2s = segment1.start - segment2.start
        let a = s1d.dot(s1d)
        let b = s1d.dot(s2d)
        let c = s2d.dot(s2d)
        let d = s1d.dot(s1s_s2s)
        let e = s2d.dot(s1s_s2s)
        let f00 = d
        let f10 = f00 + a
        let f01 = f00 - b
        let f11 = f10 - b
        let g00 = -e
        let g10 = g00 - b
        let g01 = g00 + c
        let g11 = g10 + c
        let find: Closest
        if a > 0 && c > 0 {
            let cr = Closest(
                src: Self._clampedRoot(a, f00, f10),
                dst: Self._clampedRoot(a, f01, f11)
            )
            let cl = Classify(
                src: Self._classify(cr.src),
                dst: Self._classify(cr.dst)
            )
            if cl.src < 0 && cl.dst < 0 {
                find = .init(
                    src: 0,
                    dst: Self._clampedRoot(c, g00, g01)
                )
            } else if cl.src > 0 && cl.dst > 0 {
                find = .init(
                    src: 1,
                    dst: Self._clampedRoot(c, g10, g11)
                )
            } else {
                let i = Self._intersection(cr, cl, b, f00, f10)
                find = Self._parameters(i, b, c, e, g00, g10, g01, g11)
            }
        } else {
            if a > 0 {
                find = .init(
                    src: Self._clampedRoot(a, f00, f10),
                    dst: 0
                )
            } else if c > 0 {
                find = .init(
                    src: 0,
                    dst: Self._clampedRoot(a, g00, g10)
                )
            } else {
                find = .init(src: 0, dst: 0)
            }
        }
        return .init(
            segment1: .init(
                closest: .init(find.src),
                point: segment1.point(at: .init(find.src))
            ),
            segment2: .init(
                closest: .init(find.dst),
                point: segment2.point(at: .init(find.dst))
            )
        )
    }
    
}

fileprivate extension Math.Distance2 {
    
    struct Closest {
        
        let src: Double
        let dst: Double
        
        init(src: Double, dst: Double) {
            self.src = src
            self.dst = dst
        }
        
        init(src: () -> Double, dst: Double) {
            self.src = src()
            self.dst = dst
        }
        
        init(src: Double, dst: () -> Double) {
            self.src = src
            self.dst = dst()
        }
        
        init(src: () -> Double, dst: () -> Double) {
            self.src = src()
            self.dst = dst()
        }
        
    }
    
    struct Classify {
        
        let src: Int
        let dst: Int
        
    }
    
    struct Intersect {
        
        let edge: Classify
        let end: End
        
        struct End {
            
            let src: Closest
            let dst: Closest
            
        }
        
    }
    
}

fileprivate extension Math.Distance2 {
    
    @inline(__always)
    static func _clampedRoot(_ slope: Double, _ h0: Double, _ h1: Double) -> Double {
        guard h0 < 0 else { return 0 }
        guard h1 > 0 else { return 1 }
        let r = -h0 / slope
        if r > 1 {
            return 0.5
        }
        return r
    }
    
    @inline(__always)
    static func _classify(_ value: Double) -> Int {
        if value <= 0 {
            return -1
        } else if value >= 1 {
            return +1
        }
        return 0
    }
    
    @inline(__always)
    static func _intersection(_ root: Closest, _ classify: Classify, _ b: Double,  _ f00: Double, _ f10: Double) -> Intersect {
        let edge: Classify
        let endSrc: Closest
        let endDst: Closest
        if classify.src < 0 {
            endSrc = .init(src: 0, dst: {
                var t = f00 / b
                if t < 0 || t > 1 {
                    t = 0.5
                }
                return t
            })
            if classify.dst == 0 {
                edge = .init(src: 0, dst: 3)
                endDst = .init(src: root.dst, dst: 1)
            } else {
                edge = .init(src: 0, dst: 1)
                endDst = .init(src: 1, dst: {
                    var t = f10 / b
                    if t < 0 || t > 1 {
                        t = 0.5
                    }
                    return t
                })
            }
        } else if classify.src == 0 {
            endSrc = .init(src: root.src, dst: 0)
            if classify.dst < 0 {
                edge = .init(src: 2, dst: 0)
                endDst = .init(src: 0, dst: {
                    var t = f00 / b
                    if t < 0 || t > 1 {
                        t = 0.5
                    }
                    return t
                })
            } else if classify.dst == 0 {
                edge = .init(src: 2, dst: 3)
                endDst = .init(src: root.dst, dst: 1)
            } else {
                edge = .init(src: 2, dst: 1)
                endDst = .init(src: 1, dst: {
                    var t = f10 / b
                    if t < 0 || t > 1 {
                        t = 0.5
                    }
                    return t
                })
            }
        } else {
            endSrc = .init(src: 1, dst: {
                var t = f10 / b
                if t < 0 || t > 1 {
                    t = 0.5
                }
                return t
            })
            if classify.dst == 0 {
                edge = .init(src: 1, dst: 3)
                endDst = .init(src: root.dst, dst: 1)
            } else {
                edge = .init(src: 1, dst: 0)
                endDst = .init(src: 0, dst: {
                    var t = f00 / b
                    if t < 0 || t > 1 {
                        t = 0.5
                    }
                    return t
                })
            }
        }
        return .init(
            edge: edge,
            end: .init(
                src: endSrc,
                dst: endDst
            )
        )
    }
    
    @inline(__always)
    static func _parameters(_ i: Intersect, _ b: Double, _ c: Double, _ e: Double, _ g00: Double, _ g10: Double, _ g01: Double, _ g11: Double) -> Closest {
        let d = i.end.dst.dst - i.end.src.dst
        let h0 = d * (-b * i.end.src.src + c * i.end.src.dst - e)
        if h0 >= 0 {
            if i.edge.dst == 0 {
                return .init(
                    src: 0,
                    dst: Self._clampedRoot(c, g00, g01)
                )
            } else if i.edge.src == 1 {
                return .init(
                    src: 1,
                    dst: Self._clampedRoot(c, g10, g11)
                )
            }
            return .init(
                src: i.end.src.src,
                dst: i.end.src.dst
            )
        } else {
            let h1 = d * (-b * i.end.dst.src + c * i.end.dst.dst - e)
            if h1 <= 0 {
                if i.edge.dst == 0 {
                    return .init(
                        src: 0,
                        dst: Self._clampedRoot(c, g00, g01)
                    )
                } else if i.edge.dst == 1 {
                    return .init(
                        src: 1,
                        dst: Self._clampedRoot(c, g10, g11)
                    )
                } else {
                    return .init(
                        src: i.end.dst.src,
                        dst: i.end.dst.dst
                    )
                }
            } else {
                let z = min(max(h0 / (h0 - h1), 0), 1)
                let omz = 1 - z
                return .init(
                    src: omz * i.end.src.src + z * i.end.dst.src,
                    dst: omz * i.end.src.dst + z * i.end.dst.dst
                )
            }
        }
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.SegmentToSegment {
        return Math.Distance2.find(other, self)
    }
    
}
