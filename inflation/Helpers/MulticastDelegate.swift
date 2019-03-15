//
//  MulticastDelegate.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

final class MulticastDelegate <T> {
    private var weakDelegates = [WeakWrapper]()
    
    func addDelegate(delegate: T) {
        weakDelegates.append(WeakWrapper(value: delegate as AnyObject))
    }
    
    func removeDelegate(delegate: T) {
        for (index, delegateInArray) in weakDelegates.enumerated().reversed() {
            if delegateInArray.value === (delegate as AnyObject) {
                weakDelegates.remove(at: index)
            }
        }
    }
    
    func invoke(invocation: (T) -> Void) {
        for (index, delegate) in weakDelegates.enumerated().reversed() {
            if let delegate = delegate.value {
                invocation(delegate as! T)
            } else {
                weakDelegates.remove(at: index)
            }
        }
    }
}

func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.addDelegate(delegate: right)
}

func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.removeDelegate(delegate: right)
}

private class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
