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
    var idPregunta = ""
    var pregunta = ""
    var respuesta1 = ""
    var respuesta2 = ""
    var respuesta3 = ""
    var respuesta4 = ""
    var numPreg = 0
    var numGlobal = 0
    var siempreUno = 0

    @IBOutlet weak var respLbl1: UILabel!
    @IBOutlet weak var respLbl2: UILabel!
    @IBOutlet weak var respLbl3: UILabel!
    @IBOutlet weak var respLbl4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("inicia numGlobal: \(self.numGlobal)")
        
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
                            
                            if let idPreg = dictionary["id_pregunta"] {
                                self.idPregunta = idPreg
                            }
                        
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
            
            self.respLbl1.text = self.respuesta1
            self.respLbl2.text = self.respuesta2
            self.respLbl3.text = self.respuesta3
            self.respLbl4.text = self.respuesta4
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierCell", for: indexPath)

        return cell
    }
     */
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/
        
        return self.pregunta
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text = self.pregunta
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.httpPOST(respuesta: "A")
        case 1:
            self.httpPOST(respuesta: "B")
        case 2:
            self.httpPOST(respuesta: "C")
        case 3:
            self.httpPOST(respuesta: "D")
        default: break
        }
    }
    
    private func httpPOST(respuesta: String) {
        
        let headers = [
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let postData = NSMutableData(data: ("pregunta=" + self.idPregunta ).data(using: String.Encoding.utf8)!)
        postData.append( ("&respuesta=" + respuesta ).data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://luisdiazapps.com/Projects/Tech/answers_JSON.php")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            print("hola 00")
            
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            
            self.performSegue(withIdentifier: "", sender: nil)
            
        })
        
        dataTask.resume()
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
            
            print("hola 0")
            
            // pass data to destinationViewController
            destinationViewController.numGlobal = self.numGlobal + 1
        }
    }
    
    // cancela o deja asar el segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("hola 1")
        
        return true
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
