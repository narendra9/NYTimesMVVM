//
//  Notification.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let startTimer = Notification.Name("startTimer")
    static let endTimer = Notification.Name("endTimer")
    static let bidUpdate = Notification.Name("bidUpdate")
    static let sessionExpired = Notification.Name("sessionExpired")
    static let paymentUpdate = Notification.Name("paymentUpdate")
    static let bidCountUpdate = Notification.Name("bidCountUpdate")
}
