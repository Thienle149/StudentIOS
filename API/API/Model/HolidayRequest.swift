//
//  HolidayRequest.swift
//  API
//
//  Created by thienle on 1/30/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
enum HolidayError:Error {
	case noDataAvailable
	case canNotProcessData
}

struct HolidayRequest {
	let resourceURL: URL
	let API_KEY = "5d7b2dadaad630d93c263543102e4101156d9f7e"
	
	init(countryCode: String) {
		
		let date = Date()
		let format = DateFormatter()
		format.dateFormat = "yyyy"
		let currentYear = format.string(from: date)
		
		let resourceString = "https://calendarific.com/api/v2/holidays?&api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
		guard let resourceURL = URL(string: resourceString) else { fatalError() }
		
		self.resourceURL = resourceURL
	}
	
	func getHolidays(completion: @escaping(Result<[HolidayDetail], HolidayError>) -> Void) {
		let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
			guard let jsonData = data else {
				completion(.failure(.noDataAvailable))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
				let holidayDetails = holidayResponse.response.holidays
				completion(.success(holidayDetails))
			} catch {
				completion(.failure(.canNotProcessData))
			}
		}
		dataTask.resume()
	}
}
