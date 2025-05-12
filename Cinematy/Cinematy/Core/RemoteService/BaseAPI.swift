//
//  BaseAPI.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//


import Foundation
import Alamofire

class BaseAPI<T: TargetType> {

    func fetchData<M: Decodable>(
        target: T,
        responseClass: M.Type,
        completion: @escaping (Result<M, NSError>) -> Void
    ) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let (parameters, encoding) = buildParams(task: target.task)
        let url = target.baseURL + target.path

        print("📦 URL: \(url)")
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                let statusCode = response.response?.statusCode ?? 0

                switch response.result {
                case .success(let data):
                    // Try to deserialize JSON
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: Localize.General.genericError])
                        print("❌ Failed to get JSON response")
                        completion(.failure(error))
                        return
                    }

                    // Serialize JSON back to Data (clean step for decoding)
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                        let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: Localize.General.genericError])
                        print("❌ Failed to convert JSON to Data")
                        completion(.failure(error))
                        return
                    }

                    // Decode final object
                    do {
                        let decodedObject = try JSONDecoder().decode(M.self, from: jsonData)
                        print("✅ Success decoding API Response")
                        print("📦 ✅ Response: \(decodedObject)")
                        completion(.success(decodedObject))
                    } catch {
                        print("❌ JSON decoding error: \(error)")
                        let decodingError = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: Localize.General.genericError])
                        completion(.failure(decodingError))
                    }

                case .failure(let error):
                    let nsError: NSError
                    if (error.isSessionTaskError || statusCode == 0) {
                        nsError = NSError(domain: url, code: statusCode, userInfo: [
                            NSLocalizedDescriptionKey: Localize.General.noInternetConnection
                        ])
                    } else {
                        nsError = NSError(domain: url, code: statusCode, userInfo: [
                            NSLocalizedDescriptionKey: Localize.General.genericError
                        ])
                    }

                    print("❌ Network Failure: \(error)")
                    completion(.failure(nsError))
                }
            }
    }

    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(let parameters, let encoding):
            return (parameters, encoding)
        }
    }

    func cancelAnyRequest() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}
