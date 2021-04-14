public final class ConditionLock<Value>
where Value: Equatable {

    private let _lock: _ConditionLock

    public init(value: Value) {
        self._lock = _PThreadCondMutex(value: value)
    }

    public func lock() {
        self._lock.lock()
    }

    public func unlock() {
        self._lock.unlock()
    }

    public func lock(whenValue wantedValue: Value) {
        self._lock.lock(whenValue: wantedValue)
    }

    public func unlock(withValue newValue: Value) {
        self._lock.unlock(withValue: newValue)
    }
}
