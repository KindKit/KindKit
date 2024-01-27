//
//  KindKit
//

protocol BernsteinPolynomial : Equatable {
    
    associatedtype LowerOrderPolynomial : BernsteinPolynomial
    
    var order: Int { get }
    var coefficients: [Coordinate] { get }
    var derivative: LowerOrderPolynomial { get }
    
    func value(at: Coordinate) -> Coordinate
    func reduce(a1: Coordinate, a2: Coordinate) -> Coordinate
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial
    
}

extension BernsteinPolynomial {
    
    var derivative: LowerOrderPolynomial {
        let order = Coordinate(self.order)
        return self.difference(a1: -order, a2: order)
    }
    
    func value(at: Coordinate) -> Coordinate {
        return self.reduce(a1: 1.0 - at, a2: at)
    }
    
    func reduce(a1: Coordinate, a2: Coordinate) -> Coordinate {
        return self.difference(a1: a1, a2: a2).reduce(a1: a1, a2: a2)
    }
    
}

protocol BernsteinPolynomialAnalyticalRoots {
    
    func distinct(_ start: Coordinate, _ end: Coordinate) -> [Coordinate]
    
}

struct ZeroBernsteinPolynomial : BernsteinPolynomial, BernsteinPolynomialAnalyticalRoots {
    
    typealias LowerOrderPolynomial = ZeroBernsteinPolynomial
    
    var b0: Coordinate
    var order: Int {
        return 0
    }
    var coefficients: [Coordinate] {
        return [ self.b0 ]
    }
    
    init(_ b0: Coordinate) {
        self.b0 = b0
    }
    
    func value(at: Coordinate) -> Coordinate {
        return self.b0
    }
    
    func reduce(a1: Coordinate, a2: Coordinate) -> Coordinate {
        return 0
    }
    
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial {
        return LowerOrderPolynomial(0)
    }
    
    func distinct(_ start: Coordinate, _ end: Coordinate) -> [Coordinate] {
        return []
    }
    
}

struct OneBernsteinPolynomial : BernsteinPolynomial, BernsteinPolynomialAnalyticalRoots {
    
    typealias LowerOrderPolynomial = ZeroBernsteinPolynomial
    
    var b0: Coordinate
    var b1: Coordinate
    var order: Int {
        return 1
    }
    var coefficients: [Coordinate] {
        return [ self.b0, self.b1 ]
    }
    
    init(_ b0: Coordinate, _ b1: Coordinate) {
        self.b0 = b0
        self.b1 = b1
    }
    
    func reduce(a1: Coordinate, a2: Coordinate) -> Coordinate {
        return a1 * self.b0 + a2 * self.b1
    }
    
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial {
        return LowerOrderPolynomial(self.reduce(a1: a1, a2: a2))
    }
    
    func distinct(_ start: Coordinate, _ end: Coordinate) -> [Coordinate] {
        var result: [Coordinate] = []
        Bezier.droots(self.b0, self.b1, closure: {
            guard $0 >= start, $0 <= end else { return }
            result.append($0)
        })
        return result
    }
    
}

struct TwoBernsteinPolynomial : BernsteinPolynomial, BernsteinPolynomialAnalyticalRoots {
    
    typealias LowerOrderPolynomial = OneBernsteinPolynomial
    
    var b0: Coordinate
    var b1: Coordinate
    var b2: Coordinate
    var order: Int {
        return 2
    }
    var coefficients: [Coordinate] {
        return [ self.b0, self.b1, self.b2 ]
    }
    
    init(_ b0: Coordinate, _ b1: Coordinate, _ b2: Coordinate) {
        self.b0 = b0
        self.b1 = b1
        self.b2 = b2
    }
    
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial {
        return LowerOrderPolynomial(
            a1 * self.b0 + a2 * self.b1,
            a1 * self.b1 + a2 * self.b2
        )
    }
    
    func distinct(_ start: Coordinate, _ end: Coordinate) -> [Coordinate] {
        var result: [Coordinate] = []
        Bezier.droots(self.b0, self.b1, self.b2, closure: {
            guard $0 >= start, $0 <= end else { return }
            result.append($0)
        })
        return result
    }
    
}

struct ThreeBernsteinPolynomial : BernsteinPolynomial, BernsteinPolynomialAnalyticalRoots {
    
    typealias LowerOrderPolynomial = TwoBernsteinPolynomial
    
    var b0: Coordinate
    var b1: Coordinate
    var b2: Coordinate
    var b3: Coordinate
    var order: Int {
        return 3
    }
    var coefficients: [Coordinate] {
        return [ self.b0, self.b1, self.b2, self.b3 ]
    }
    
    init(_ b0: Coordinate, _ b1: Coordinate, _ b2: Coordinate, _ b3: Coordinate) {
        self.b0 = b0
        self.b1 = b1
        self.b2 = b2
        self.b3 = b3
    }
    
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial {
        return LowerOrderPolynomial(
            a1 * self.b0 + a2 * self.b1,
            a1 * self.b1 + a2 * self.b2,
            a1 * self.b2 + a2 * self.b3
        )
    }
    
    func distinct(_ start: Coordinate, _ end: Coordinate) -> [Coordinate] {
        var result: [Coordinate] = []
        Bezier.droots(self.b0, self.b1, self.b2, self.b3, closure: {
            guard $0 >= start, $0 <= end else { return }
            result.append($0)
        })
        return result
    }
    
}

