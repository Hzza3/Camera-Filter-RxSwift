//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by Ahmed Hazzaa on 7/15/20.
//  Copyright © 2020 Ahmed Hazzaa. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {
    
    var images = [PHAsset]()
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatePhotos()
    }
    
    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization {  [weak self] (status) in
            if status == .authorized {
                
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                assets.enumerateObjects { (asset, index, stop) in
                    self?.images.append(asset)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell {
            
            let asset = images[indexPath.row]
            let manager = PHImageManager.default()
            manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: nil) { (image, info) in
                
                guard let info = info else {return}
                
                let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
                
                if !isDegradedImage {
                    if let image = image {
                        DispatchQueue.main.async {
                            cell.photoImageView.image = image
                        }
                    }
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageAsset = images[indexPath.row]
        
        PHImageManager.default().requestImage(for: imageAsset, targetSize: CGSize(width: 300.0, height: 300.0), contentMode: .aspectFit, options: nil) { [weak self] (image, info) in
            
            guard let info = info else {return}
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}
