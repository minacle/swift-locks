#if canImport(Darwin)
@_implementationOnly
import Darwin
#elseif canImport(Glibc)
@_implementationOnly
import Glibc
#else
#error("Unsupported platform")
#endif

internal final class _PThreadRecursiveMutex: _RecursiveLock {

    private let _lock: UnsafeMutablePointer<pthread_mutex_t>

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

    internal func lock() {
        pthread_mutex_lock(self._lock)
    }

    internal func tryLock() -> Bool {
        return pthread_mutex_trylock(self._lock) == 0
    }

    internal func unlock() {
        pthread_mutex_unlock(self._lock)
    }
}
