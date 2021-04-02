/// A type to encapsulate a read/write lock.
///
public final class ReadWriteLock {

    private let _lock: _ReadWriteLock

    /// Initialise a read/write lock.
    ///
    public init() {
        self._lock = _PThreadRWLock()
    }

    /// Locks itself to read.
    ///
    public func lockRead() {
        self._lock.lockRead()
    }

    /// Locks itself to write.
    ///
    public func lockWrite() {
        self._lock.lockWrite()
    }

    /// Locks itself to read if is not locked to write already.
    ///
    public func tryLockRead() -> Bool {
        return self._lock.tryLockRead()
    }

    /// Locks itself to read if is not locked to read or write already.
    ///
    public func tryLockWrite() -> Bool {
        return self._lock.tryLockWrite()
    }

    /// Unlocks itself.
    ///
    public func unlock() {
        self._lock.unlock()
    }
}

extension ReadWriteLock: _ReadWriteLock  {
}
