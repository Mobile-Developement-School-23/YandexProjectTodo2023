//
//  NW.swift
//  YandexProjectTodo2023
//
//  Created by Дмитрий Гусев on 02.07.2023.
//

import Foundation


enum RequestProcessor {
    static func makeUrl() throws -> URL {  let url = URL(string: "https://beta.mrdekk.ru/todobackend/list")
        return url ?? URL.downloadsDirectory
  }

  static func performMyAwesomeRequest(
    urlSession: URLSession = .shared,
    url: URL
  ) async throws -> (Data, HTTPURLResponse) {
      var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
      request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
      request.httpMethod = "GET"
      
      
    let (data, response) = try await urlSession.data(for: request)
    guard let response = response as? HTTPURLResponse else {
      throw RequestProcessorError.unexpectedResponse(response)
    }
    guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
      throw RequestProcessorError.failedResponse(response)
    }

    return (data, response)
  }

  private static let httpStatusCodeSuccess = 200..<300
}

enum RequestProcessorError: Error {
  case wrongUrl(URLComponents)
  case unexpectedResponse(URLResponse)
  case failedResponse(HTTPURLResponse)
}
