//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 30/11/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import XCGLogger


class MapViewController: UIViewController
{
    @IBOutlet var touristMapView:MKMapView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tappedPin:Pin!
    var EditTapped = false
    var editButton:UIBarButtonItem!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        touristMapView.addAnnotations(getPins())

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
       
        longPressGestureRecognizer.delaysTouchesBegan = true
        longPressGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        touristMapView.addGestureRecognizer(longPressGestureRecognizer)
        
        editButton = UIBarButtonItem(title:"Edit",style:.plain,target:self,action:#selector(self.editButtonTapped(sender:)))
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func isEditTapped()
    {
        EditTapped = true
    }
    
    //MARK:Get Pin Data.
    func getPins()->[Pin]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        var pins = [Pin]()
       
        do
        {
            let pinResults = try appDelegate.stack.context.fetch(fetchRequest)
            pins = pinResults as! [Pin]
        }
        
        catch
        {
            VirtualTouristAlert.shared.presentAlertView(ViewController: self, alertTitle: "Error", alertMessage:"Could not fetch Pins.", completionHandler:
            { (Success) in
                
                if(Success == true)
                {
                    self.appDelegate.log.debug("Fetch Pins Success.")
                }
                else
                {
                    self.appDelegate.log.debug("Fetch Pins Failure.")

                }

            })
        }
        return pins
    }
    // MARK: EditButton
    @objc func editButtonTapped(sender:UIBarButtonItem)
    {
        if sender.title == "Edit"
        {
            EditTapped = true
            sender.title = "Done"
            
            UIView.animate(withDuration: 1.0)
            {
                self.view.frame.origin.y -= 60
            }
        }
        else
        {
            EditTapped = false
            sender.title = "Edit"
            UIView.animate(withDuration: 1.0)
            {
                self.view.frame.origin.y += 60
            }
        }
    }
    
    //MARK:LongPress
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer)
    {
        if(EditTapped == true)
        {
            return
        }
        
        let tapLoc = gestureReconizer.location(in: touristMapView)
        let coordinate = touristMapView.convert(tapLoc,toCoordinateFrom: touristMapView)
        
        switch gestureReconizer.state
        {
       
        case UIGestureRecognizerState.began:
            DispatchQueue.main.async
            {
                let pin = BaseViewController.shared.createPinEntity(locationCoordinate: coordinate)
                self.tappedPin = pin as! Pin
                self.touristMapView.addAnnotation(self.tappedPin)
            }
            
        case UIGestureRecognizerState.changed:
            
            self.tappedPin.willChangeValue(forKey: "coordinate")
            self.tappedPin.coordinate = coordinate
            self.tappedPin.didChangeValue(forKey: "coordinate")
       
        case UIGestureRecognizerState.ended:
            DispatchQueue.main.async
            {
                BaseViewController.shared.getPinData(pin: self.tappedPin, completionHandler:
                    { (Message) in
                        
                        self.appDelegate.stack.save()
                        VirtualTouristAlert.shared.presentAlertWithCancelAndOkButton(ViewController: self, alertTitle: "Error", alertMessage: Message as! String, alertCompletionHandler:
                            {_ in
                                self.appDelegate.log.error("Error Alert.")
                        })
                })
            }
            
        default:
            return
        }
    }
}

//MARK: Map Delegate
extension MapViewController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
       
        let identifier = "pin"
        let pinView = touristMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView.isDraggable = true
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let annotation = view.annotation as! Pin
        view.isSelected = false

        if(EditTapped == true)
        {
            //delete selected button
            touristMapView.removeAnnotation(annotation)
            appDelegate.stack.context.delete(annotation)
            appDelegate.stack.save()
            
        }
        else
        {
            touristMapView .deselectAnnotation(annotation, animated: true)

            let storyBoard = UIStoryboard(name:"Main",bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier:"AlbumVC") as! AlbumViewController
            
            vc.pin = annotation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

