internal struct _AnyEquatable {

    private let _value: Any

    private let _testEquality: (Any) -> Bool

    internal var value: Any {
        get {
            return self._value
        }
    }

    internal init<T>(_ value: T)
    where T: Equatable {
        self._value = value
        self._testEquality = {$0 as? T == value}
    }

    internal func value<T>(as type: T.Type) -> T
    where T: Equatable {
        return self._value as! T
    }
}

extension _AnyEquatable: Equatable {

    internal static func ==(lhs: _AnyEquatable, rhs: _AnyEquatable) -> Bool {
        return lhs._testEquality(rhs._value)
    }

    internal static func !=(lhs: _AnyEquatable, rhs: _AnyEquatable) -> Bool {
        return !lhs._testEquality(rhs._value)
    }

    internal static func ==<T>(lhs: _AnyEquatable, rhs: T) -> Bool
    where T: Equatable {
        return lhs._testEquality(rhs)
    }

    internal static func !=<T>(lhs: _AnyEquatable, rhs: T) -> Bool
    where T: Equatable {
        return !lhs._testEquality(rhs)
    }
}
