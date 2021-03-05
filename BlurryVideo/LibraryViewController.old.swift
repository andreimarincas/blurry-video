////
////  LibraryViewController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/17/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import Photos
//
//class LibraryViewController: UIViewController {
//    
//    var collectionView: UICollectionView!
//    
//    var videoAssetsFetchResult: PHFetchResult<PHAsset>? {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
//    
//    let imageManager = PHImageManager.default()
//    let cachingImageManager = PHCachingImageManager()
//    
//    var selectedIndexPath: IndexPath?
//    
//    var selectedAsset: PHAsset? {
//        guard let videoAssetsFetchResult = self.videoAssetsFetchResult, let selectedIndexPath = selectedIndexPath else { return nil }
//        return videoAssetsFetchResult[selectedIndexPath.row]
//    }
//    
//    let cellReuseID = "cellReuseID"
//    let headerReuseID = "headerReuseID"
//    let footerReuseID = "footerReuseID"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.backgroundColor = .clear
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.showsVerticalScrollIndicator = true
//        collectionView.alwaysBounceVertical = true
//        collectionView.register(LibraryCell.self, forCellWithReuseIdentifier: cellReuseID)
//        collectionView.register(LibraryHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseID)
//        collectionView.register(LibraryFooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseID)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        view.addSubview(collectionView)
//        
//        fetchVideoAssets()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateLayout()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout() {
//        collectionView.frame = view.bounds
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
//    }
//    
//    func fetchVideoAssets() {
//        logIN()
//        let videoSmartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
//        var fetchResult: PHFetchResult<PHAsset>?
//        if let videoSmartAlbum = videoSmartAlbumsFetchResult.firstObject {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "mediaType == %i", PHAssetMediaType.video.rawValue)
//            fetchResult = PHAsset.fetchAssets(in: videoSmartAlbum, options: fetchOptions)
//        }
//        self.videoAssetsFetchResult = fetchResult
//        logOUT()
//    }
//    
//    func showPlayerViewController(for asset: AVURLAsset) {
//        logIN()
//        let currentAsset = self.selectedAsset!
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.resizeMode = .exact
//        imageManager.requestImage(for: currentAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions, resultHandler: { [weak self] (image, _) in
//            guard let weakSelf = self else { return }
//            guard weakSelf.selectedAsset?.localIdentifier == currentAsset.localIdentifier else {
//                logDebug("Another video was selected in the collection view while requesting image for selected asset.")
//                return
//            }
//            if let image = image {
//                let playerVC = LibraryPlayerViewController()
//                playerVC.asset = asset
//                weakSelf.transition(to: playerVC, withTransitionImage: image)
//            } else {
//                logError("Failed to load transition image for asset.") // TODO: Handle error
//            }
//        })
//        logOUT()
//    }
//}
//
//// MARK: - Collection View Data Source & Delegate
//extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let videoAssetsFetchResult = self.videoAssetsFetchResult else { return 0 }
//        return videoAssetsFetchResult.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        logIN()
//        logDebug("Request cell for item at index path: \(indexPath.row)")
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! LibraryCell
//        guard let videoAssetsFetchResult = self.videoAssetsFetchResult else {
//            logWarning("No video assets.")
//            logOUT()
//            return cell
//        }
//        let videoAsset = videoAssetsFetchResult[indexPath.item]
//        cell.assetIdentifier = videoAsset.localIdentifier
//        
//        // Load thumbnail image for asset
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.resizeMode = .fast
//        requestOptions.isSynchronous = false // resultHandler for asynchronous requests, always called on main thread
//        
//        DispatchQueue.global().async {
//            self.imageManager.requestImage(for: videoAsset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: requestOptions)
//            { [weak self] (image: UIImage?, info: [AnyHashable : Any]?) in
//                guard let _ = self else { return }
//                if cell.assetIdentifier == videoAsset.localIdentifier {
//                    cell.thumbnailView.image = image
//                    cell.duration = videoAsset.duration
//                }
//            }
//        }
//        logOUT()
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseID, for: indexPath) as! LibraryHeaderCell
//            return header
//        }
//        if kind == UICollectionElementKindSectionFooter {
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseID, for: indexPath) as! LibraryFooterCell
//            footer.itemsCount = collectionView.numberOfItems(inSection: 0)
//            return footer
//        }
//        return UICollectionReusableView()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        logIN()
//        guard let videoAssetsFetchResult = self.videoAssetsFetchResult else {
//            logWarning("No video assets.")
//            logOUT()
//            return
//        }
//        selectedIndexPath = indexPath
//        let videoAsset = videoAssetsFetchResult[indexPath.row]
//        cachingImageManager.requestAVAsset(forVideo: videoAsset, options: nil) { [weak self] (asset, audioMix, args) in
//            guard let weakSelf = self else { return }
//            guard let urlAsset = asset as? AVURLAsset else {
//                logError("Can't load AVURLAsset for PHAsset.")
//                return
//            }
//            DispatchQueue.main.async {
//                guard weakSelf.selectedAsset?.localIdentifier == videoAsset.localIdentifier else {
//                    logDebug("Another video was selected in the collection view while requesting AVURLAsset.")
//                    return
//                }
//                weakSelf.showPlayerViewController(for: urlAsset)
//            }
//        }
//        logOUT()
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        logIN()
////        selectedIndexPath = indexPath
////        let currentAsset = self.selectedAsset!
////        let playerVC = LibraryPlayerViewController()
////        
////        // Load full resolution image for transition
////        let imageRequestOptions = PHImageRequestOptions()
////        imageRequestOptions.resizeMode = .exact
////        imageRequestOptions.isSynchronous = false // resultHandler for asynchronous requests, always called on main thread
////        
////        DispatchQueue.global().async {
////            self.imageManager.requestImage(for: currentAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageRequestOptions)
////            { [weak self] (image: UIImage?, info: [AnyHashable : Any]?) in
////                guard let weakSelf = self else { return }
////                guard weakSelf.selectedAsset?.localIdentifier == currentAsset.localIdentifier else {
////                    logDebug("Another item was selected in the collection view while requesting image for selected asset.")
////                    return
////                }
////                if let image = image {
////                    weakSelf.transition(to: playerVC, withTransitionImage: image)
////                } else {
////                    logError("Failed to load transition image for asset.") // TODO: Handle error
////                    if let error = info?[PHImageErrorKey] as? NSError {
////                        logError(error.localizedDescription)
////                    }
////                }
////            }
////        }
////        
////        // Load player item for asset
////        let videoRequestOptions = PHVideoRequestOptions()
////        videoRequestOptions.isNetworkAccessAllowed = false
////        videoRequestOptions.version = .current // .original
////        // TODO: Ask use for either current or original
////        videoRequestOptions.deliveryMode = .highQualityFormat
////        // TODO: Use progressHandler to show loading progress in case it takes too long
////        
////        DispatchQueue.global().async {
////            self.cachingImageManager.requestPlayerItem(forVideo: currentAsset, options: videoRequestOptions)
////            { (playerItem: AVPlayerItem?, info: [AnyHashable : Any]?) in
////                
////                DispatchQueue.main.async { [weak self] in
////                    guard let weakSelf = self else { return }
////                    guard weakSelf.selectedAsset?.localIdentifier == currentAsset.localIdentifier else {
////                        logDebug("Another item was selected in the collection view while requesting player item for selected asset.")
////                        return
////                    }
////                    if let playerItem = playerItem {
////                        playerVC.playerItem = playerItem
////                    } else {
////                        logError("Failed to load player item for asset.") // TODO: Handle error
////                        if let error = info?[PHImageErrorKey] as? NSError {
////                            logError(error.localizedDescription)
////                        }
////                    }
////                }
////            }
////        }
////        logOUT()
////    }
//}
//
//// MARK: - Flow Layout Delegate
//extension LibraryViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = (collectionView.frame.size.width - CGFloat(columnsCount - 1) * itemSpacing) / CGFloat(columnsCount)
//        return CGSize(width: itemWidth, height: itemWidth)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: itemSpacing, left: 0, bottom: 0, right: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return itemSpacing
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return itemSpacing
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: headerHeight)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: footerHeight)
//    }
//}
//
//// MARK: - UI Constants
//
//private let footerHeight: CGFloat = 60
//
//extension LibraryViewController {
//    
//    var headerHeight: CGFloat {
//        if let navigationController = self.parent as? NavigationController {
//            return navigationController.navigationBarHeight
//        }
//        return 0
//    }
//    
//    var columnsCount: Int {
//        return 3
//    }
//    
//    var thumbnailSize: CGSize {
//        return CGSize(width: 150, height: 150) // TODO: This should be the same as cell size and calculated based on screen resolution
//    }
//    
//    var itemSpacing: CGFloat {
//        switch UIScreen.resolution {
//        case UIScreenResolution640x960, UIScreenResolution640x1136:
//            return 1
//        case UIScreenResolution750x1334:
//            return 1.5
//        default:
//            return 1
//        }
//        // TODO: Calculate item spacing for other screen resolutions
//    }
//}
