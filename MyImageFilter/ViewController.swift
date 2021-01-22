//
//  ViewController.swift
//  MyImageFilter
//
//  Created by Admin on 18/01/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    struct Filter {
        let filterName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?){
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
        
        
    }
    
    
    @IBOutlet var imgView: UIImageView!
    private var originalImage: UIImage?
 
    var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        originalImage = imgView.image
        // Do any additional setup after loading the view.
        
    }
    
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        
    guard let cgImage = image.cgImage,
          let openGLcontext = EAGLContext(api: .openGLES3) else {
            return nil
        }
        let context = CIContext(eaglContext: openGLcontext)
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.filterEffectValue,
        let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        var filteredImage: UIImage?
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent){
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        return filteredImage
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func ImgBtn(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
              imagePicker.allowsEditing = true
              present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func onClickPickImage(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func applySepia(_ sender: Any) {
        
        guard let image = imgView.image else {
            return
        }
        
        imgView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 8.0, filterEffectValueName: kCIInputIntensityKey))
    }
    
    @IBAction func applyPhotoTransferEffect(_ sender: Any) {
        
        guard let image = imgView.image else {
                   return
               }
               
               imgView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectProcess", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    @IBAction func applyNoirEffect(_ sender: Any) {
        
        guard let image = imgView.image else {
                   return
               }
               
               imgView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    @IBAction func applyBlur(_ sender: Any) {
        
        guard let image = imgView.image else {
                   return
               }
               
               imgView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIGaussianBlur", filterEffectValue: 8.0, filterEffectValueName: kCIInputRadiusKey))
    }
    
    
    @IBAction func clearFilters(_ sender: Any) {
        imgView.image = originalImage
    }
    
    


}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            self.originalImage = image
        imgView.image = image
    }
    dismiss(animated: true, completion: nil)
        
    }
}





















