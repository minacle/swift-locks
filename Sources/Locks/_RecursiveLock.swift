internal protocol _RecursiveLock: AnyObject {

    init()

    func lock()
    func tryLock() -> Bool
    func unlock()
}
