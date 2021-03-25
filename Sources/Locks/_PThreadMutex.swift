#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif

internal final class _PThreadMutex: _Lock {

    private let _lock: UnsafeMutablePointer<pthread_mutex_t>

    internal init() {
        self._lock = .allocate(capacity: 1)
        pthread_mutex_init(self._lock, nil)
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