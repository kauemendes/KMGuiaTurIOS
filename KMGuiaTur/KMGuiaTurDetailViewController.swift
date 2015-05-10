//
//  KMGuiaTurDetailViewController.swift
//  KMGuiaTur
//
//  Created by Kaue Mendes on 4/25/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import CoreData

class KMGuiaTurDetailViewController: UIViewController {

    @IBOutlet weak var localNome: UILabel!
    @IBOutlet weak var labelEndereco: UILabel!
    @IBOutlet weak var isFavorito: UISwitch!
    
    var txtLocalNome : String? = ""
    var txtLabelEndereco : String? = ""
    var lisFavorito : Bool? = false
    
    var guia:Guiaturismo!
    
    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localNome.text = txtLocalNome!
        labelEndereco.text = txtLabelEndereco!
        isFavorito.on = lisFavorito!
        
        
        if( guia.isFavorito == 1 ){
            isFavorito.on = true
        } else {
            isFavorito.on = false
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didChangedIsFavorito(sender: AnyObject) {
        
        // Criar Variavel para referenciar a tabela Task
        if( isFavorito.on ){
            guia.isFavorito = 1
        } else {
            guia.isFavorito = 0
            
        }
        
        // Salvar a alteracao no banco
        managedObjectContext!.save(nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
