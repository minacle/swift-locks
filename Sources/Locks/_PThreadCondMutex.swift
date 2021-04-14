#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif

internal final class _PThreadCondMutex: _ConditionLock {

    private var _value: _AnyEquatable

    private let _cond: UnsafeMutablePointer<pthread_cond_t>
    private let _lock: UnsafeMutablePointer<pthread_mutex_t>

    internal var value: _AnyEquatable {
        self.lock()
        defer {
            self.unlock()
        }
        return self._value
    }

    internal init<T>(value: T)
    where T: Equatable {
        self._value = .init(value)
        self._lock = .allocate(capacity: 1)
        self._cond = .allocate(capacity: 1)
        pthread_mutex_init(self._lock, nil)
        pthread_cond_init(self._cond, nil)
    }

    deinit {
        pthread_cond_destroy(self._cond)
        pthread_mutex_destroy(self._lock)
        self._cond.deallocate()
        self._lock.deallocate()
    }

    internal func lock() {
        pthread_mutex_lock(self._lock)
    }

    internal func unlock() {
        pthread_mutex_unlock(self._lock)
    }

    internal func lock<T>(whenValue wantedValue: T)
    where T: Equatable {
        self.lock()
        while self._value != wantedValue {
            pthread_cond_wait(self._cond, self._lock)
        }
    }

    internal func unlock<T>(withValue newValue: T)
    where T: Equatable {
        self._value = .init(newValue)
        self.unlock()
        pthread_cond_broadcast(self._cond)
    }
}
