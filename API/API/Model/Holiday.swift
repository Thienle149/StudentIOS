//
//  Holiday.swift
//  API
//
//  Created by thienle on 1/30/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation

struct HolidayResponse: Decodable {
	var response: Holiday
}

struct Holiday: Decodable {
	var holidays: [HolidayDetail]
}

struct HolidayDetail: Decodable {
	var name: String
	var date: DateInfo
}

struct DateInfo: Decodable {
	var iso: String
}
