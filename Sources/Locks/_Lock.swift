internal protocol _Lock: AnyObject, Sendable {

    init()
    
    func lock()
    func tryLock() -> Bool
    func unlock()
}
