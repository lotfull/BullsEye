//
//  HoToPlay2ViewController.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 10.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class HoToPlay2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html") {
            if let htmlData = try? Data(contentsOf: url) {
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
    }
    
    @IBOutlet weak var webView: UIWebView!
    @IBAction func closeRulesButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
