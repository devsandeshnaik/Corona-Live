//
//  DailyStatus.swift
//  Corona
//
//  Created by Sandesh on 25/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation

struct DailyStatus: Codable {
    var date: String
    var confirmed: Int
    var deaths: Int
    var recoverd: Int?
}
