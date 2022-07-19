//
//  KindKitMath
//

import Foundation

protocol IBernsteinPolynomial : Equatable {
    
    associatedtype LowerOrderPolynomial : IBernsteinPolynomial
    
    var order: Int { get }
    var coefficients: [Double] { get }
    var derivative: LowerOrderPolynomial { get }
    
    func value(at: Double) -> Double
    func reduce(a1: Double, a2: Double) -> Double
    func difference(a1: Double, a2: Double) -> LowerOrderPolynomial
    
}

extension IBernsteinPolynomial {
    
    var derivative: LowerOrderPolynomial {
        let order = Double(self.order)
        return self.difference(a1: -order, a2: order)
    }
    
    func value(at: Double) -> Double {
        return self.reduce(a1: 1.0 - at, a2: at)
    }
    
    func reduce(a1: Double, a2: Double) -> Double {
        return self.difference(a1: a1, a2: a2).reduce(a1: a1, a2: a2)
    }
    
}

protocol IBernsteinPolynomialAnalyticalRoots {
    
    func distinct(_ start: Double, _ end: Double) -> [Double]
    
}

struct BernsteinPolynomial {
    
    struct Zero : IBernsteinPolynomial, IBernsteinPolynomialAnalyticalRoots {
        
        typealias LowerOrderPolynomial = Zero
        
        var b0: Double
        var order: Int {
            return 0
        }
        var coefficients: [Double] {
            return [ self.b0 ]
        }
        
        init(_ b0: Double) {
            self.b0 = b0
        }
        
        func value(at: Double) -> Double {
            return self.b0
        }
        
        func reduce(a1: Double, a2: Double) -> Double {
            return 0
        }
        
        func difference(a1: Double, a2: Double) -> LowerOrderPolynomial {
            return LowerOrderPolynomial(0)
        }
        
        func distinct(_ start: Double, _ end: Double) -> [Double] {
            return []
        }
        
    }
    
    struct One : IBernsteinPolynomial, IBernsteinPolynomialAnalyticalRoots {
        
        typealias LowerOrderPolynomial = Zero
        
        var b0: Double
        var b1: Double
        var order: Int {
            return 1
        }
        var coefficients: [Double] {
            return [ self.b0, self.b1 ]
        }
        
        init(_ b0: Double, _ b1: Double) {
            self.b0 = b0
            self.b1 = b1
        }
        
        func reduce(a1: Double, a2: Double) -> Double {
            return a1 * self.b0 + a2 * self.b1
        }
        
        func difference(a1: Double, a2: Double) -> LowerOrderPolynomial {
            return LowerOrderPolynomial(self.reduce(a1: a1, a2: a2))
        }
        
        func distinct(_ start: Double, _ end: Double) -> [Double] {
            var result: [Double] = []
            Bezier.droots(self.b0, self.b1, closure: {
                guard $0 >= start, $0 <= end else { return }
                result.append($0)
            })
            return result
        }
        
    }
    
    struct Two : IBernsteinPolynomial, IBernsteinPolynomialAnalyticalRoots {
        
        typealias LowerOrderPolynomial = One
        
        var b0: Double
        var b1: Double
        var b2: Double
        var order: Int {
            return 2
        }
        var coefficients: [Double] {
            return [ self.b0, self.b1, self.b2 ]
        }
        
        init(_ b0: Double, _ b1: Double, _ b2: Double) {
            self.b0 = b0
            self.b1 = b1
            self.b2 = b2
        }
        
        func difference(a1: Double, a2: Double) -> LowerOrderPolynomial {
            return LowerOrderPolynomial(
                a1 * self.b0 + a2 * self.b1,
                a1 * self.b1 + a2 * self.b2
            )
        }
        
        func distinct(_ start: Double, _ end: Double) -> [Double] {
            var result: [Double] = []
            Bezier.droots(self.b0, self.b1, self.b2, closure: {
                guard $0 >= start, $0 <= end else { return }
                result.append($0)
            })
            return result
        }
        
    }
    
    struct Three : IBernsteinPolynomial, IBernsteinPolynomialAnalyticalRoots {
        
        typealias LowerOrderPolynomial = Two
        
