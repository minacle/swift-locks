/// A property wrapper type that can read and write a lock managed
/// value.
@frozen
@propertyWrapper
public struct LockManaged<Value> {

    private var _value: Value
    private let _lock: ValueManageableLock

    /// The lock managed value.
    public var wrappedValue: Value {
        get {
            if Value.self is AnyClass {
                return self._lock.withLock {
                    self._value
                }
            }
            else {
                return self._lock.withLock(to: .read) {
                    self._value
                }
            }
        }
        set {
            self._lock.withLock(to: .write) {
                self._value = newValue
            }
        }
    }

    /// The lock unmanaged value.
    ///
    /// - Warning:
    ///   Lock unmanaged means that it is thread unsafe.
    public var projectedValue: Value {
        get {
            return self._value
        }
        set {
            self._value = newValue
        }
    }

    /// Creates a locked value managed by an appropriate lock with an
    /// initial value.
    ///
    /// In default, uses `ReadWriteLock` to manage a value. If the given
    /// value is a class instance, uses `Lock` instead.
    ///
    /// - Parameters:
    ///   - value:
    ///     The initial value.
    public init(wrappedValue value: Value) {
        self._value = value
        if Value.self is AnyClass {
            self._lock = Lock()
        }
        else {
            self._lock = ReadWriteLock()
        }
    }

    /// Creates a locked value managed by `Lock` with an initial value.
    ///
    /// - Parameters:
    ///   - value:
    ///     The initial value.
    ///   - lock:
    ///     The lock to manage value.
    public init(wrappedValue value: Value, lock: Lock) {
        self._value = value
        self._lock = lock
    }

    /// Creates a locked value managed by `ReadWriteLock` with an
    /// initial value.
    ///
    /// - Parameters:
    ///   - value:
    ///     The initial value.
    ///   - lock:
    ///     The lock to manage value.
    public init(wrappedValue value: Value, lock: ReadWriteLock) {
        self._value = value
        self._lock = lock
    }

    /// Creates a locked value managed by `RecursiveLock` with an
    /// initial value.
    ///
    /// - Parameters:
    ///   - value:
    ///     The initial value.
    ///   - lock:
    ///     The lock to manage value.
    public init(wrappedValue value: Value, lock: RecursiveLock) {
        self._value = value
        self._lock = lock
    }
}

extension LockManaged
where Value: ExpressibleByNilLiteral {

    /// Creates a locked value managed by an appropriate lock without an
    /// initial value.
    ///
    /// In default, uses `ReadWriteLock` to manage a value. If the given
    /// value is a class instance, uses `Lock` instead.
    public init() {
        self._value = nil
        if Value.self is AnyClass {
            self._lock = Lock()
        }
        else {
            self._lock = ReadWriteLock()
        }
    }

    /// Creates a locked value managed by `Lock` without an initial
    /// value.
    ///
    /// - Parameters:
    ///   - lock:
    ///     The lock to manage value.
    public init(lock: Lock) {
        self._value = nil
        self._lock = lock
    }

    /// Creates a locked value managed by `ReadWriteLock` without an
    /// initial value.
    ///
    /// - Parameters:
    ///   - lock:
    ///     The lock to manage value.
    public init(lock: ReadWriteLock) {
        self._value = nil
        self._lock = lock
    }

    /// Creates a locked value managed by `RecursiveLock` without an
    /// initial value.
    ///
    /// - Parameters:
    ///   - lock:
    ///     The lock to manage value.
    public init(lock: RecursiveLock) {
        self._value = nil
        self._lock = lock
    }
}

@usableFromInline
internal protocol ValueManageableLock {

    func withLock<T>(_ body: () throws -> T) rethrows -> T
    func withLock<T>(to _: ReadWriteLock.Read, _ body: () throws -> T) rethrows -> T
    func withLock<T>(to _: ReadWriteLock.Write, _ body: () throws -> T) rethrows -> T
}

extension Lock: ValueManageableLock {

    @_transparent
    @usableFromInline
    internal func withLock<T>(to _: ReadWriteLock.Read, _ body: () throws -> T) rethrows -> T {
        return try self.withLock(body)
    }

    @_transparent
    @usableFromInline
    internal func withLock<T>(to _: ReadWriteLock.Write, _ body: () throws -> T) rethrows -> T {
        return try self.withLock(body)
    }
}

extension ReadWriteLock: ValueManageableLock {

    @_transparent
    @usableFromInline
    internal func withLock<T>(_ body: () throws -> T) rethrows -> T {
        return try self.withLock(to: .write, body)
    }
}

extension RecursiveLock: ValueManageableLock {

    @_transparent
    @usableFromInline
    internal func withLock<T>(to _: ReadWriteLock.Read, _ body: () throws -> T) rethrows -> T {
        return try self.withLock(body)
    }

    @_transparent
    @usableFromInline
    internal func withLock<T>(to _: ReadWriteLock.Write, _ body: () throws -> T) rethrows -> T {
        return try self.withLock(body)
    }
}
