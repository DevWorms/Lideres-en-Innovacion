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
            
            self.eventos = ["Registro",
                            "Conferencia magistral (futurismo/Tech Trends)",
                            "Fast talk (mensaje de bienvenida y deseos de éxito)",
                            "Ceremonia inaugural ",
                            "Conferencia magistral",
                            "Fast talk (personalidad politécnica)",
                            "Panel \"Perspectivas del sector aeroespacial en México\"",
                            "Fast talk (personalidad politécnica)",
                            "Conferencia plenaria",
                            "Conferencia magistral (Sustentabilidad)",
                            "Receso",
                            "Fast talk (empresario politécnico)",
                            "Conferencia plenaria",
                            "Conferencia magistral",
                            "Fast talk (emprendedores politécnicos)",
                            "Conferencia plenaria (Silk leaf) ",
                            "Panel \"Mujeres del presente forjando el futuro\"",
                            "Cierre"
            ]
            
            self.horarios = ["08:00 - 09:00",
                             "09:00 - 09:45",
                             "09:45 - 09:50",
                             "09:50 - 10:30",
                             "10:30 - 11:15",
                             "11:15 - 11:20",
                             "11:20 - 12:40",
                             "12:40 - 12:45",
                             "12:45 - 13:30",
                             "13:30 - 14:15",
                             "14:15 - 15:15",
                             "15:15 - 15:20",
                             "15:20 - 16:00",
                             "16:00 - 16:45",
                             "16:45 - 16:55",
                             "16:55 - 17:35",
                             "17:35 - 19:00",
                             "19:00 - 19:10"
            ]
            
            self.descripciones = [
                "Registro",
                "Rudy de Waele-Shift 2020",
                "Richard Branson-Virgin/Elon Musk-Tesla Motors",
                "Enrique Jacob Rocha-Instituto Nacional del Emprendedor\r\n\n Enrique Fernández Fassnacht-Instituto Politécnico Nacional\r\n\n Enrique Cabrero Mendoza-Consejo Nacional de Ciencia y Tecnología\r\n\n Elias Micha-Coordinador de Ciencia, Tecnología e Innovación de Presidencia\r\n\n José Franco-Foro Consultivo Científico y Tecnológico A.C *\r\n\n Jaime Urrutia-Academia Mexicana de Ciencias *\r\n\n Jaime Parada Ávila-Academia de Ingeniería de México *\r\n\n Juan Pablo Castañón-Consejo Coordinador Empresarial\r\n\n Gustavo de Hoyos Walther-Confederación Patronal de la República Mexicana",
                "Dr. Alvar Sáenz Otero-Laboratorio de Sistemas de Espacio del MIT",
                "(Industria aeronáutica y aeroespacial)\r\n\n Sergio Viñals Padilla-Director del Centro de Desarrollo Aeroespacial del IPN",
                "Moderador: Francisco Javier Mendieta Jiménez-Agencia Espacial Mexicana\r\n\n Benito Gritzewsky-Federación Mexicana de la Industria Aeroespacial, A.C.\r\n\n Miguel Álvarez Montalvo-Consejo Mexicano de Educación Aeroespacial\r\n\n Daniel André Joseph Parfait-Grupo Safran México\r\n\n Paul Antonio Quintanilla Enríquez-Thales en México\r\n\n Craig Breese-Honeywell México\r\n\n Clúster aeroespacial de Chihuahua",
                "(Sustentabilidad)\r\n\n Héctor Mayagoitia Domínguez-Coordinador de la Coordinación Politécnica para la Sustentabilidad",
                "Mauricio Lastra-Red INNOVAGRO",
                "Mario Molina-Premio Nobel de Química 1995",
                "Receso",
                "(Sustentabilidad)\r\n\n Miguel Ángel Aké Madera-Premio Nacional de Trabajo 2015",
                "Shell Huang-External Technology Acquisition, Coca Cola",
                "Luis Aguirre-Torres-GreenMomentum, Cleantech Challenge México",
                "Andrés Aharhel Mercado Velázquez y Alexis Omar Reyna Soto-ESIME, Unidad Zacatenco\r\n\n Lizeth Rocío Fuentes Cervantes-ESCA, Unidad Santo Tomás\r\n\n Dispositivo que a través de la energía cinemática del cuerpo puede cargar smartphones, tablets y reproductores de audio",
                "Julian Melchiorri - Royal College of Arts of London",
                "Moderadora: Sylvia Charles/Georgina Núñez de Insulza-Organización de Mujeres de las Américas\r\n\n Marisol Rumayor - Programa de Desarrollo Empresarial del Instituto Nacional del Emprendedor\r\n\n Ana María Sánchez Sánchez - Asociación de Mujeres Empresarias\r\n\n Alyse Nelson - Women Global Leadership, Vital Voices\r\n\n Mayra de la Torre - Organization for Women in Science for the Developing World\r\n\n Alicia Santiago - SciGirls y Fabfems\r\n\n Adriana Noreña - Mujeres ConnectAmericas\r\n\n Ana Karen Ramírez/Daniela González - Epic Queen\r\n\n Selene Orozco-IBM",
                "Cierre"
            ]
        case 1:
            self.navigationItem.title = "16 de Noviembre"
            
            self.eventos = ["Registro",
                            "Conferencia magistral (Estrategias bilaterales para el fortalecimiento de la innovación)",
                            "Fast talk (mujeres en la industria)",
                            "Conferencia magistral (Inteligencia artificial en vehículos no tripulados)",
                            "Conferencia plenaria (Tendencias en el sector automotriz)",
                            "Conferencia plenaria (Tendencias tecnológicas en la economía digital)",
                            "Fast talk (personalidad politécnica)",
                            "Panel \"Programas universitarios en grandes empresas\"",
                            "Conferencia plenaria (Internet de las cosas industrial)",
                            "Conferencia plenaria (Biotinta producción de órganos artificiales)",
                            "Receso",
                            "Fast talk (empresario joven)",
                            "Conferencia magistral (Negocios tecnológicos innovadores)",
                            "Fast talk (mujer empresarial)",
                            "Conferencia plenaria (Impresión 3D en manufactura avanzada)",
                            "Fast talk (personalidad politécnica)",
                            "Conferencia plenaria",
                            "Fast talk (personalidad politécnica)",
                            "Panel \"Geeks y diversión en aplicaciones\"",
                            "Cierre"
            ]
            
            self.horarios = ["08:00 - 09:00",
                             "09:00 - 09:30",
                             "09:30 - 09:35",
                             "09:35 - 10:20",
                             "10:20 - 11:00",
                             "11:00 - 11:40",
                             "11:40 - 11:45",
                             "11:45 - 13:05",
                             "13:05 - 13:45",
                             "13:45 - 14:30",
                             "14:30 - 15:30",
                             "15:30 - 15:35",
                             "15:35 - 16:20",
                             "16:20 - 16:25",
                             "16:25 - 17:05",
                             "17:05 - 17:10",
                             "17:10 - 17:50",
                             "17:50 - 17:55",
                             "17:55 - 19:15",
                             "19:15 - 19:20"
            ]
            
            self.descripciones = [
                "Registro",
                "Roberta S. Jacobson-Embajadora de Estados Unidos en México",
                "(Industria automotriz)\r\n\n Mayra González - NISSAN México",
                "Raúl González Rojas - Premio Nacional de Ciencias y Artes 2015, Universidad Libre de Berlín",
                "Ernesto Mariano Hernández Quiroz - General Motors México",
                "Mónica Taher-Getty Images Hispanic",
                "(Tecnologías de la información)\r\n\n Adolfo Guzmán-Arenas-Premio Nacional de Ciencias y Artes 1996",
                "Moderador: José Bernardo Rosas - NEC de México\r\n\n Jorge Silva Luján- Microsoft México\r\n\n Salvador Martínez Vidal- IBM México\r\n\n Juan Francisco Aguilar - Jump start, Dell\r\n\n Jorge Molina - Google for Work\r\n\n Antonio Mendoza - Balluff",
                "Blanca Treviño - Softtek",
                "Matti Kesti-Universidad Tecnológica de Zúrich",
                "Receso",
                "(Drones)\r\n\n Jordi Muñoz- 3D Robotics",
                "Ted Sarandos - Netflix",
                "(Decoración tecnológica)\r\n\n Jessica Banks - RockPaperRobot",
                "Avi Reichental - 3D Systems",
                "(Telecomunicaciones)\r\n\n Juan Milton Garduño-Premio Nacional de Ciencias y Artes 1990",
                "Gerardo Herrera Corral - Gran colisionador de hadrones, Cinvestav",
                "(La triple hélice y las Tecnologías de la Información)\r\n\n Luis Alfonso Villa - Centro de Investigación en Cómputo del IPN",
                "Moderador: Víctor A. Gutiérrez - Cámara Nacional de la Industria Electrónica,\r\n\n de Telecomunicaciones y Tecnologías de la información\r\n\n Equipo ganador del Hackathon Cancún Reunión Ministerial OCDE 2016, categoría Smart City\r\n\n Equipo ganador del Hackathon Campus Party 2016\r\n\n Equipo ganador del Hackathon Aldea Digital\r\n\n Equipo ganador del Hackathon del Centro de Investigación en Computación del IPN\r\n\n Alberto Beltrán - Kuruchusoft",
                "Cierre"
            ]
        case 2:
            self.navigationItem.title = "17 de Noviembre"
            
            self.eventos = ["Registro",
                            "Conferencia magistral (Ciencias de la vida y negocios)",
                            "Entrevista \"Científicos en acción\"",
                            "Conferencia magistral (Evolución dirigida)",
                            "Fast talk (personalidad politécnica)",
                            "Conferencia plenaria (Tendencias del sector farmacéutico en México)",
                            "Entrevista \"Ecosistemas exitosos en innovación\"",
                            "Clausura (Desafíos alrededor de la innovación de alto impacto)"
            ]
            
            self.horarios = ["08:00-09:00",
                             "09:00-09:45",
                             "09:45-10:45",
                             "10:45-11:30",
                             "11:30-11:35",
                             "11:35-12:15",
                             "12:15-13:15",
                             "13:15-14:00"
            ]
            
            self.descripciones = [
                "Registro",
                "Craig Venter -Human Genome Sciences, Celera, Diversa, Synthetic Genomics /\r\n\n Juan Enríquez Cabot - Synthetic Genomics, Biotechonomy, Excel Venture",
                "Moderadora: Bertha Alicia Galindo - Alcanzando el Conocimiento\r\n\n Franklin Carrero-Martínez - National Science Foundation\r\n\n Albert Isidro Llobet - R&D Division GlaxoSmithKline\r\n\n Gerardo Jiménez - Global Biotech Consulting Group",
                "Frances Arnold - Millenium Technology Prize 2016 , California Institute of Technology",
                "(La triple hélice en biotecnología)\r\n\n Mayra Pérez - Escuela Nacional de Ciencias Biológicas del IPN",
                "Alexis José Serlin - Canifarma/\r\n\n Eduardo Ortiz Tirado-Johnson&Johnson",
                "Moderador: Javier Solórzano -  Ultra noticias\r\n\n Carlos Ross - Center for Global Innovation and Entrepreneurship of Texas University (Estados Unidos)\r\n\n Alan Hughes - Center for Business Research of Cambridge University (Reino Unido)\r\n\n Rina Fainstein - P-EcoSys (Israel)",
                "Enrique Cabrero Mendoza-Consejo Nacional de Ciencia y Tecnología\r\n\n Enrique Jacob Rocha-Instituto Nacional del Emprendedor\r\n\n Enrique Fernández Fassnacht - Instituto Politécnico Nacional\r\n\n Manuel Herrera Vega - Confederación de Cámaras Industriales"
            ]
        default:
            break
        }
    }

}
