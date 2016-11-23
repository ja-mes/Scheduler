//
//  AttachImagesViewController.swift
//  Scheduler
//
//  Created by James Brown on 11/23/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AttachImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var selectedImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedImages.count > 0 {
            infoLabel.text = "TAP ON A IMAGE TO REMOVE"
        } else {
            infoLabel.text = "TAP PLUS TO ADD A IMAGE"
        }
        
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            cell.imageView.image = selectedImages[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.row)
        collectionView.reloadData()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImages.append(selectedImage)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("selectedImages"), object: selectedImages)
    }

}
