//
//  NetworkService.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import Foundation

class NetworkService {

    let urlString = "https://data.nasa.gov/resource/y77d-th95.json"

    func fetchMeteorsData(completion: @escaping ([MeteorModel]?, Error?) -> ()) {

        guard let url = URL(string: urlString) else {

            completion(nil, AppErrors.urlInvalid)

            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

            if let data = data {
                do {
                    let meteors = try jsonDecoder.decode([MeteorModel].self, from: data)

                    completion(meteors, nil)

                } catch {
                    print(error)

                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }.resume()
    }
}


enum AppErrors: Error {

    case urlInvalid

    // add more errors here...

    // Throw in all other cases
    case unexpected(code: Int)
}


extension AppErrors: CustomStringConvertible {

    public var description: String {
        switch self {
        case .urlInvalid:
            return "The provided url is not valid."

        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}
