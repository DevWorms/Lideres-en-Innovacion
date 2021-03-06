//
//  ViewController.swift
//  Líderes en Innovación
//
//  Created by Emmanuel Valentín Granados López on 27/09/16.
//  Copyright © 2016 Emmanuel Valentín Granados López. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tlabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        tlabel.text = "Encuentro de Líderes en Innovación"
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        tlabel.adjustsFontSizeToFitWidth = true
        //tlabel.adjustsFontForContentSizeCategory = true
        
        self.navigationItem.titleView = tlabel
        
        
        self.scrollView.delegate = self
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }

}

