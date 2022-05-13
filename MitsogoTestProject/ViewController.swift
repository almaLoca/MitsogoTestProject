//
//  ViewController.swift
//  MitsogoTestProject
//
//  Created by FairCode on 15/09/20.
//  Copyright © 2020 FairCode. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelAverageSpeed: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        if NSString(string:UIDevice.current.systemVersion).doubleValue > 8 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setupUI() {
        buttonStart.layer.cornerRadius = buttonStart.frame.height / 2
        buttonStart.layer.masksToBounds = true
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
      var speed: CLLocationSpeed = CLLocationSpeed()
        speed = locationManager.location!.speed
      print(speed);
    }

//    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status != CLAuthorizationStatus.denied{
//          locationManager.startUpdatingLocation()
//      }
//    }
    
    //check location services enabled or not

    func checkLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                //open setting app when location services are disabled
            openSettingApp(message:NSLocalizedString("Please enable location services to continue using the app", comment: ""))
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            default:
                break
            }
        } else {
            print("Location services are not enabled")
            openSettingApp(message:NSLocalizedString("Please enable location services to continue using the app", comment: ""))
        }
    }
    
    //Open location settings for app
    func openSettingApp(message: String) {
        let alertController = UIAlertController (title: "Alert", message:message , preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (_) -> Void in
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
            UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)

            if UIApplication.shared.canOpenURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL) {
                UIApplication.shared.open(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttonHistoryAction(_ sender: UIButton) {
        
    }
    
    @IBAction func burronStartAction(_ sender: UIButton) {
        if buttonStart.titleLabel?.text == "START" {
            buttonStart.setTitle("STOP", for: .normal)
        }else {
            buttonStart.setTitle("START", for: .normal)
        }
        checkLocationPermission()
    }
    
}

