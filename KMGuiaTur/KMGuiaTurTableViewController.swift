//
//  KMGuiaTurTableViewController.swift
//  KMGuiaTur
//
//  Created by Kaue Mendes on 4/25/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import CoreData

class KMGuiaTurTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{

    var manageObjectContext: NSManagedObjectContext?
    var fetchedResultController = NSFetchedResultsController()
    let guiaturPersistence = KMGuiaTurPersistence()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guiaturPersistence.setupCoreDataStack()
        guiaturPersistence.getFetchedResultController("Guiaturismo", orderBy: "nome")
        
        //Deleta 
//        guiaturPersistence.deleteResultController(guiaturPersistence.fetchedResultController)
        
        if ( guiaturPersistence.fetchedResultController.fetchedObjects?.count == 0 ) {
            guiaturPersistence.retrieveJSON("http://127.0.0.1:8888/ptosTuristicos.json")
            guiaturPersistence.getFetchedResultController("Guiaturismo", orderBy: "nome")
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let numbersOfRowsInSection = guiaturPersistence.fetchedResultController.fetchedObjects?.count
        
        println("Por favor \(numbersOfRowsInSection)")
        
        return numbersOfRowsInSection!
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        let guia = guiaturPersistence.fetchedResultController.objectAtIndexPath(indexPath) as! Guiaturismo
        
        
        cell.textLabel?.text = guia.nome
        cell.accessoryView = nil
        
        if ( guia.isFavorito.boolValue ){
            println("Ta passando aqui")
            var image = UIImage(named: "favorite_star")
            cell.accessoryView = UIImageView(image: image)
        }   
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let guia = guiaturPersistence.fetchedResultController.objectAtIndexPath(indexPath) as! Guiaturismo
        performSegueWithIdentifier("performWithSegue", sender: guia)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.

        let viewInfo:KMGuiaTurDetailViewController = segue.destinationViewController as! KMGuiaTurDetailViewController

        if let guia = sender as? Guiaturismo {
            viewInfo.guia = guia
            viewInfo.txtLocalNome = guia.nome
            viewInfo.txtLabelEndereco = guia.endereco
            viewInfo.lisFavorito = (guia.isFavorito == 1 ? true : false )
            
        }
        
        viewInfo.managedObjectContext    = guiaturPersistence.manageObjectContext
        viewInfo.fetchedResultController = guiaturPersistence.fetchedResultController
     
        tableView.reloadData()
    }


}
