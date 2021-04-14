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
    @available(*, deprecated, renamed: "lock(to:)")
    public func lockRead() {
        self._lock.lockRead()
    }

    /// Locks itself to write.
    ///
    @available(*, deprecated, renamed: "lock(to:)")
    public func lockWrite() {
        self._lock.lockWrite()
    }

    /// Locks itself to read if is not locked to write already.
    ///
    @available(*, deprecated, renamed: "tryLock(to:)")
    public func tryLockRead() -> Bool {
        return self._lock.tryLockRead()
    }

    /// Locks itself to read if is not locked to read or write already.
    ///
    @available(*, deprecated, renamed: "tryLock(to:)")
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

extension ReadWriteLock {

    public enum Read {

        case read
    }

    public enum Write {

        case write
    }

    public func lock(to _: Read) {
        self._lock.lockRead()
    }

    public func lock(to _: Write) {
        self._lock.lockWrite()
    }

    public func tryLock(to _: Read) -> Bool {
        return self._lock.tryLockRead()
    }

    public func tryLock(to _: Write) -> Bool {
        return self._lock.tryLockWrite()
    }

    @inlinable
    public func withLock<T>(to _: Read, _ body: () throws -> T) rethrows -> T {
        self.lock(to: .read)
        defer {
            self.unlock()
        }
        return try body()
    }

    @inlinable
    public func withLock<T>(to _: Write, _ body: () throws -> T) rethrows -> T {
        self.lock(to: .write)
        defer {
            self.unlock()
        }
        return try body()
    }
}
