//
//  PhotoSelectorVC.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/25/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Photos
let cellId = "cellId"
let headerId = "headerId"

class PhotoSelectorVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var assets = [PHAsset]()
    var images = [UIImage]()
    var SelectedImage: UIImage?
    var HeaderPhoto : PhotoHeaderCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .systemBackground
        ConfigureNavBar()
        FetchData()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    fileprivate func assetsFetchOption()-> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        // number of images
        fetchOptions.fetchLimit = images.count
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        // how to sort images
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
        // to fetch images from my device
    fileprivate func FetchData(){
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOption())
        DispatchQueue.global(qos: .background).async{
            // to fetch assets from device
            allPhotos.enumerateObjects { (assets, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize   = CGSize(width: 300, height: 300)
                let option       = PHImageRequestOptions()
                option.isSynchronous = true
                imageManager.requestImage(for: assets, targetSize: targetSize, contentMode: .aspectFit, options: option) { (image, info) in
                    // to data image in array of images
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(assets)
                        if self.SelectedImage == nil {
                            self.SelectedImage = image
                        }
                    }
                    // if count of image less of images in device then reload more one
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        }
                    }
                }
            }
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SelectedImage = images[indexPath.item]
        self.collectionView.reloadData()
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    fileprivate func ConfigureNavBar(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handlerCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handlerNext))
    }
    
    @objc func handlerCancel(){
        
        dismiss(animated: true)
    }
    @objc func handlerNext(){
        let sharePostsVC = SharePostsVC()
        sharePostsVC.SelectedImage = HeaderPhoto?.headerImage.image
        navigationController?.pushViewController(sharePostsVC, animated: true)
    }
    // edged between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    // size of header cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    // header cell
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoHeaderCell
        self.HeaderPhoto = cell
        cell.headerImage.image = SelectedImage
        if let selectedImage = SelectedImage {
            if let index = self.images.firstIndex(of: selectedImage){
                let SelectedAssets = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize   = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: SelectedAssets, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                  cell.headerImage.image = image
                }
            }
        }
        
        return cell
    }
    // space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // size of collectionView cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 ) / 4
        return CGSize(width: width, height: width)
    }
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    // cell of collectionView
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.imageCell.image = images[indexPath.item]
        return cell
    }
}
