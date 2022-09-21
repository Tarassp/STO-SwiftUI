//
//  Optional + Extension.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        return self == nil
    }

    var isNotNil: Bool {
        !isNil
    }
    
    func valueOrElse<T>(_ value: T) -> T {
        return self.isNil ? value : self as! T
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var isNotEmpty: Bool {
        isNilOrEmpty == false
    }
}

public extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

public extension Optional where Wrapped == String {
    var isNotNilOrEmptyIncludingWhitespaces: Bool {
        !isNilOrEmptyIncludingWhitespaces
    }
    
    var isNilOrEmptyIncludingWhitespaces: Bool {
        return self?.isEmptyOrWhitespace ?? true
    }
    
    func valueOrElse(_ s: String) -> String {
        return self.isNilOrEmpty ? s : self!
    }
}
