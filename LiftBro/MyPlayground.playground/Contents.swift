//: Playground - noun: a place where people can play

import UIKit

public var dateWithoutTime : Date{
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .medium
    let dateString = dateFormatter.string(from: Date())
    
    return dateFormatter.date(from: dateString)!
}


let xx = dateWithoutTime