        var b0: Double
        var b1: Double
        var b2: Double
        var b3: Double
        var order: Int {
            return 3
        }
        var coefficients: [Double] {
            return [ self.b0, self.b1, self.b2, self.b3 ]
        }
        
        init(_ b0: Double, _ b1: Double, _ b2: Double, _ b3: Double) {
            self.b0 = b0
            self.b1 = b1
            self.b2 = b2
            self.b3 = b3
        }
        
        func difference(a1: Double, a2: Double) -> LowerOrderPolynomial {
            return LowerOrderPolynomial(
                a1 * self.b0 + a2 * self.b1,
                a1 * self.b1 + a2 * self.b2,
                a1 * self.b2 + a2 * self.b3
            )
        }
        
        func distinct(_ start: Double, _ end: Double) -> [Double] {
            var result: [Double] = []
            Bezier.droots(self.b0, self.b1, self.b2, self.b3, closure: {
                guard $0 >= start, $0 <= end else { return }
                result.append($0)
            })
            return result
        }
        
    }
    
    struct Four : IBernsteinPolynomial {
        
        typealias LowerOrderPolynomial = Three
        
        var b0: Double
        var b1: Double
        var b2: Double
        var b3: Double
        var b4: Double
        var order: Int {
            return 4
        }
        var coefficients: [Double] {
            return [ self.b0, self.b1, self.b2, self.b3, self.b4 ]
        }
        
        init(_ b0: Double, _ b1: Double, _ b2: Double, _ b3: Double, _ b4: Double) {
            self.b0 = b0
            self.b1 = b1
            self.b2 = b2
            self.b3 = b3
            self.b4 = b4
        }
        
        func difference(a1: Double, a2: Double) -> LowerOrderPolynomial {
            return LowerOrderPolynomial(
                a1 * self.b0 + a2 * self.b1,
                a1 * self.b1 + a2 * self.b2,
                a1 * self.b2 + a2 * self.b3,
                a1 * self.b3 + a2 * self.b4
            )
        }
        
    }
    
    struct Five : IBernsteinPolynomial {
        
        typealias LowerOrderPolynomial = Four
        
        var b0: Double
        var b1: Double
        var b2: Double
        var b3: Double
        var b4: Double
        var b5: Double
        var order: Int {
            return 5
        }
        var coefficients: [Double] {
            return [ self.b0, self.b1, self.b2, self.b3, self.b4, self.b5 ]
        }
        
        init(_ b0: Double, _ b1: Double, _ b2: Double, _ b3: Double, _ b4: Double, _ b5: Double) {
            self.b0 = b0
            self.b1 = b1
            self.b2 = b2
            self.b3 = b3
            self.b4 = b4
            self.b5 = b5
        }
        
        func difference(a1: Double, a2: Double) -> LowerOrderPolynomial {
            return LowerOrderPolynomial(
                a1 * self.b0 + a2 * self.b1,
                a1 * self.b1 + a2 * self.b2,
                a1 * self.b2 + a2 * self.b3,
                a1 * self.b3 + a2 * self.b4,
                a1 * self.b4 + a2 * self.b5
            )
        }
        
    }
    
}

extension BernsteinPolynomial {
    
    static func findDistinctRoots< Polynomial : IBernsteinPolynomial >(of polynomial: Polynomial, start: Double = 0, end: Double = 1) -> [Double] {
        if let analyticalRoots = polynomial as? IBernsteinPolynomialAnalyticalRoots {
            return analyticalRoots.distinct(start, end)
        }
        let derivative = polynomial.derivative
        let criticalPoints = findDistinctRoots(of: derivative, start: start, end: end)
        let intervals = [start] + criticalPoints + [end]
        var lastFoundRoot: Double?
        let roots = (0 ..< intervals.count - 1).compactMap({ i -> Double? in
            let start = intervals[i]
            let end = intervals[i + 1]
            let fStart = polynomial.value(at: start)
            let fEnd = polynomial.value(at: end)
            let root: Double
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
    
    static func findRootBisection< Polynomial : IBernsteinPolynomial >(of polynomial: Polynomial, start: Double = 0, end: Double = 1) -> Double {
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
    
    static func newton< Polynomial : IBernsteinPolynomial >(of polynomial: Polynomial, derivative: Polynomial.LowerOrderPolynomial, guess: Double, _ relaxation: Double = 1) -> Double {
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
    
}
