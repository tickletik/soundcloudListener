//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

enum Cover {
    case named(String)
    case url(URL)
    
    func value() -> Any {
        switch self {
        case .named(let value):
            return value
        case .url(let value):
            return value
        }
    }
}

let valnamed = Cover.named("blah")
let valurl = Cover.url(URL(string: "http://google.com")!)

let name = valnamed.value()
print(name)

let url = valurl.value()
print(url)


