//
//  InicioViewController.swift
//  Líderes en Innovación
//
//  Created by Emmanuel Valentín Granados López on 02/11/16.
//  Copyright © 2016 Emmanuel Valentín Granados López. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tlabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        tlabel.text = "Encuentro de Líderes en Innovación"
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        tlabel.adjustsFontSizeToFitWidth = true
        //tlabel.adjustsFontForContentSizeCategory = true
        
        self.navigationItem.titleView = tlabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
