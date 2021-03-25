#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

/// A type to encapsulate a recursive lock.
///
internal final class _PThreadRecursiveMutex: _RecursiveLock {

    private let _lock: UnsafeMutablePointer<pthread_mutex_t>

    /// Initialise a recursive lock.
    ///
    internal init() {
        self._lock = .allocate(capacity: 1)
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(self._lock, &attr)
    }

    deinit {
        pthread_mutex_destroy(self._lock)
        self._lock.deallocate()
    }

    /// Locks itself.
    ///
    internal func lock() {
        pthread_mutex_lock(self._lock)
    }

    /// Locks itself if is not locked already.
    ///
    internal func tryLock() -> Bool {
        return pthread_mutex_trylock(self._lock) == 0
    }

    /// Unlocks itself.
    ///
    internal func unlock() {
        pthread_mutex_unlock(self._lock)
    }
}
