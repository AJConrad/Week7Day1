//
//  ViewController.swift
//  ARCompass
//
//  Created by Andrew Conrad on 5/23/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet private var directionHeadingLabel     :UILabel!
    @IBOutlet private var directionCameraView       :UIView!
    var directionSession                            :AVCaptureSession?
    var directionLayer                              :AVCaptureVideoPreviewLayer?
    
    
    
    //MARK: - Live Camera Overlay Methods
    
    func startCaptureSession() {
        directionSession = AVCaptureSession()
        directionSession!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error       :NSError?
        var input       :AVCaptureDeviceInput!
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print("Error \(error)")
        }
        
        if error == nil && directionSession!.canAddInput(input) {
            directionSession!.addInput(input)
            directionLayer = AVCaptureVideoPreviewLayer(session: directionSession)
            directionLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            directionLayer!.connection?.videoOrientation = .Portrait
            directionCameraView.layer.addSublayer(directionLayer!)
            
            directionSession!.startRunning()
        }
    }
    
    
    
    //MARK: - Compass Methods
    
    var locationManager = CLLocationManager()
    
    private func getDisplayHeading() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var headingString = ""
        switch newHeading.magneticHeading {
        case 0...22.5:
            headingString = "N"
        case 22.5...67.5:
            headingString = "NE"
        case 67.5...112.5:
            headingString = "E"
        case 112.5...157.5:
            headingString = "SE"
        case 157.5...202.5:
            headingString = "S"
        case 202.5...247.5:
            headingString = "SW"
        case 247.5...292.5:
            headingString = "W"
        case 292.5...337.5:
            headingString = "NW"
        case 337.5...360.0:
            headingString = "N"
        default:
            headingString = "?"
        }
        directionHeadingLabel.text = "\(headingString)"
    }
    
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDisplayHeading()
        startCaptureSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        directionLayer!.frame = directionCameraView.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

