//
//  NetworkWorker.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 04/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import Foundation
import Alamofire

class NetworkWorker: NSObject {
    class func getMovies(keyword: String, page: Int, completion: @escaping (MovieResponse?, Error?) -> ()) {
        AF.request(ApiRouter.getMovies(keyword, page))
        .validate()
        .responseData { response in
            
                switch response.result {
                case .success:
                    if let responseData = response.data {
                        do {
                            let movieDatas = try JSONDecoder().decode(MovieResponse.self, from: responseData)
                            completion(movieDatas, nil)
                        }
                        catch {
                            completion(nil, error)
                        }
                    }
                case let .failure(error):
                    completion(nil, error)
                }
        }
    }
}

fileprivate enum ApiRouter: URLRequestConvertible {
    
    case getMovies(String, Int)
    
    var baseUrl: String {
        switch self {
        case .getMovies:
            return "https://www.omdbapi.com"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovies:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMovies:
            return "/"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getMovies(let keyword, let page):
            return [
                "apiKey": "367ee4ae",
                "s": keyword,
                "page": page
            ]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

