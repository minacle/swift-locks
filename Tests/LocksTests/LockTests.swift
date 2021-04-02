import XCTest

@testable
import Locks

final class LockTests: XCTestCase {

    private let operationQueue = OperationQueue()

    private func job(lock: _Lock?) -> (Int, Int) {
        let range = 1 ... 100
        let correctAnswer = range.reduce(0, +)
        var value = 0
        var operations = [Operation]()
        for i in range {
            let operation: Operation
            if let lock = lock {
                operation = BlockOperation {
                    lock.lock()
                    var n = 0
                    for j in 0 ..< Int.random(in: 100 ..< 200) {
                        n += j
                    }
                    value += n
                    value += i
                    value -= n
                    lock.unlock()
                }
            }
            else {
                operation = BlockOperation {
                    var n = 0
                    for j in 0 ..< Int.random(in: 100 ..< 200) {
                        n += j
                    }
                    value += n
                    value += i
                    value -= n
                }
            }
            operations.append(operation)
        }
        self.operationQueue.addOperations(operations, waitUntilFinished: true)
        return (value, correctAnswer)
    }

    @available(iOS 10, macOS 10.12, tvOS 10, watchOS 3, *)
    func testOSUnfairLock() throws {
        try XCTSkipUnless(_OSUnfairLock.isAvailable, "OSUnfairLock is unavailable")
        for _ in 0 ..< 100 {
            let (value, correctAnswer) = self.job(lock: _OSUnfairLock())
            XCTAssertEqual(value, correctAnswer)
        }
    }

    func testPThreadMutex() {
        for _ in 0 ..< 100 {
            let (value, correctAnswer) = self.job(lock: _PThreadMutex())
            XCTAssertEqual(value, correctAnswer)
        }
    }
}
