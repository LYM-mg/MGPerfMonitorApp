//
//  ViewController.swift
//  MGPerfMonitorApp
//
//  Created by 刘远明 on 2025/10/23.
//

import UIKit
import MGPerfMonitor

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Thread.sleep(forTimeInterval: 2)
        
        MGStackSampler.getSymbolicated()
        MGStackSampler.sampleMainThreadSymbolized()
    }

}

