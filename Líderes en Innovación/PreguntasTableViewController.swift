//
//  PreguntasTableViewController.swift
//  Líderes en Innovación
//
//  Created by Emmanuel Valentín Granados López on 02/11/16.
//  Copyright © 2016 Emmanuel Valentín Granados López. All rights reserved.
//

import UIKit

class PreguntasTableViewController: UITableViewController {
    
    var task : URLSessionDataTask?
    var pregunta = ""
    var respuesta1 = ""
    var respuesta2 = ""
    var respuesta3 = ""
    var respuesta4 = ""
    var numPreg = 0
    var numGlobal = 0
    var siempreUno = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("inicia numGlobal: \(self.numGlobal)")
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://luisdiazapps.com/Projects/Tech/preguntas_JSON.php")! as URL)
        request.httpMethod = "GET"
        
        self.task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error Request =\(error)")
                return
            } else {
                
                //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(responseString)")
                
                do {
                    let jsonWithObjectRoot = try JSONSerialization.jsonObject(with: data! , options: []) as! NSArray
                    
                    print("count= \(jsonWithObjectRoot.count)")
                    
                    self.numPreg = jsonWithObjectRoot.count
                    
                    //for valueJson in jsonWithObjectRoot { // jsonWithObjectRoot[0...]
                        
                        if let dictionary = jsonWithObjectRoot[ self.numGlobal ] as? [String: String] {
                        
                            //print(dictionary)
                        
                            if let preg = dictionary["pregunta"] {
                                self.pregunta = preg
                            }
                        
                            if let ans_1 = dictionary["ans_1"] {
                                self.respuesta1 = ans_1
                            }
                        
                            if let ans_2 = dictionary["ans_2"] {
                                self.respuesta2 = ans_2
                            }
                        
                            if let ans_3 = dictionary["ans_3"] {
                                self.respuesta3 = ans_3
                            }
                        
                            if let ans_4 = dictionary["ans_4"] {
                                self.respuesta4 = ans_4
                            }
                        
                            //for (key, value) in dictionary {
                                // access all key / value pairs in dictionary
                                //print("\(key) , \(value)")
                            //}
                        }
                    //}
                    
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
                
            }
            
            self.siempreUno = 1
            self.tableView.reloadData()
            
        }
        self.task!.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.siempreUno
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRespuesta", for: indexPath)

        let resp1 = cell.viewWithTag(1) as! UILabel
        resp1.text = self.respuesta1

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/
        
        return self.pregunta
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "bucle" {
            let destinationViewController = segue.destination as! PreguntasTableViewController
            
            if self.numGlobal == self.numPreg-1 {
                self.dismiss(animated: true, completion: nil)
            }
            
            // pass data to destinationViewController
            destinationViewController.numGlobal = self.numGlobal + 1
        }
    }
    
    // cancela o deja asar el segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
