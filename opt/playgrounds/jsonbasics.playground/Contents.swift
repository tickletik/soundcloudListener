//: Playground - noun: a place where people can play

import UIKit

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!

let query: [String: String] = [
    "api_key": "DEMO_KEY",
]

struct PhotoInfo {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
}

let url = baseURL.withQueries(query)!
let task = URLSession.shared.dataTask(with: url) { (data,
    response, error) in
    
    let jsonDecoder = JSONDecoder()
    
    if let data = data,
        let photoDict = try? jsonDecoder.decode([String:String].self, from: data),
        let _ = String(data: data, encoding: .utf8) {
        
        
        print(photoDict)
    }
}
task.resume()


