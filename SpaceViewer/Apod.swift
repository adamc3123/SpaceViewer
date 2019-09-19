//
//  Apod.swift
//  Space Viewer
//
//  Created by Adam Czech on 7/28/19.
//  Copyright © 2019 Adam Czech. All rights reserved.
//

import Foundation
import UIKit

//
// Apod - Represents a NASA APOD instance
//
class Apod : NasaType {
    
    var apodData: ApodData?
    var imageRecvd: Bool
    var image: UIImage?
    
    init() {
        imageRecvd = false
        super.init(host: "api.nasa.gov", path: "/planetary/apod")
    }
    
    override func parseApiData(rawApiData: Data) {
        apodData = try? JSONDecoder().decode(ApodData.self, from: rawApiData)
    }
}

struct ApodData : Codable {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let url: String
    let media_type: String
    let title: String
}

