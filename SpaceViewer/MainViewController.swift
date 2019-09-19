//
//  MainViewController.swift
//  Space Viewer
//
//  Created by Adam Czech on 7/21/19.
//  Copyright © 2019 Adam Czech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, SpaceViewerDelegate {
    
    lazy var viewer: SpaceViewer = SpaceViewer()
    
    @IBOutlet weak var apodImage: UIImageView!
    @IBOutlet weak var apodTitle: UILabel!
    @IBOutlet weak var apodDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewer.viewerDelegate = self

        viewer.startApodRequest()
    }
    
    //
    // MARK: SpaceViewer Delegates
    //
    
    func dataReady(_ viewer: SpaceViewer, ntype: NasaType) {
        DispatchQueue.main.async {
            print("got data")
            if ntype is Apod,
                let apod = ntype as? Apod {
                self.apodTitle.text = apod.apodData?.title
                self.apodDesc.text = apod.apodData?.explanation
                self.apodImage.image = apod.image
            }
        }
    }
}


