//
//  Enums.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    case messageError(String)
    case noData
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum AlertType:String {
    case warning = "Warning"
    case error = "Error"
    case success = "Success"
}

