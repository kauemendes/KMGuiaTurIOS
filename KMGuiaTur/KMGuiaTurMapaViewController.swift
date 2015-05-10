//
//  KMGuiaTurMapaViewController.swift
//  KMGuiaTur
//
//  Created by Kaue Mendes on 4/25/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class KMGuiaTurMapaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var myLocations: [CLLocation] = []
    var manager:CLLocationManager!
    let guiaturPersistence = KMGuiaTurPersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Deleta
        //        guiaturPersistence.deleteResultController(guiaturPersistence.fetchedResultController)
        
        if ( guiaturPersistence.fetchedResultController.fetchedObjects?.count == 0 ) {
            guiaturPersistence.retrieveJSON("http://127.0.0.1:8888/ptosTuristicos.json")
            guiaturPersistence.getFetchedResultController("Guiaturismo", orderBy: "nome")
        }
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.requestWhenInUseAuthorization()
        
        //Setup our Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.showsUserLocation = true
        mapView.zoomEnabled = true
        
        println("Carregou")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guiaturPersistence.setupCoreDataStack()
        guiaturPersistence.getFetchedResultController("Guiaturismo", orderBy: "nome")
        println("CARREGANDO LOADPINGS")
        self.loadPins()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func loadPins(){
        
        
        var placemarks = NSMutableArray()
        
        for locations in guiaturPersistence.fetchedResultController.fetchedObjects! {
            if let guia = locations as? Guiaturismo {
               
                if guia.isFavorito == 1 {
                } else {
                }
                
                let latitude  : Double = guia.lat as Double
                let longitude : Double = guia.lng as Double
                
                let coordinate:CLLocationCoordinate2D  = CLLocationCoordinate2DMake(latitude, longitude)
                
             
                let guiaAnnotations = KMGuiaTurAnnotation(coordinate: coordinate, guia: guia)
                placemarks.addObject(guiaAnnotations)
                self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 4000, 4000)
            }

        }
        self.clearAnnotations()
        self.mapView.addAnnotations(placemarks as [AnyObject])
        
        
    }
    
    func clearAnnotations()
    {
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        self.mapView.removeAnnotations( annotationsToRemove )
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        
        
        if annotation is KMGuiaTurAnnotation{
            
            //verificar se a marcação já existe para tentar reutilizá-la
            let reuseId = "pontosAnnot"
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            println(anView)
            println(annotation)
            
            //se a view não existir
            if anView == nil {
                //criar a view como subclasse de MKAnnotationView
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                
                // var image = annotation.getFavoritoImage()
                
                //trocar a imagem pelo logo da FIAP
                anView.image = UIImage(named:"simplePin")
                
                //permitir que mostre o "balão" com informações da marcação
                anView.canShowCallout = true
                
                //adiciona um botão do lado direito do balão para futuro 'tap'
                anView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
            
            return anView
            
            
        }
        
        return nil
    }

    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!){
        
        if view.annotation is KMGuiaTurAnnotation
        {
//            self.displayRegionCenteredOnMapItem((view.annotation as! KMGuiaTurAnnotation).mapItem)
        }
        
        
        
    }
    
    /*
    func displayRegionCenteredOnMapItem (from:MKMapItem){
        //Obtem a localizacao do item passado como parametro
        let fromLocation: CLLocation = from.placemark.location;
        
        let region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
        
        let span = NSValue(MKCoordinateSpan:self.mapView.region.span)
        let opts = [
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan:region.span),
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: region.center)
        ]
        from.openInMapsWithLaunchOptions(opts)
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
