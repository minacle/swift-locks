internal protocol _ConditionLock: AnyObject {

    var value: _AnyEquatable {get}

    init<T>(value: T) where T: Equatable

    func lock()
    func unlock()

    func lock<T>(whenValue wantedValue: T) where T: Equatable
    func unlock<T>(withValue newValue: T) where T: Equatable
}
