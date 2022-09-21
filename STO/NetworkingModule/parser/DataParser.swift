//
//  DataParser.swift
//  STO
//
//  Created by Taras Spasibov on 01.06.2022.
//

import Foundation

public protocol DataParserProtocol {
  func parse<T: Decodable>(data: Data) throws -> T
}

public class DataParser: DataParserProtocol {
  private var jsonDecoder: JSONDecoder

  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
//    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  public func parse<T: Decodable>(data: Data) throws -> T {
      do {
          return try jsonDecoder.decode(T.self, from: data)
      } catch {
          throw NetworkError.invalidParseResponse(error.localizedDescription)
      }
  }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
}
