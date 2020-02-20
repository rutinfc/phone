//
//  DialpadView+Rx.swift
//  phone
//
//  Created by rutinfc on 2020/02/20.
//  Copyright © 2020 rutinfc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxDialpadNumberDelegateProxy : DelegateProxy<DialpadView, DialpadViewDelegate>, DialpadViewDelegate, DelegateProxyType {
    
    static func registerKnownImplementations() {
        RxDialpadNumberDelegateProxy.register {RxDialpadNumberDelegateProxy(parentObject: $0, delegateProxy: self)}
    }
    
    static func currentDelegate(for object: DialpadView) -> DialpadViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: DialpadViewDelegate?, to object: DialpadView) {
        object.delegate = delegate
    }
}

extension Reactive where Base:DialpadView {
    
    public var delegate : DelegateProxy<DialpadView, DialpadViewDelegate> {
        return RxDialpadNumberDelegateProxy.proxy(for: self.base)
    }
    
    public func setDelegate(_ delegate:DialpadViewDelegate) -> Disposable {
        return RxDialpadNumberDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    public var didChangeNumber : ControlEvent<String> {
        let source = self.delegate.methodInvoked(#selector(DialpadViewDelegate.didUpdate)).map { parameters in
            return (parameters[0] as? String) ?? ""
        }
        
        return ControlEvent(events: source)
    }
    
}
