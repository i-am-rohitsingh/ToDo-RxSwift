//
//  Task.swift
//  ToDo - RxSwift
//
//  Created by Rohit Kumar on 07/06/21.
//

import Foundation

struct Task {
    let title: String
    let priority: Priority
}

enum Priority: Int{
    case high
    case medium
    case low
}
