/// A type to encapsulate a read/write lock.
///
public final class ReadWriteLock: Sendable {

    private let _lock: _ReadWriteLock

    /// Initialise a read/write lock.
    ///
    public init() {
        self._lock = _PThreadRWLock()
    }

    /// Locks itself to read.
    ///
    public func lock(to _: Read) {
        self._lock.lockRead()
    }

    /// Locks itself to write.
    ///
    public func lock(to _: Write) {
        self._lock.lockWrite()
    }

    /// Locks itself to read if is not locked to write already.
    ///
    public func tryLock(to _: Read) -> Bool {
        return self._lock.tryLockRead()
    }

    /// Locks itself to read if is not locked to read or write already.
    ///
    public func tryLock(to _: Write) -> Bool {
        return self._lock.tryLockWrite()
    }

    /// Unlocks itself.
    ///
    public func unlock() {
        self._lock.unlock()
    }
}

extension ReadWriteLock {

    public enum Read {

        case read
    }

    public enum Write {

        case write
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

    @inlinable
    public func withLock(to _: Read, _ body: () throws -> Void) rethrows {
        self.lock(to: .read)
        defer {
            self.unlock()
        }
        try body()
    }

    @inlinable
    public func withLock(to _: Write, _ body: () throws -> Void) rethrows {
        self.lock(to: .write)
        defer {
            self.unlock()
        }
        try body()
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
extension ReadWriteLock {

    @inlinable
    public func withLock<T>(to _: Read, _ body: @Sendable () async throws -> T) async rethrows -> T {
        self.lock(to: .read)
        defer {
            self.unlock()
        }
        return try await body()
    }

    @inlinable
    public func withLock<T>(to _: Write, _ body: @Sendable () async throws -> T) async rethrows -> T {
        self.lock(to: .write)
        defer {
            self.unlock()
        }
        return try await body()
    }

    @inlinable
    public func withLock(to _: Read, _ body: @Sendable () async throws -> Void) async rethrows {
        self.lock(to: .read)
        defer {
            self.unlock()
        }
        try await body()
    }

    @inlinable
    public func withLock(to _: Write, _ body: @Sendable () async throws -> Void) async rethrows {
        self.lock(to: .write)
        defer {
            self.unlock()
        }
        try await body()
    }
}
