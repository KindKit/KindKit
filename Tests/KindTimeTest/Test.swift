//
//  KindKit-Test
//

import XCTest
import KindTime

class Test : XCTestCase {
    
    func test() throws {
        do {
            XCTAssert(DaysInterval(1) == HoursInterval(24))
            XCTAssert(DaysInterval(1.0) == HoursInterval(24.0))
            
            XCTAssert(1.days == 24.hours)
            XCTAssert(1.0.days == 24.0.hours)
            
            XCTAssert(1.days == 24.hours.inDays)
        }
        do {
            XCTAssert(HoursInterval(1) == MinutesInterval(60))
            XCTAssert(HoursInterval(1.0) == MinutesInterval(60.0))
            
            XCTAssert(1.hours == 60.minutes)
            XCTAssert(1.0.hours == 60.0.minutes)
            
            XCTAssert(1.hours == 60.minutes.inHours)
        }
        do {
            XCTAssert(MinutesInterval(1) == SecondsInterval(60))
            XCTAssert(MinutesInterval(1.0) == SecondsInterval(60.0))
            
            XCTAssert(1.minutes == 60.seconds)
            XCTAssert(1.0.minutes == 60.0.seconds)
            
            XCTAssert(1.minutes == 60.seconds.inMinutes)
        }
        do {
            XCTAssert(SecondsInterval(1) == MillisecondsInterval(1000))
            XCTAssert(SecondsInterval(1.0) == MillisecondsInterval(1000.0))
            
            XCTAssert(1.seconds == 1000.milliseconds)
            XCTAssert(1.0.seconds == 1000.0.milliseconds)
            
            XCTAssert(1.seconds == 1000.milliseconds.inSeconds)
        }
        do {
            XCTAssert(MillisecondsInterval(1) == MicrosecondsInterval(1000))
            XCTAssert(MillisecondsInterval(1.0) == MicrosecondsInterval(1000.0))
            
            XCTAssert(1.milliseconds == 1000.microseconds)
            XCTAssert(1.0.milliseconds == 1000.0.microseconds)
            
            XCTAssert(1.milliseconds == 1000.microseconds.inMilliseconds)
        }
        do {
            XCTAssert(MicrosecondsInterval(1) == NanosecondsInterval(1000))
            XCTAssert(MicrosecondsInterval(1.0) == NanosecondsInterval(1000.0))
            
            XCTAssert(1.microseconds == 1000.nanoseconds)
            XCTAssert(1.0.microseconds == 1000.0.nanoseconds)
            
            XCTAssert(1.microseconds == 1000.nanoseconds.inMicroseconds)
        }
        do {
            XCTAssert(SecondsInterval(1) > MillisecondsInterval(999))
            XCTAssert(SecondsInterval(1) < MillisecondsInterval(1001))
        }
        do {
            XCTAssert(SecondsInterval(1) == MillisecondsInterval(800) + MillisecondsInterval(200))
            XCTAssert(SecondsInterval(1) == MillisecondsInterval(1200) - MillisecondsInterval(200))
            XCTAssert(SecondsInterval(1) == MillisecondsInterval(2000) * SecondsInterval(0.5))
            XCTAssert(SecondsInterval(1) == MillisecondsInterval(500) * MillisecondsInterval(2))
        }
    }
    
}
