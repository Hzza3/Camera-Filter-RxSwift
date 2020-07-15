//
//  FilterService.swift
//  CameraFilter
//
//  Created by Ahmed Hazzaa on 7/15/20.
//  Copyright © 2020 Ahmed Hazzaa. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FiltersService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { (observer) -> Disposable in
            
            self.applyFilter(to: inputImage) { (filteredImage) in
                
                return observer.onNext(filteredImage)
                
            }
            
            return Disposables.create()
        }
    }
    
    
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
                
            }
            
        }
        
    }
    
}
