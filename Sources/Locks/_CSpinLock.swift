@_implementationOnly
import CSpinLock

internal final class _CSpinLock: _SpinLock {

    private let _lock: cspinlock_t

    internal init() {
        self._lock = .allocate(capacity: 1)
        cspinlock_init(self._lock)
    }

    deinit {
        cspinlock_deinit(self._lock)
    }

    internal func lock() {
        cspinlock_lock(self._lock)
    }

    func unlock() {
        cspinlock_unlock(self._lock)
    }
}
