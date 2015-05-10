    //
//  KMGuiaTurPersistence.swift
//  KMGuiaTur
//
//  Created by Kaue Mendes on 4/25/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import CoreData

class KMGuiaTurPersistence: NSObject, NSFetchedResultsControllerDelegate {
   
    var manageObjectContext: NSManagedObjectContext?
    var fetchedResultController = NSFetchedResultsController()
    var session: NSURLSession?
    
    override init() {
        super.init()
        // Do any additional setup after loading the view, typically from a nib.
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: sessionConfig)
    }

    func setupCoreDataStack() -> NSManagedObjectContext? {
        // Criação do modelo
        let modelURL:NSURL? = NSBundle.mainBundle().URLForResource("guiatur", withExtension: "momd")
        
        let model = NSManagedObjectModel(contentsOfURL: modelURL!)
        
        // Criação do coordenador
        // INSTANCIAR um coordinator associado ao model ja criado
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        
        
        // Pegar o caminho para a pasta documents do sistema
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let applicationDocumentDirectory = urls.last as! NSURL
        
        // Criar uma URL do caminho da pasta documents + o nome do arquivo de banco de dados
        let url = applicationDocumentDirectory.URLByAppendingPathComponent("Guiatur.sqlite")
        var error:NSError? = nil
        println("%@", url)
        
        
        // associar o arquivo de persistencia com o coordinator, especificado o tipo (SQLLITE)
        var store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error)
        
        //se ocorrer um erro na criacao do arquivo de persistencia, logar
        if store == nil {
            println("Unresolved error \(error), \(error!.userInfo)")
            return nil
        }
        
        // Criação do Contexto
        manageObjectContext = NSManagedObjectContext()
        manageObjectContext!.persistentStoreCoordinator = coordinator
        
        return manageObjectContext
    }
    
    func getFetchedResultController(nameEntity : String, orderBy : String) -> NSFetchedResultsController {
        //Primeiro inicializamos um FetchRequest com dados da tabela Task
        let fetchRequest = NSFetchRequest( entityName: nameEntity)
        
        // Definimos que o campo usado para ordenação será "nome”
        let sortDescriptor = NSSortDescriptor(key: orderBy, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //cria um predicao que seleciona só o status com tipo 'completa’
        //        fetchRequest.predicate = NSPredicate(format: "status.tipo like 'completa'")
        
        //Iniciamos a propriedade fetchedResultController com uma instância de  NSFetchedResultsController
        //com o FetchRequest acima definido e sem opções de cache
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        //a controller será o delegate do fetch
        fetchedResultController.delegate = self
        
        
        //Executa o Fetch
        fetchedResultController.performFetch(nil)
        
        return fetchedResultController
    }
    
    func retrieveJSON(urlJSON : String){
        //URL de acesso a API do itunes, que retorna o aplicativo gratuito no topo do ranking na app store
        var url = NSURL (string:urlJSON)
        
        var task = session!.dataTaskWithURL( url!,
            completionHandler: {
                (data: NSData!, response:NSURLResponse!, error: NSError!) -> Void in
                
                if (error != nil) {
                    println(error.localizedDescription)
                } else {
                    let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        println("Executando >>> Executando o JSON")
                        self.setEntityWithData(data)
//                    })
                    
                    
                }
        })
        task.resume()
    }
    
    // Set Entity With CoreData Result
    func setEntityWithData(data : NSData ){
        //URL de acesso a API de noticias
//        self.deleteResultController(fetchedResultController)
        
        var jsonError: NSError?
        //cria um dicionario [String:AnyObject] do JSON
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)  as? [String:AnyObject]{
            //            println(json)
            let entityDescripition = NSEntityDescription.entityForName("Guiaturismo", inManagedObjectContext: manageObjectContext!)
            
            if let resultado = json["resultado"] as? [String : AnyObject] {
                
                if let locais = resultado["locais"] as? [[String : AnyObject]] {
                   
                    for local in locais {
                        let guiatur = Guiaturismo(entity: entityDescripition!, insertIntoManagedObjectContext: manageObjectContext)
                    
                        if let coordenadas = local["coordenadas"] as? [String:Float] {
                            guiatur.lat = coordenadas["lat"]!
                            guiatur.lng = coordenadas["lon"]!
                        }
                        
                        if let nome: String = local["nome"] as? String {
                            guiatur.nome = nome
                        }
                        if let endereco: String = local["endereco"] as? String {
                            guiatur.endereco = endereco
                        }
                        manageObjectContext!.save(nil)
                    }
                }
            }
            
        }
    }
    
    func deleteResultController(fetchedResultController : NSFetchedResultsController){
        for result in fetchedResultController.fetchedObjects!  {
            manageObjectContext?.deleteObject(result as! NSManagedObject)
        }
        manageObjectContext?.save(nil)
    }
    
}
