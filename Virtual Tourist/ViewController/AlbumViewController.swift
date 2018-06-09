//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 30/11/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit


class AlbumViewController:UIViewController
{
    var insertedIndexPaths:[NSIndexPath]!
    var deletedIndexPaths :[NSIndexPath]!
    var updatedIndexPaths :[NSIndexPath]!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var blockOperations: [BlockOperation] = []
    var pin:Pin!
    var photoCount:Int?
    
    @IBOutlet  var albumCollectionView:UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout:UICollectionViewFlowLayout!
    @IBOutlet var mapView:MKMapView!
    @IBOutlet weak var newCollectionButton:UIButton!

    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> =
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        
         fetchRequest.predicate = NSPredicate(format: "pin = %@",self.pin)

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:appDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
       return frc
        
     }()
    
    override func viewWillAppear(_ animated: Bool)
    {
        do
        {
            try fetchedhResultController.performFetch()
        }
        catch let error as NSError
        {
            print(error)
        }
        
        if(fetchedhResultController.sections?.first?.numberOfObjects == 0)
        {
            newCollectionButton.isEnabled = false
            albumCollectionView.isHidden = true
            BaseViewController.shared.getPinData(pin: pin, completionHandler:
            { (Message) in
        VirtualTouristAlert.shared.presentAlertWithCancelAndOkButton(ViewController: self, alertTitle: "Error", alertMessage: Message as! String, alertCompletionHandler:
                {_ in
                    self.appDelegate.log.debug("Alert Ok button Tapped.")
                })
            })
        }
        else
        {
            newCollectionButton.isEnabled = true
            albumCollectionView.isHidden = false
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"AlbumCell")
       
        mapView.addAnnotation(pin)
        mapView.setCenter(pin.coordinate, animated: true)
        
    }
    //MARK:TAPPED NEW COLLECTION BUTTON
    @IBAction func tappedNewCollectionSetButton(_ sender: Any)
    {
        
        for photo in fetchedhResultController.fetchedObjects as! [Photo]
        {
            appDelegate.stack.context.delete(photo)
        }
        
        appDelegate.stack.save()
       
        BaseViewController.shared.getPinData(pin: pin, completionHandler: { (Message) in
            VirtualTouristAlert.shared.presentAlertWithCancelAndOkButton(ViewController: self, alertTitle: "Error", alertMessage: Message as! String, alertCompletionHandler:
                {_ in
                    self.appDelegate.log.error(Message)
            })
        })
    }
}

//MARK:CollectionView DataSource and Delegate.
extension AlbumViewController:UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects
        {
            albumCollectionView.isHidden = false
            newCollectionButton.isEnabled = true
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = albumCollectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
        
        let photo = fetchedhResultController.object(at: indexPath) as! Photo
        
        DispatchQueue.main.async
            {
                if(photo.image != nil)
                {
                    cell.photoImageView.image = UIImage(data:photo.image! as Data)
                    cell.activityIndicator.stopAnimating()
                }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        VirtualTouristAlert.shared.presentAlertWithCancelAndOkButton(ViewController: self, alertTitle: "", alertMessage: "Dou you want to Delete.")
        { (Success) in
            if(Success == true)
            {
                let photo = self.fetchedhResultController.object(at: indexPath) as! Photo
                //DELETE PHOTO
                self.appDelegate.stack.context.delete(photo)
                self.appDelegate.stack.save()
            }
            
        }
    }
}

//MARK:NSFetchedResultsControllerDelegate
extension AlbumViewController:NSFetchedResultsControllerDelegate
{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        
        switch type
        {
        case .insert:
            insertedIndexPaths.append(newIndexPath! as NSIndexPath)
        case .update:
            updatedIndexPaths.append(indexPath! as NSIndexPath)
        case .delete:
            deletedIndexPaths.append(indexPath! as NSIndexPath)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        albumCollectionView.performBatchUpdates({
            for indexPath in self.insertedIndexPaths
            {
                self.albumCollectionView.insertItems(at: [indexPath as IndexPath])
            }
            for indexPath in self.deletedIndexPaths
            {
                self.albumCollectionView.deleteItems(at: [indexPath as IndexPath])
            }
            for indexPath in self.updatedIndexPaths
            {
                self.albumCollectionView.reloadItems(at: [indexPath as IndexPath])
            }
        }, completion: nil)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths  = [NSIndexPath]()
        updatedIndexPaths  = [NSIndexPath]()
    }
    
}
