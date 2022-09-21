//
//  TestRepository.swift
//  STO
//
//  Created by Taras Spasibov on 16.06.2022.
//

import Combine

final class TestRepository {
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Methods
    init(networkManager: NetworkManagerProtocol = RequestManager()) {
        self.networkManager = networkManager
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension TestRepository {
    func test() -> AnyPublisher<Void, ErrorMessage> {
        networkManager
            .execute(TestRequest.test)
            .eraseToAnyPublisher()
    }
}
