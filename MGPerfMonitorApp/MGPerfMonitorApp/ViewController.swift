//
//  ViewController.swift
//  MGPerfMonitorApp
//
//  Created by 刘远明 on 2025/10/23.
//

import UIKit
import MGPerfMonitor
//import BigoADS
import RswiftResources

class ViewController: UIViewController {

//    let imageView = UIImageView(image: R.image.email_selected())
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        view.addSubview(imageView)
        
//        R.storyboard.main.instantiateInitialViewController()
//        R.storyboard.launchScreen.instantiateInitialViewController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        Thread.sleep(forTimeInterval: 2)
        
        self.navigationController?.pushViewController(NextViewController(), animated: true)
//        MGStackSampler.sampleMainThreadSymbolized()
    }
}