struct FourBernsteinPolynomial : BernsteinPolynomial {
    
    typealias LowerOrderPolynomial = ThreeBernsteinPolynomial
    
    var b0: Coordinate
    var b1: Coordinate
    var b2: Coordinate
    var b3: Coordinate
    var b4: Coordinate
    var order: Int {
        return 4
    }
    var coefficients: [Coordinate] {
        return [ self.b0, self.b1, self.b2, self.b3, self.b4 ]
    }
    
    init(_ b0: Coordinate, _ b1: Coordinate, _ b2: Coordinate, _ b3: Coordinate, _ b4: Coordinate) {
        self.b0 = b0
        self.b1 = b1
        self.b2 = b2
        self.b3 = b3
        self.b4 = b4
    }
    
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial {
        return LowerOrderPolynomial(
            a1 * self.b0 + a2 * self.b1,
            a1 * self.b1 + a2 * self.b2,
            a1 * self.b2 + a2 * self.b3,
            a1 * self.b3 + a2 * self.b4
        )
    }
    
}

struct FiveBernsteinPolynomial : BernsteinPolynomial {
    
    typealias LowerOrderPolynomial = FourBernsteinPolynomial
    
    var b0: Coordinate
    var b1: Coordinate
    var b2: Coordinate
    var b3: Coordinate
    var b4: Coordinate
    var b5: Coordinate
    var order: Int {
        return 5
    }
    var coefficients: [Coordinate] {
        return [ self.b0, self.b1, self.b2, self.b3, self.b4, self.b5 ]
    }
    
    init(_ b0: Coordinate, _ b1: Coordinate, _ b2: Coordinate, _ b3: Coordinate, _ b4: Coordinate, _ b5: Coordinate) {
        self.b0 = b0
        self.b1 = b1
        self.b2 = b2
        self.b3 = b3
        self.b4 = b4
        self.b5 = b5
    }
    
    func difference(a1: Coordinate, a2: Coordinate) -> LowerOrderPolynomial {
        return LowerOrderPolynomial(
            a1 * self.b0 + a2 * self.b1,
            a1 * self.b1 + a2 * self.b2,
            a1 * self.b2 + a2 * self.b3,
            a1 * self.b3 + a2 * self.b4,
            a1 * self.b4 + a2 * self.b5
        )
    }
    
}

func findDistinctRoots< Polynomial : BernsteinPolynomial >(of polynomial: Polynomial, start: Coordinate = 0, end: Coordinate = 1) -> [Coordinate] {
    if let analyticalRoots = polynomial as? BernsteinPolynomialAnalyticalRoots {
        return analyticalRoots.distinct(start, end)
    }
    let derivative = polynomial.derivative
    let criticalPoints = findDistinctRoots(of: derivative, start: start, end: end)
    let intervals = [start] + criticalPoints + [end]
    var lastFoundRoot: Coordinate?
    let roots = (0 ..< intervals.count - 1).compactMap({ i -> Coordinate? in
        let start = intervals[i]
        let end = intervals[i + 1]
        let fStart = polynomial.value(at: start)
        let fEnd = polynomial.value(at: end)
        let root: Coordinate
        if fStart * fEnd < 0 {
            let guess = (start + end) / 2
            let newtonRoot = newton(of: polynomial, derivative: derivative, guess: guess)
            if start < newtonRoot, newtonRoot < end {
                root = newtonRoot
            } else {
                root = findRootBisection(of: polynomial, start: start, end: end)
            }
        } else {
            let guess = end
            let value = newton(of: polynomial, derivative: derivative, guess: guess)
            guard abs(value - guess) < 1.0e-5 else {
                return nil
            }
            guard abs(polynomial.value(at: value)) < 1.0e-10 else {
                return nil
            }
            root = value
        }
        if let lastFoundRoot = lastFoundRoot {
            guard lastFoundRoot + 1.0e-5 < root else {
                return nil
            }
        }
        lastFoundRoot = root
        return root
    })
    return roots
}

func findRootBisection< Polynomial : BernsteinPolynomial >(of polynomial: Polynomial, start: Coordinate = 0, end: Coordinate = 1) -> Coordinate {
    var guess = (start + end) / 2
    var low = start
    var high = end
    let lowSign = polynomial.value(at: low).sign
    let maxIterations = 20
    var iterations = 0
    while high - low > 1.0e-5 {
        let midGuess = (low + high) / 2
        guess = midGuess
        let nextGuessF = polynomial.value(at: guess)
        if nextGuessF == 0 {
            return guess
        } else if nextGuessF.sign == lowSign {
            low = guess
        } else {
            high = guess
        }
        iterations += 1
        guard iterations < maxIterations else {
            break
        }
    }
    return guess
}

func newton< Polynomial : BernsteinPolynomial >(of polynomial: Polynomial, derivative: Polynomial.LowerOrderPolynomial, guess: Coordinate, _ relaxation: Coordinate = 1) -> Coordinate {
    let maxIterations = 20
    var x = guess
    for _ in 0 ..< maxIterations {
        let f = polynomial.value(at: x)
        guard f != 0.0 else {
            break
        }
        let fPrime = derivative.value(at: x)
        let delta = relaxation * f / fPrime
        let previous = x
        x -= delta
        guard abs(x - previous) > 1.0e-10 else {
            break
        }
    }
    return x
}
