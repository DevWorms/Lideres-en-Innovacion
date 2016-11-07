//
//  AgendaDiaViewController.swift
//  Líderes en Innovación
//
//  Created by Emmanuel Valentín Granados López on 13/10/16.
//  Copyright © 2016 Emmanuel Valentín Granados López. All rights reserved.
//

import UIKit
import EventKit
import Foundation

class AgendaDiaViewController: UITableViewController {
    
    var tagMenu = 0
    
    var eventos : [String] = []
    var horarios : [String] = []
    var descripciones : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.cargarDatos(caso: tagMenu)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date) {
        
        var message : String = ""
        
        //alert con indicador
        let alertIndicador = UIAlertController(title: nil, message: "   Agregando evento a tu calendario...", preferredStyle: .alert)
        alertIndicador.view.tintColor = UIColor.black
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alertIndicador.view.addSubview(loadingIndicator)
        self.present(alertIndicador, animated: true, completion: nil)
        //
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    
                    message = e.localizedDescription
                    
                    return
                }
                
                message = "El evento se agregó satisfactoriamente."
                
            } else {
                
                if granted {
                    message = (error?.localizedDescription)!
                } else {
                    message = "No pudimos añadir este evento. Permite que Líderes en Innovación acceda a Calendarios."
                }
            }
            
            self.dismiss(animated: false, completion: nil)
            
            DispatchQueue.main.async {
                let alert = UIAlertView(title: "Calendario", message: message, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }


        })
        
    }
    
    func event(sender: UIButton) {
        
        let alert = UIAlertController(title: "Notificar", message: "¿Deseas que agreguemos este evento a tu calendario?" , preferredStyle: UIAlertControllerStyle.alert)
                    
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { UIAlertAction in
            
            let fullHora    = self.horarios[ sender.tag ]
            let fullHoraArr = fullHora.components(separatedBy: " - ")
            let horaIni = fullHoraArr[0]
            let horaFin = fullHoraArr[1]
            
            let fullDate    = self.navigationItem.title!
            let fullDateArr = fullDate.components(separatedBy: " ")
            let date = fullDateArr[0]
            
            print(horaIni + " - " + horaFin + " date: " + date)
            
            let dateFormatter =   DateFormatter()
            
            let dateIniAsString = date + "-11-2016 " + horaIni
            let dateFinAsString = date + "-11-2016 " + horaFin
            
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            
            let dateIni = dateFormatter.date(from: dateIniAsString)!
            let dateFin = dateFormatter.date(from: dateFinAsString)!
                        
            self.addEventToCalendar(title: self.eventos[ sender.tag ], description: self.descripciones[ sender.tag ], startDate: dateIni, endDate: dateFin)
                        
        })
        )
                    
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.eventos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvento", for: indexPath) as! TableViewCell

        cell.textEvent.text = self.eventos[ indexPath.row ]
        
        cell.textHorario.text = self.horarios[ indexPath.row ]
        
        cell.btnCalendario.tag = indexPath.row
        cell.btnCalendario.addTarget(self, action: #selector(AgendaDiaViewController.event(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertView(title: "Descripción", message: self.descripciones[indexPath.row], delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func cargarDatos(caso: Int) {
        switch caso {
        case 0:
            self.navigationItem.title = "15 de Noviembre"
            
            self.horarios = ["08:00 - 17:00",
                             "09:30 - 10:15",
                             "10:15 - 11:10",
                             "11:10 - 12:05",
                             "12:05 - 12:10",
                             "12:10 - 13:40",
                             "13:40 - 13:45",
                             "13:45 - 14:35",
                             "14:35 - 15:55",
                             "15:55 - 16:00",
                             "16:00 - 16:45",
                             "16:45 - 17:30",
                             "17:35 - 19:00"
            ]
            
            self.eventos = ["Registro // Registration",
                            "Ceremonia inaugural // Opening ceremony",
                            "Conferencia magistral // Keynote lecture",
                            "Conferencia plenaria // Keynote lecture",
                            "Video // Fast talk - “Los retos y oportunidades de la industria aeroespacial” // “The challenges and opportunities for the aerospace industry”",
                            "Panel de expertos // Experts panel - “Perspectivas del sector aeroespacial en México” // “Prospects the aerospace sector in Mexico”.",
                            "Video // Fast talk (Sustainability) (Polytechnic personality) - “Sustentabilidad e innovación” // “Sustainability and innovation”",
                            "Conferencia plenaria // Plenary lecture",
                            "Receso // Break",
                            "Video // Fast talk - “Empresas sustentables y energía renovable” // “Sustainable enterprises and renewable energy”",
                            "Conferencia plenaria // Plenary lecture - “Six things to keep in mind when the world ends”",
                            "Conferencia plenaria // Plenary lecture",
                            "Panel de expertos // Experts panel - “Mujeres del presente forjando el futuro” // “Women shaping the future”"
            ]
            
            self.descripciones = [
                "",
                "",
                "Gunther J. Barajas, VP Dassault Systèmes México // VP Dassault Systèmes México",
                "Romolo Zulli, Lider de HTS México, México // Leader of HTS Mexico, México",
                "Sergio Viñals, Director del Centro de Desarrollo Aeroespacial del IPN, México // Director of the Aerospace Development Center of IPN, Mexico",
                "Moderador // Moderator : Francisco Javier Mendieta, Agencia Espacial Mexicana, México\r\n\n Panelistas // Panelists :\r\n Benito Gritzewsky, Presidente de la Federación Mexicana de la Industria Aeroespacial, A.C., México // President of the Mexican Federation of Aerospace Industry, Mexico\r\n Miguel Álvarez, Consejo Mexicano de Educación Aeroespacial, México // Mexican Council of Aerospacial Education, Mexico\r\n Paul Antonio Quintanilla, Thales México, México // Thales Mexico\r\n Romolo Zulli, Lider de HTS México, México // Leader of HTS Mexico, Mexico\r\n Clúster Aeroespacial de Chihuahua, México // Chihuahua Aerospace Cluster, Mexico",
                "Héctor Mayagoitia, Coordinador del Programa Politecnico para la Sustentabilidad, México // Polytechnic Coordinator for Sustainability, Mexico",
                "Luis Herrera Estrella, Investigador del Centro de Investigación y de Estudios Avanzados del IPN y Premio Cleantech Challenge 2016, México // Researcher of Cinvestav and Cleantech Challenge Award 2016, Mexico",
                "",
                "Miguel Ángel Aké Madera, Investigador politécnico y Premio Nacional de Trabajo 2015, México // Polytechnic researcher and National Labor Award 2015, Mexico",
                "Luis Aguirre Torres, Director Ejecutivo de Green Momentum y Cleantech Challenge México, México // CEO of Green Momentum and Cleantech Challenge Mexico, Mexico",
                "Shell Huang, Directora de Adquisición de Tecnología Externa, Coca Cola, EE.UU. // Director of External Technology Acquisition at The Coca Cola Company, U.S.A.",
                "Moderadora // Moderator : María del Sol Rumayor, Directora del Programa de Desarrollo Empresarial del Instituto Nacional del Emprendedor, México // Director of Business Development Program of the National Institute of Entrepreneurship, Mexico\r\n\n Panelistas // Panelists :\r\n Ana María Sánchez, Presidenta Nacional de la Asociación de Mujeres Empresarias, México // National President of the Association of Women Entrepreneurs, Mexico\r\n Mayra de la Torre, Vicepresidenta para Ámerica Latina y el Caribe de la Organización para la Mujeres en Ciencia para un mundo en Desarrollo, México // Vice President for Latin America and the Caribbean of the Organization for Women in Science for the Developing World, Mexico\r\n Alicia Santiago, Fundadora de SciGirls y Fabfems, EE.UU. // Founder of SciGirls and Fabfems, U.S.A.\r\n Ana Karen Ramírez, Fundadora de Epic Queen, México // Founder of Eric Queen, Mexico\r\n Emma Georgina Tello, Directora Ejecutiva de Manos Creativas, México // CEO of Manos Creativas, Mexico\r\n Blanca Estela Pérez, Presidenta de la Asociación Mexicana de Mujeres Empresarias en el Estado de México Zona Poniente // President of the Mexican Association of Women Entrepreneurs, Mexico"
            ]
            
        case 1:
            self.navigationItem.title = "16 de Noviembre"
            
            self.horarios = ["08:00 - 17:00",
                             "09:30 - 10:25",
                             "10:30 - 11:25",
                             "11:25 - 12:10",
                             "12:10 - 12:55",
                             "12:55 - 13:00",
                             "13:00 - 14:30",
                             "14:30 - 15:55",
                             "15:55 - 16:00",
                             "16:00 - 16:45",
                             "16:45 - 17:30",
                             "17:30 - 18:00",
                             "18:00 - 19:00"
            ]
            
            self.eventos = ["Registro // Registration",
                            "Conferencia magistral // Keynote lecture - “Inteligencia arti cial en vehículos no tripulados” // “Arti cial Intelligence in unmanned vehicles”",
                            "Conferencia magistral // Keynote lecture - “Estrategias bilaterales México-Estados Unidos para el fortalecimiento de la innovación” // “Bilateral United State-Mexico strategies to strengthen innovation”",
                            "Conferencia plenaria // Plenary lecture - “Tendencias tecnologicas y de mercado del sector automotriz” // “Trends in the automotive sector”",
                            "Conferencia plenaria // Plenary lecture - “Perspectivas de la economía digital” // “Prospects for the digital economy”",
                            "Video // Fast talk - “La minería de datos y sus aplicaciones” // “Data mining and its applications”",
                            "Panel de expertos // Experts panel - “Programas universitarios en grandes empresas” // “University programs in large companies”",
                            "Receso // Break",
                            "Video // Fast talk - “Las oportunidades de la innovación para las instituciones de educación superior y el país” // “Opportunities for innovation for higher education institutions and the country”",
                            "Conferencia plenaria // Plenary lecture",
                            "Conferencia plenaria // Plenary lecture",
                            "Charla tipo TED Talk // TED taller-like chat",
                            "Panel de expertos // Experts panel - “Geeks y diversión en aplicaciones” // “Geeks and fun apps”"
            ]
            
            self.descripciones = [
                "",
                "Raúl Rojas, Investigador de la Universidad Libre de Berlín, Alemania y Premio Nacional de Ciencias y Artes 2015, México // Researcher at the Free University of Berlin, Germany and National Prize for Arts and Science 2015, Mexico",
                "Roberta S. Jacobson, Embajadora de Estados Unidos en México // U.S.A. Ambassador in Mexico",
                "Ernesto Mariano Hernández Quiroz, Presidente y Director General de General Motors México, México // President and General Director of General Motors, Mexico",
                "Mónica Taher, Fundadora y Directora Ejecutiva de ClipYap // Founder and CEO of ClipYap",
                "Adolfo Guzmán Arenas, Investigador politécnico y Premio Nacional de Ciencias y Artes 1996, México // Polytechnic researcher and National Prize for Arts and Science 1996, Mexico",
                "Moderador // Moderator : CUDI\r\n\n Panelistas // Panelists :\r\n José Bernardo Rosas, Director Adjunto de Telecomunicaciones NEC, México // Deputy Director of Telecommunications of NEC, Mexico\r\n Jorge Silva Luján, Director General Microsoft México // Local Head of Google for Work, Mexico\r\n Juan Francisco Aguilar, Gerente General de Dell México // General Director of Dell Mexico\r\n Jorge Molina, Jefe Local de Google for Work, México // Local Head of Google for Work, Mexico\r\n Salvador Martínez, Presidente y Gerente General de IBM México // Gresident and General Manager of IBM Mexico\r\n Antonio Mendoza, Gerente General de Balluff, México // General Manager of Balluf, Mexico",
                "",
                "Luis Villa, Investigador politécnico, México // Polytechnic researcher, Mexico",
                "Anibal Gonda, Evangelista Técnico de GeneXus, Uruguay // GeneXus Technical Evangelist, Uruguay",
                "José Pacheco, Co-Director de la Maestría en Ingeniería en Diseño y Manufactura Avanzada del Massachussetts Institute of Technology, EE.UU. // Co-chair at the Master of Engineering in Advanced Manufacturing and Design at Massachussetts Institute of Technology, U.S.A.",
                "Jesús Bush, Presidente y Director General de 50Plus, México // President and General Director of 50Plus, Mexico",
                "Moderador // Moderator : Víctor A. Gutiérrez, Presidente Nacional y Vicepresidente de Desarrollo e Integración de Sedes en la Cámara Nacional de la Industria Electrónica de Telecomunicaciones y Tecnologías de la Información, México // National President and Vice President of Development and Network Integration in the CANIETI, Mexico\r\n\n Panelistas // Panelists :\r\n Alberto Beltrán, Director Ejecutivo de Kuruchusoft, México // CEO at Kuruchusoft, Mexico\r\n Alonso Santiago, Director Ejecutivo de Bambú Mobile, México // CEO of Bambú Mobile, Mexico\r\n Eme Morato, Co-Fundador de Dev.f, México // Co-Founder of Dev.f, Mexico\r\n Gerardo Tinajero, Jefe de Operaciones y Co-Fundador de Knowhere, México // COO and Co-Funder of Knowhere, Mexico"
            ]
            
        case 2:
            self.navigationItem.title = "17 de Noviembre"
            
            self.horarios = ["08:00 - 13:00",
                             "09:30 - 10:15",
                             "10:15 - 11:20",
                             "11:20 - 12:05",
                             "12:05 - 12:10",
                             "12:05 - 14:00",
                             "14:00 - 14:30"
            ]
            
            self.eventos = ["Registro // Registration",
                            "Conferencia plenaria // Keynote lecture",
                            "Conferencia magistral // Keynote lecture",
                            "Conferencia plenaria // Keynote lecture",
                            "Video // Fast talk - “Nanotecnología y cáncer” // “Nanotechnology and cancer”",
                            "Panel de expertos // Experts panel - “Ecosistemas exitosos en innovación” // “Successful innovation ecosystems”",
                            "Cierre del evento // Concluding remarks"
            ]
            
            self.descripciones = [
                "",
                "Gerardo Herrera Corral, Investigador del Centro de Investigación y de Estudios Avanzados del IPN y Líder mexicano del Proyecto del Gran Colisionador de Hadrones, México // Researcher of Cinvestav and Mexican Project Leader of the Large Hadron Collider, Mexico",
                "Biotecnología/Genómica/Industria farmaceútica/ Tecnologías para la salud",
                "Franklin Carrero-Martínez, Director de Programas de la O cina Internacional de Ciencia e Ingeniería de la Fundación Nacional de Ciencia, EE.UU. // Program Director of the International Of ce of Science and Engineering at the National Science Foundation, U.S.A.",
                "Eva Ramón Gallegos, Investigadora politécnica, México // Polytechnic researcher, Mexico",
                "Moderador // Moderator :\r\n\n Panelistas // Panelists :\r\n Rina Fainstein, Directora Ejecutiva de P-EcoSys, Israel // CEO at P-EcoSys, Israel\r\n Jorge Rincón, Coordinador de Asuntos Internacionales del Servicio Brasileño de Apoyo a las Micro y Pequeñas Empresas, Brasil // Coordinator of International Affairs of the Brazilian Support Service for Micro and Small Enterprises, Brazil\r\n Juan Castro-Cal, Investigador del Consejo Superior de Investigaciones Cientí cas, España // Researcher at the Higher Council for Scienti c Research, Spain",
                ""
            ]
        default:
            break
        }
    }

}
