internal protocol _ReadWriteLock: AnyObject, Sendable {

    init()

    func lockRead()
    func lockWrite()
    func tryLockRead() -> Bool
    func tryLockWrite() -> Bool
    func unlock()
}
