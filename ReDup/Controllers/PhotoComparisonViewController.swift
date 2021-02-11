//
//  PhotoComparisonViewController.swift
//  ReDup
//
//  Created by Hamster on 2/6/21.
//

import UIKit
import Photos

class PhotoComparisonViewController: UIViewController {
    let maxImage = 10
    @IBOutlet weak var currentImage: UIImageView!
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var images:[UIImage] = []

    var currentImageIndex = 0
    
    @IBAction func onClickPrev(_ sender: Any) {
        if currentImageIndex != 0 {
            currentImageIndex -= 1
            currentImage.image = images[currentImageIndex]
        }
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        print(currentImageIndex, images.count)
        if currentImageIndex != images.count - 1 {
            currentImageIndex += 1
            currentImage.image = images[currentImageIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
        currentImage.image = images[currentImageIndex]

    }
    
    func fetchPhotos () {
            // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = maxImage
        
        // Fetch the image assets
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            let totalImageCountNeeded = maxImage // <-- The number of images to fetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {

            // Note that if the request is not set to synchronous
            // the requestImageForAsset will return both the image
            // and thumbnail; by setting synchronous to true it
            // will return just the thumbnail
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true

            // Perform the image request
            PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                if let image = image {
                    // Add the returned image to your array
                    self.images += [image]
                }
                // If you haven't already reached the first
                // index of the fetch result and if you haven't
                // already stored all of the images you need,
                // perform the fetch request again with an
                // incremented index
                if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                    self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
                } else {
                    // Else you have completed creating your array
                    print("Completed array: \(self.images)")
                }
            })
        }

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
