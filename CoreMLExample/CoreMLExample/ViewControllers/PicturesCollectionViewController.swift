//
//  AppDelegate.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

class PicturesCollectionViewController: UICollectionViewController {

  var images: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadHardCodedPictures()
    loadSavedPictures()
  }
  
  private func loadHardCodedPictures() {
    //This is for development and debugging purposes.
    //Just add any JPG image to the resource bundle and it will be loaded in the collection view, to start
    let imagePaths = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: nil)
    imagePaths.flatMap { UIImage(named: $0)}.forEach { images.append($0)}
  }
  
  private func loadSavedPictures() {
    let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let imageUrls = try! FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter { $0.pathExtension == "jpg"}
    imageUrls.forEach { url in
      if let data = try? Data(contentsOf: url),
        let image = UIImage(data: data) {
        images.append(image)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "imageDetail" else { return }
    let cell = sender as! PictureCollectionViewCell
    let indexPath = collectionView!.indexPath(for: cell)!
    let image = images[indexPath.row]
    let imageController = segue.destination as! ImageViewController
    imageController.image = image
  }

}

extension PicturesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PictureCollectionViewCell
        cell.imageView.image = images[indexPath.row]

        return cell
    }
}

extension PicturesCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBAction func addImage(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .savedPhotosAlbum
    present(picker, animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true)

    guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
      else { fatalError("no image from image picker") }
    images.append(uiImage)
    collectionView?.insertItems(at: [IndexPath(row: images.count - 1, section: 0)])
    saveImage(image: uiImage)
  }
  
  func saveImage(image: UIImage) {
    let data = UIImageJPEGRepresentation(image, 1.0)!
    let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let url = documentDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
    try! data.write(to: url)
  }
}
