/// A type to encapsulate an unfair lock.
///
public final class Lock {

    private let _lock: _Lock

    /// Initialise an unfair lock.
    ///
    public init() {
        if #available(iOS 10, macOS 10.12, tvOS 10, watchOS 3, *) {
            if _OSUnfairLock.isAvailable {
                self._lock = _OSUnfairLock()
            }
            else {
                self._lock = _PThreadMutex()
            }
        }
        else {
            self._lock = _PThreadMutex()
        }
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
        self._lock.unlock()
    }
}

extension Lock: _Lock {
}
