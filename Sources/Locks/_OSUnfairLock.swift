#if canImport(Darwin)
import Darwin

@available(iOS 10, macOS 10.12, tvOS 10, watchOS 3, *)
internal final class _OSUnfairLock: _Lock {

    internal class var isAvailable: Bool {
        return true
    }

    private let _lock: os_unfair_lock_t

    internal init() {
        self._lock = .allocate(capacity: 1)
        self._lock.initialize(to: os_unfair_lock())
    }

    deinit {
        self._lock.deinitialize(count: 1)
        self._lock.deallocate()
    }

    internal func lock() {
        os_unfair_lock_lock(self._lock)
    }

    internal func tryLock() -> Bool {
        return os_unfair_lock_trylock(self._lock)
    }

    internal func unlock() {
        os_unfair_lock_unlock(self._lock)
    }
}
#elseif canImport(Glibc)
internal final class _OSUnfairLock: _Lock {

    internal class var isAvailable: Bool {
        return false
    }

    internal init() {
    }

    internal func lock() {
    }

    internal func tryLock() -> Bool {
        return false
    }

    internal func unlock() {
    }
}
#else
#error("Unsupported platform")
#endif
