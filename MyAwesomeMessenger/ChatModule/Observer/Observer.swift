//
//  Observer.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 27.03.2023.
//

import Foundation

class Observer<T> {
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    init(_ value: T) {
        self.value = value
    }
}
