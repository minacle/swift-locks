public final class SpinLock {

    private let _lock: _SpinLock

    public init() {
        self._lock = _CSpinLock()
    }

    public func lock() {
        self._lock.lock()
    }

    public func unlock() {
        self._lock.unlock()
    }
}
