//
//  ApiProvider.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation
import Alamofire

class ApiProvider {
    
    //singleton
    static let shared = ApiProvider()
    private init() {}
    let url = "https://run.mocky.io/v3/729e846c-80db-4c52-8765-9a762078bc82"
    
    //must call from background thread
    func load() -> MessagesRes? {
        let semaphore = DispatchSemaphore(value: 0)
        var res: MessagesRes?
        AF.sessionConfiguration.timeoutIntervalForRequest = 3
        AF.request(URL(string: url)!, method: .get)
            .validate()
            .responseDecodable(of: MessagesRes.self) { response in
                switch response.result {
                case .success(let resModel):
                    print(">>>Request Success")
                    res = resModel
                    semaphore.signal()
                case .failure (let err):
                    print(">>>Request Failed \(err.localizedDescription)")
                    semaphore.signal()
                }
            }
        semaphore.wait()
        return res
    }
}

extension String: Error {}
