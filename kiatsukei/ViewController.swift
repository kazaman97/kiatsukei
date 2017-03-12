//
//  ViewController.swift
//  kiatsukei
//
//  Created by Kazama Ryusei on 2017/03/11.
//  Copyright © 2017年 Malfoy. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!

    @IBAction func resetButton(_ sender: Any) {
        altimeter.stopRelativeAltitudeUpdates()
        startUpdate()
    }
    
    var myMotionManager: CMMotionManager!
    let altimeter = CMAltimeter()
    
    func startUpdate() {
        pressureLabel.text = "気圧:---- hPa"
        altitudeLabel.text = "高さ:-.-- m"
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
                data, Error in
                if Error == nil {
                    let pressure:Double = Double(data!.pressure)
                    let altitude:Double = Double(data!.relativeAltitude)
                    self.pressureLabel.text = String(format: "気圧:%.1f hPa", pressure*10)
                    self.altitudeLabel.text = String(format: "高さ:%.2f m", altitude)
                }
            })
        } else {
            print("not use altimeter")
        }
    }
    
    func motionSensor() {
        myMotionManager = CMMotionManager()
        myMotionManager.accelerometerUpdateInterval = 0.1
        myMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: (accelerometerData, error) in
        if let e = error {
            print(e.localizedDescription)
            return
        }
        guard let data = accelerometerData else {
            return
        }
        xLabel.text = "x=\(data.acceleration.x)"
        yLabel.text = "y=\(data.acceleration.y)"
        zLabel.text = "z=\(data.acceleration.z)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startUpdate()
        motionSensor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

