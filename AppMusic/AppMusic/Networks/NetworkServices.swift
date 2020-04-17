//
//  NetworkServices.swift
//  AppMusic
//
//  Created by thienle on 3/28/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import Alamofire
protocol NetworkServiceProtocol {
	associatedtype WedServiceResponse;
	func getData(route: String, parameters: Parameters?,completion: @escaping ()-> WedServiceResponse)
	func postData()
	func putData()
	func deleteData()
}
class NetworkServices {
	typealias WedServiceResponse = ([[String: Any?]]?,Error?) -> Void
//	static let hostname = "http://192.168.100.22:3000"
	static let hostname = "http://localhost:3000"
	
	private static var instance: NetworkServices!
	
	static func getInstance() -> NetworkServices {
		if instance == nil {
			instance = NetworkServices()
		}
		return instance
	}
	
	init() {
		
	}
	
	fileprivate func excute(route: String, method: HTTPMethod = .get, parameters: Parameters? = nil, completion: @escaping WedServiceResponse) {
		let url = URL(string: "\(NetworkServices.hostname)\(route)")
		if let url = url {
			AF.request(url, method: method,parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response) in
				switch response.result{
				case.success(let values):
					let dict = values as! [String:Any?]
					if let items = dict["result"] as? [[String: Any?]] {
						completion(items,nil)
					}
					else if let item = dict["result"] as? [String: Any?] {
						completion([item],nil)
					} else  {
						completion([dict],nil)
					}
				break
				case.failure(let error):
					completion(nil,error)
					break
				}
			}
			
		}
	}
	
	func getData(route: String, parameters: Parameters? = nil,completion: @escaping WedServiceResponse) {
		self.excute(route: route,parameters: parameters, completion: completion)
	}
	func postData(route: String, parameters: Parameters? = nil,completion: @escaping WedServiceResponse) {
		self.excute(route: route,method: .post,parameters: parameters, completion: completion)
	}
	
	func putData() {
	}
	
	func deleteData() {
	}
}
