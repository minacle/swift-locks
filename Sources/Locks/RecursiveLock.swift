/// A type to encapsulate a recursive lock.
///
public final class RecursiveLock {

    private let _lock: _RecursiveLock

    /// Initialise a recursive lock.
    ///
    internal init() {
        self._lock = _PThreadRecursiveMutex()
    }

    /// Locks itself.
    ///
    internal func lock() {
        self._lock.lock()
    }

    /// Locks itself if is not locked already.
    ///
    internal func tryLock() -> Bool {
        return self._lock.tryLock()
    }

    /// Unlocks itself.
    ///
    internal func unlock() {
        return self._lock.unlock()
    }
}

extension RecursiveLock: _RecursiveLock {
}
