/// A type to encapsulate a recursive lock.
///
public final class RecursiveLock: Sendable {

    private let _lock: _RecursiveLock

    /// Initialise a recursive lock.
    ///
    public init() {
        self._lock = _PThreadRecursiveMutex()
    }

    /// Locks itself.
    ///
    public func lock() {
        self._lock.lock()
    }

    /// Locks itself if is not locked already.
    ///
    public func tryLock() -> Bool {
        return self._lock.tryLock()
    }

    /// Unlocks itself.
    ///
    public func unlock() {
        return self._lock.unlock()
    }
}

extension RecursiveLock {

    @inlinable
    public func withLock<T>(_ body: () throws -> T) rethrows -> T {
        self.lock()
        defer {
            self.unlock()
        }
        return try body()
    }

    @inlinable
    public func withLock(_ body: () throws -> Void) rethrows {
        self.lock()
        defer {
            self.unlock()
        }
        try body()
    }
}
