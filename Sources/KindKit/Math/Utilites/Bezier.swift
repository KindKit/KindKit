//
//  KindKit
//

import Foundation

struct Bezier {
    
    static func length(_ closure: (_ value: Double) -> Double) -> Double {
        let tv = Self.Tvalues
        let cv = Self.Cvalues
        let count = tv.count
        let z = 0.5
        var s = 0.0
        for i in 0..<count {
            let t = z * tv[i] + z
            s += cv[i] * closure(t)
        }
        return z * s
    }
    
    static func crt(_ v: Double) -> Double {
        return (v < 0) ? -pow(-v, 1.0/3.0) : pow(v, 1.0/3.0)
    }
    
    static func droots(_ p0: Double, _ p1: Double, closure: (Double) -> Void) {
        guard p0 != p1 else { return }
        closure(p0 / (p0 - p1))
    }
    
    static func droots(_ p0: Double, _ p1: Double, _ p2: Double, closure: (Double) -> Void) {
        let d = p0 - 2.0 * p1 + p2
        guard d.isFinite else { return }
        guard abs(d) > .leastNonzeroMagnitude else {
            if p0 != p1 {
                closure(0.5 * p0 / (p0 - p1))
            }
            return
        }
        let radical = p1 * p1 - p0 * p2
        guard radical >= 0 else { return }
        let m1 = sqrt(radical)
        let m2 = p0 - p1
        let v1 = (m2 + m1) / d
        let v2 = (m2 - m1) / d
        if v1 < v2 {
            closure(v1)
            closure(v2)
        } else if v1 > v2 {
            closure(v2)
            closure(v1)
        } else {
            closure(v1)
        }
    }
    
    static func droots(_ p0: Double, _ p1: Double, _ p2: Double, _ p3: Double, closure: (Double) -> Void) {
        let d = -p0 + 3 * p1 - 3 * p2 + p3
        let smallValue = 1.0e-8
        guard abs(d) >= smallValue else {
            let a = (3 * p0 - 6 * p1 + 3 * p2)
            let b = (-3 * p0 + 3 * p1)
            let c = p0
            droots(c, b / 2.0 + c, a + b + c, closure: closure)
            return
        }
        let a = (3 * p0 - 6 * p1 + 3 * p2) / d
        let b = (-3 * p0 + 3 * p1) / d
        let c = p0 / d
        let p = (3 * b - a * a) / 3
        let q = (2 * a * a * a - 9 * a * b + 27 * c) / 27
        let q2 = q/2
        let discriminant = q2 * q2 + p * p * p / 27
        let tinyValue = 1.0e-14
        if discriminant < -tinyValue {
            let r = sqrt(-p * p * p / 27)
            let t = -q / (2 * r)
            let cosphi = t < -1 ? -1 : t > 1 ? 1 : t
            let phi = acos(cosphi)
            let crtr = crt(r)
            let t1 = 2 * crtr
            let root1 = t1 * cos((phi + 2 * .pi) / 3) - a / 3
            let root2 = t1 * cos((phi + 4 * .pi) / 3) - a / 3
            let root3 = t1 * cos(phi / 3) - a / 3
            closure(root1)
            if root2 > root1 {
                closure(root2)
            }
            if root3 > root2 {
                closure(root3)
            }
        } else if discriminant > tinyValue {
            let sd = sqrt(discriminant)
            let u1 = crt(-q2 + sd)
            let v1 = crt(q2 + sd)
            closure(u1 - v1 - a / 3)
        } else if discriminant.isNaN == false {
            let u1 = q2 < 0 ? crt(-q2) : -crt(q2)
            let root1 = 2 * u1 - a / 3
            let root2 = -u1 - a / 3
            if root1 < root2 {
                closure(root1)
                closure(root2)
            } else if root1 > root2 {
                closure(root2)
                closure(root1)
            } else {
                closure(root1)
            }
        }
    }
    
}

private extension Bezier {
    
    static let Tvalues: ContiguousArray< Double > =  [
        -0.0640568928626056260850430826247450385909,
        0.0640568928626056260850430826247450385909,
        -0.1911188674736163091586398207570696318404,
        0.1911188674736163091586398207570696318404,
        -0.3150426796961633743867932913198102407864,
        0.3150426796961633743867932913198102407864,
        -0.4337935076260451384870842319133497124524,
        0.4337935076260451384870842319133497124524,
        -0.5454214713888395356583756172183723700107,
        0.5454214713888395356583756172183723700107,
        -0.6480936519369755692524957869107476266696,
        0.6480936519369755692524957869107476266696,
        -0.7401241915785543642438281030999784255232,
        0.7401241915785543642438281030999784255232,
        -0.8200019859739029219539498726697452080761,
        0.8200019859739029219539498726697452080761,
        -0.8864155270044010342131543419821967550873,
        0.8864155270044010342131543419821967550873,
        -0.9382745520027327585236490017087214496548,
        0.9382745520027327585236490017087214496548,
        -0.9747285559713094981983919930081690617411,
        0.9747285559713094981983919930081690617411,
        -0.9951872199970213601799974097007368118745,
        0.9951872199970213601799974097007368118745
    ]
    
    static let Cvalues: ContiguousArray< Double > =  [
        0.1279381953467521569740561652246953718517,
        0.1279381953467521569740561652246953718517,
        0.1258374563468282961213753825111836887264,
        0.1258374563468282961213753825111836887264,
        0.1216704729278033912044631534762624256070,
        0.1216704729278033912044631534762624256070,
        0.1155056680537256013533444839067835598622,
        0.1155056680537256013533444839067835598622,
        0.1074442701159656347825773424466062227946,
        0.1074442701159656347825773424466062227946,
        0.0976186521041138882698806644642471544279,
        0.0976186521041138882698806644642471544279,
        0.0861901615319532759171852029837426671850,
        0.0861901615319532759171852029837426671850,
        0.0733464814110803057340336152531165181193,
        0.0733464814110803057340336152531165181193,
        0.0592985849154367807463677585001085845412,
        0.0592985849154367807463677585001085845412,
        0.0442774388174198061686027482113382288593,
        0.0442774388174198061686027482113382288593,
        0.0285313886289336631813078159518782864491,
        0.0285313886289336631813078159518782864491,
        0.0123412297999871995468056670700372915759,
        0.0123412297999871995468056670700372915759
    ]
    
}
