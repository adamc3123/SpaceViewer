//
//  NasaType.swift
//  Space Viewer
//
//  Created by Adam Czech on 8/10/19.
//  Copyright © 2019 Adam Czech. All rights reserved.
//

import Foundation

//
// NasaType - Generic NASA data type
//
class NasaType : Hashable {
    
    private var scheme: String
    private var host: String
    private var path: String
    private var query: String
    let HTTPS_SCHEME = "https"
    let HTTP_SCHEME = "http"
    let NASA_API_QUERY = "api_key=" + "DEMO_KEY"
    var apiTask: URLSessionDataTask?
    var apiRawData: Data
    
    init(scheme: String, host: String, path: String, query: String) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.query = query
        apiRawData = Data()
    }
    
    init(host: String, path: String, query: String) {
        self.scheme = HTTPS_SCHEME
        self.host = host
        self.path = path
        self.query = query
        apiRawData = Data()
    }
    
    init(host: String, path: String) {
        self.scheme = HTTPS_SCHEME
        self.host = host
        self.path = path
        self.query = NASA_API_QUERY
        apiRawData = Data()
    }
    
    func formUrl() -> URL? {
        var url = URLComponents()
        url.scheme = self.scheme
        url.host = self.host
        url.path = self.path
        url.query = self.query
        return url.url
    }
    
    func parseApiData(rawApiData: Data) {
        fatalError("Must override")
    }
    
    //
    // MARK: Hashable
    //
    
    static func == (lhs: NasaType, rhs: NasaType) -> Bool {
        return (lhs.host == rhs.host) && (lhs.query == rhs.query)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.path)
        hasher.combine(self.query)
    }
}
