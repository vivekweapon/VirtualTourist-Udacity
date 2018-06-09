//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 30/11/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController
{
    @IBOutlet var touristMapView:MKMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        touristMapView.delegate = self

        let longPressGestureRecognzr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
       
        longPressGestureRecognzr.minimumPressDuration = 0.5
        longPressGestureRecognzr.delaysTouchesBegan = true
        longPressGestureRecognzr.delegate = self as? UIGestureRecognizerDelegate
        touristMapView.addGestureRecognizer(longPressGestureRecognzr)
        
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state != UIGestureRecognizerState.ended
        {
            let touchLocation = gestureReconizer.location(in: touristMapView)
            
            let locationCoordinate = touristMapView.convert(touchLocation,toCoordinateFrom: touristMapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
           
            touristMapView.addAnnotation(annotation)
            
            return
        }
        if gestureReconizer.state != UIGestureRecognizerState.began
        {
            return
        }
    }
    
}

extension MapViewController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"AlbumVC") as! AlbumViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

