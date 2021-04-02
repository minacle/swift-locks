internal protocol _ReadWriteLock: AnyObject {

    init()

    func lockRead()
    func lockWrite()
    func tryLockRead() -> Bool
    func tryLockWrite() -> Bool
    func unlock()
}
