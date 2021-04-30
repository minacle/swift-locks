internal protocol _SpinLock: AnyObject {

    init()

    func lock()
    func unlock()
}
