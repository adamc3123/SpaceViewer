//
//  ApiRequest.swift
//  Space Viewer
//
//  Created by Adam Czech on 7/28/19.
//  Copyright © 2019 Adam Czech. All rights reserved.
//

import Foundation

class ApiRequest {
    
    private var urlSession: URLSession
    
    init(del: URLSessionDelegate, delQ: OperationQueue?) {
        let urlConfig = URLSessionConfiguration.default
        urlConfig.waitsForConnectivity = true
        urlConfig.allowsCellularAccess = true
        urlSession = URLSession(configuration: urlConfig, delegate: del, delegateQueue: delQ)
    }

    func startRequest (url: URL) -> URLSessionDataTask {
        let task = urlSession.dataTask(with: (url))
        task.resume()
        return task
    }
    
}
