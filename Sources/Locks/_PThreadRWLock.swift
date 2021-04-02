#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif

internal final class _PThreadRWLock: _ReadWriteLock {

    private let _lock: UnsafeMutablePointer<pthread_rwlock_t>

    internal init() {
        self._lock = .allocate(capacity: 1)
        pthread_rwlock_init(self._lock, nil)
    }

    deinit {
        pthread_rwlock_destroy(self._lock)
        self._lock.deallocate()
    }

    internal func lockRead() {
        pthread_rwlock_rdlock(self._lock)
    }

    internal func lockWrite() {
        pthread_rwlock_wrlock(self._lock)
    }

    internal func tryLockRead() -> Bool {
        return pthread_rwlock_tryrdlock(self._lock) == 0
    }

    internal func tryLockWrite() -> Bool {
        return pthread_rwlock_trywrlock(self._lock) == 0
    }

    internal func unlock() {
        pthread_rwlock_unlock(self._lock)
    }
}
