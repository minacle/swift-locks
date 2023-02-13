internal protocol _RecursiveLock: AnyObject, Sendable {

    init()

    func lock()
    func tryLock() -> Bool
    func unlock()
}
