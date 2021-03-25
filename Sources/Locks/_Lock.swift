internal protocol _Lock: AnyObject {

    init()
    
    func lock()
    func tryLock() -> Bool
    func unlock()
}
