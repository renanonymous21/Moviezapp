//
//  ServiceProtocol.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

protocol RequestBuilder: class {
    associatedtype UseCases: HttpProtocol
}

class APIManager<UseCases: HttpProtocol>: RequestBuilder {
    class func request<T: Codable>(_ usecase: UseCases, completion: @escaping (Result<T, RuntimeError>) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: usecase.request) {
            data, response, error in
            
            if let error = error {
                print("REQUEST ERROR: ", error)
                completion(.failure(RuntimeError(error.localizedDescription)))
            }
            guard response != nil,
                  let responseData = data
            else {
                return
            }
            
            do {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 && response.statusCode != 422 {
                        let responseObject = try JSONDecoder().decode(ResponseErrorModel.self, from: responseData)
                        DispatchQueue.main.async {
                            completion(.failure(RuntimeError(responseObject.message)))
                        }
                    } else {
                        let responseObjects = try JSONDecoder().decode(T.self, from: responseData)
                        DispatchQueue.main.async {
                            completion(.success(responseObjects))
                        }
                    }
                }
            } catch {
                print("ERROR PARSING: ", error)
            }
        }
        task.resume()
    }
}
