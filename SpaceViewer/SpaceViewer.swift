//
//  SpaceViewer.swift
//  Space Viewer
//
//  Created by Adam Czech on 7/28/19.
//  Copyright © 2019 Adam Czech. All rights reserved.
//

import Foundation
import UIKit

enum SpaceViewerError: Error {
    case runtimeError(String)
}

protocol SpaceViewerDelegate {
    func dataReady(_ sender: SpaceViewer, ntype: NasaType)
}

//
// SpaceViewer - Main app model
//
// This class handles all NASA API requests and data.
//
class SpaceViewer : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    private lazy var apiHandler: ApiRequest = {
        return ApiRequest(del: self, delQ: nil)
    }()
    
    // Set of Current Nasa data
    var nasaTypes = Set<NasaType>()
    
    var viewerDelegate: SpaceViewerDelegate?
    
    //
    // Start a generic API request
    //
    private func startRequest(nType: NasaType) throws {
        if let url = nType.formUrl() {
            nType.apiTask = apiHandler.startRequest(url: url)
            nasaTypes.insert(nType)
        } else {
            throw SpaceViewerError.runtimeError("Bad URL")
        }
    }
    
    //
    // Perform data type specific final init
    //
    private func finishRequest(nType: NasaType) {
        
        // APOD needs image
        if let apod = nType as? Apod {
            if !apod.imageRecvd {
                print("starting image get")
                apod.parseApiData(rawApiData: apod.apiRawData)
                if let apodUrl = apod.apodData?.url, let url = URL(string: apodUrl){
                    apod.apiRawData = Data()
                    apod.apiTask = apiHandler.startRequest(url: url)
                }
                apod.imageRecvd = true
            } else {
                print("image received!")
                // Image has been recieved handle it
                apod.image = UIImage.init(data: apod.apiRawData)
                viewerDelegate?.dataReady(self, ntype: nType)
            }
        }
        
        
    }
    
    //
    // Start an APOD request. SpaceViewerDelegate is used to inform the system
    // when the request is complete.
    //
    func startApodRequest() {
        let apod = Apod()
        
        do {
            try startRequest(nType: apod)
        } catch SpaceViewerError.runtimeError(let e) {
            print(e)
        } catch {
            print("Unexpected error");
        }
    }
    
    //
    // This function uses the URLSessionTask ID to find the corresponding
    // NASA API request.
    //
    func findReqByDataTask(task: URLSessionTask) -> NasaType? {
        for req in nasaTypes {
            if req.apiTask?.taskIdentifier == task.taskIdentifier {
                return req
            }
        }
        return nil
    }
    
    //
    // MARK: URLSession Delegates
    //
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode),
            let mimeType = response.mimeType else {
                print("Transaction cancelled!")
                completionHandler(.cancel)
                return
        }
        completionHandler(.allow)
        print("Received header! type: \(mimeType)")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("Received data!")
        if let nasaType = findReqByDataTask(task: dataTask) {
            nasaType.apiRawData.append(data)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Request complete!")
        if let nasaType = findReqByDataTask(task: task) {
            finishRequest(nType: nasaType)
        } else {
            print("Failed to parse")
        }
    }
    
}


