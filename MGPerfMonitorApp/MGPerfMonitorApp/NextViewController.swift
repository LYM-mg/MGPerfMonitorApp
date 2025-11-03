//
//  NextViewController.swift
//  MGPerfMonitor
//
//  Created by 刘远明 on 2025/10/31.
//

import UIKit
import Combine
import AVFoundation

class NextViewController: UIViewController {
    public var cancellable = Set<AnyCancellable>()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .top
        view.alignment = .fill
        view.distribution = .fill
        view.backgroundColor = .clear
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 12, left: 10, bottom: 12, right: 10)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        addBtn()
//        requestPermissionsIfNeeded { granted in
//            if granted {
//                print("用户授权相机或麦克风 \(granted)")
//            } else {
//                print("用户未授权相机或麦克风")
//            }
//        }
    }
    
    
    func addBtn() {
        let btn = UIButton()
        btn.setTitle("Switch Host or Audience", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in                 self?.navigationController?.pushViewController(OuterPagingViewController(), animated: true)
        }.store(in: &cancellable)
        
        let btn0 = UIButton()
        btn0.setTitle("Host Live", for: .normal)
        btn0.setTitleColor(.gray, for: .normal)
        btn0.layer.borderColor = UIColor.lightGray.cgColor
        btn0.layer.borderWidth = 1
        btn0.layer.cornerRadius = 5
        btn0.layer.masksToBounds = true
        btn0.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in                 self?.navigationController?.pushViewController(OuterPagingViewController(), animated: true)
        }.store(in: &cancellable)
   
        let btn1 = UIButton()
        btn1.setTitle("Audience Live", for: .normal)
        btn1.setTitleColor(.gray, for: .normal)
        btn1.layer.borderColor = UIColor.lightGray.cgColor
        btn1.layer.borderWidth = 1
        btn1.layer.cornerRadius = 5
        btn1.layer.masksToBounds = true
        btn1.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.pushViewController(OuterPagingViewController(), animated: true)
        }.store(in: &cancellable)
        
        containerStackView.addArrangedSubview(btn)
        containerStackView.addArrangedSubview(btn0)
        containerStackView.addArrangedSubview(btn1)
    }
    
    deinit {
        cancellable.forEach {
            $0.cancel()
        }
    }
    
    func requestPermissionsIfNeeded(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { videoGranted in
            AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                DispatchQueue.main.async {
                    completion(videoGranted && audioGranted)
                }
            }
        }
    }
}

