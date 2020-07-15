//
//  ViewController.swift
//  CameraFilter
//
//  Created by Ahmed Hazzaa on 7/15/20.
//  Copyright © 2020 Ahmed Hazzaa. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
            let collectionVC = navC.viewControllers.first as? PhotosCollectionViewController
            else {return}
        collectionVC.selectedPhoto.subscribe(onNext: { [weak self] (image) in
            
            self?.updateUI(with: image)
            
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        
        DispatchQueue.main.async {
            self.imageView.image = image
            self.applyFilterButton.isHidden = false
        }
    }
    
    @IBAction func applyFilterTapped(_ sender: Any) {
        
        guard let sourceImage = self.imageView.image else {
            return
        }
        
        FiltersService().applyFilter(to: sourceImage).subscribe(onNext: { [weak self](filteredImage) in
            DispatchQueue.main.async {
                self?.imageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }
    
}

