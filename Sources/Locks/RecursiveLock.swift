/// A type to encapsulate a recursive lock.
///
public final class RecursiveLock {

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

extension RecursiveLock: _RecursiveLock {
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
}
