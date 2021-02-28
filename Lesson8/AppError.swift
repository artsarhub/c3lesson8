//
//  AppError.swift
//  Lesson8
//
//  Created by Артём Сарана on 14.02.2021.
//

import Foundation

enum AppError: Error {
    case loginError(message: String)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loginError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
