//
//  VideoPickerViewController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit
import Photos

class VideoPickerViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    var videoAssetsFetchResult: PHFetchResult<PHAsset>? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let imageManager = PHImageManager.default() // TODO: Use PHCachingImageManager
    
    var selectedIndexPath: IndexPath?
    
    var selectedAsset: PHAsset? {
        guard let videoAssetsFetchResult = self.videoAssetsFetchResult, let selectedIndexPath = selectedIndexPath else { return nil }
        return videoAssetsFetchResult[selectedIndexPath.row]
    }
    
    let cellReuseID = "cellReuseID"
    let headerReuseID = "headerReuseID"
    let footerReuseID = "footerReuseID"
    
    var playerViewController: VideoPlayerViewController? {
        didSet {
//            // Reset the current asset when the selected asset is dismissed (closing the player view-controller)
//            if playerViewController == nil {
//                BlurryAssetManager.shared.currentAsset = nil
//            }
            if playerViewController == nil {
                AppDelegate.shared.mainViewController.viewControllerForStatusBarAppearance = customNavigationController
                customNavigationController?.viewControllerForNavigationBarAppearance = self
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Library"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        collectionView.register(VideoPickerCell.self, forCellWithReuseIdentifier: cellReuseID)
        collectionView.register(VideoPickerHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseID)
        collectionView.register(VideoPickerFooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        fetchVideoAssets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        collectionView.frame = view.bounds
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
    }
    
    func fetchVideoAssets() {
        logIN()
        let videoSmartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
        var fetchResult: PHFetchResult<PHAsset>?
        if let videoSmartAlbum = videoSmartAlbumsFetchResult.firstObject {
            let fetchOptions = PHFetchOptions()
            // Fetch only video assets that are not streamed over a network connection (ex. shared videos in a subscribed iCloud Photo Stream).
            fetchOptions.predicate = NSPredicate(format: "(mediaType == %i) && !((mediaSubtype & %d) == %d)",
                                                 PHAssetMediaType.video.rawValue, PHAssetMediaSubtype.videoStreamed.rawValue, PHAssetMediaSubtype.videoStreamed.rawValue)
            fetchResult = PHAsset.fetchAssets(in: videoSmartAlbum, options: fetchOptions)
        } else {
            logError("Could not load the videos smart album.")
            // TODO: Handle error
        }
        self.videoAssetsFetchResult = fetchResult
        logOUT()
    }

    func loadURLAssetAsync(forVideo asset: PHAsset, playerVC: VideoPlayerViewController) {
        logIN()
        let requestOptions = PHVideoRequestOptions()
        requestOptions.isNetworkAccessAllowed = false
        requestOptions.version = .current
        requestOptions.deliveryMode = .highQualityFormat
        // TODO: Use progressHandler to show loading progress in case it takes too long
        
        DispatchQueue.global().async {
            self.imageManager.requestAVAsset(forVideo: asset, options: requestOptions)
            { (urlAsset: AVAsset?, _: AVAudioMix?, info: [AnyHashable : Any]?) in
                
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    guard playerVC == weakSelf.playerViewController else { return }
                    if let urlAsset = urlAsset as? AVURLAsset {
                        playerVC.asset = urlAsset
                    } else {
                        logError("Failed to load AVURLAsset for PHAsset.")
                        if let error = info?[PHImageErrorKey] as? NSError {
                            logError(error.localizedDescription)
                        }
                        // TODO: Handle error
                    }
                }
            }
        }
        logOUT()
    }
}

// MARK: - Collection View Data Source & Delegate
extension VideoPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let videoAssetsFetchResult = self.videoAssetsFetchResult else { return 0 }
        return videoAssetsFetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! VideoPickerCell
        let asset = videoAssetsFetchResult![indexPath.item]
        cell.assetIdentifier = asset.localIdentifier
        
        // Load thumbnail image for asset
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic // resultHandler may be called synchronously on the calling thread if any image data is immediately available
        requestOptions.resizeMode = .fast // use targetSize as a hint. the delivered image may be larger than targetSize
        requestOptions.isSynchronous = false // resultHandler always called on main thread. resultHandler may be called 1 or more times.
        
        imageManager.requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: requestOptions)
        { [weak self] (image: UIImage?, info: [AnyHashable : Any]?) in
            guard let _ = self else { return }
            // Check if the cell hasn't been reused for another asset
            guard cell.assetIdentifier == asset.localIdentifier else { return }
            if let thumbnail = image {
                cell.thumbnailView.image = thumbnail
                cell.duration = asset.duration
            } else {
                logError("Failed to load thumbnail image for asset.")
                if let error = info?[PHImageErrorKey] as? NSError {
                    logError(error.localizedDescription)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseID, for: indexPath) as! VideoPickerHeaderCell
            return header
        }
        if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseID, for: indexPath) as! VideoPickerFooterCell
            footer.itemsCount = collectionView.numberOfItems(inSection: 0)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        logIN()
        selectedIndexPath = indexPath
        let currentAsset = self.selectedAsset!
        
        // Ensure there's no player view-controller still loading (unlikely but possible)
        if let playerVC = playerViewController {
            playerVC.willMove(toParentViewController: nil)
            playerVC.view.removeFromSuperview()
            playerViewController = nil
        }
        
        // Load large image for transition
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat // client will get one result only and it will be as asked or better than asked (sync requests are automatically processed this way regardless of the specified mode)
        requestOptions.resizeMode = .exact // Does not apply when size is PHImageManagerMaximumSize
        requestOptions.isSynchronous = true // return only a single result, blocking until available (or failure)
        
        DispatchQueue.global().async {
            self.imageManager.requestImage(for: currentAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions)
            { (image: UIImage?, info: [AnyHashable : Any]?) in
                
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    guard weakSelf.selectedAsset?.localIdentifier == currentAsset.localIdentifier else {
                        logDebug("Another item was selected in the collection view while requesting image for selected asset.")
                        return
                    }
                    if let largeImage = image {
                        let playerVC = VideoPlayerViewController()
                        weakSelf.loadURLAssetAsync(forVideo: currentAsset, playerVC: playerVC)
                        weakSelf.transition(to: playerVC, withTransitionImage: largeImage)
                        weakSelf.playerViewController = playerVC
                        
//                        let playerVC = VideoPlayerViewController()
//                        weakSelf.loadURLAssetAsync(forVideo: currentAsset, playerVC: playerVC)
//                        weakSelf.customNavigationController?.push(newController: playerVC)
//                        weakSelf.playerViewController = playerVC
                    } else {
                        logError("Failed to load large image for asset.")
                        if let error = info?[PHImageErrorKey] as? NSError {
                            logError(error.localizedDescription)
                        }
                        // TODO: Handle error
                    }
                }
            }
        }
        logOUT()
    }
}

// MARK: - Flow Layout Delegate
extension VideoPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.size.width - CGFloat(columnsCount - 1) * itemSpacing) / CGFloat(columnsCount)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: itemSpacing, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: footerHeight)
    }
}

// MARK: - UI Constants

private let footerHeight: CGFloat = 60

extension VideoPickerViewController {
    
    var headerHeight: CGFloat {
        return 44
    }
    
    var columnsCount: Int {
        return 3
    }
    
    var thumbnailSize: CGSize {
        return CGSize(width: 150, height: 150) // TODO: This should be the same as cell size and calculated based on screen resolution
    }
    
    var itemSpacing: CGFloat {
        switch UIScreen.resolution {
        case UIScreenResolution640x960, UIScreenResolution640x1136:
            return 1
        case UIScreenResolution750x1334:
            return 1.5
        default:
            return 1
        }
        // TODO: Calculate item spacing for other screen resolutions
    }
}
