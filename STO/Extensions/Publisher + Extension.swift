//
//  Publisher + Extension.swift
//  STO
//
//  Created by Taras Spasibov on 02.06.2022.
//

import Combine

extension Publisher {
    func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        compactMap { $0 }
    }
    
    func progress(isExecuting: PassthroughSubject<Bool, Never>) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveSubscription: { _ in
            isExecuting.send(true)
        }, receiveCompletion: { _ in
            isExecuting.send(false)
        })
    }
    
    func then(_ completion: @escaping (Output) -> ()) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: completion)
    }
}

extension Publisher where Self.Failure == ErrorMessage {
    func bind(onSuccess: @escaping (Output) -> (), onError: ((Failure) -> Void)? = nil, onCompletion: (() -> Void)? = nil) -> AnyCancellable {
        sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error): onError?(error)
            case .finished: onCompletion?()
            }
        }, receiveValue: onSuccess)
    }
}
