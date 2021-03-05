//
//  VideoPickerViewController+Transitions.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

// MARK: - Custom Transitions
extension VideoPickerViewController {
    
    func transition(to playerVC: VideoPlayerViewController, withTransitionImage transitionImage: UIImage) {
        logIN()
        // Prepare the player view-controller for transition.
        playerVC.loadViewIfNeeded()
        playerVC.view.frame = view.bounds
        playerVC.updateLayout()
        addChildViewController(playerVC)
        playerVC.view.alpha = 0
        playerVC.playerView.isHidden = true
        view.addSubview(playerVC.view)
        
        // Set initial frame of the transition view to the same frame as the selected cell.
        let selectedCell = collectionView.cellForItem(at: selectedIndexPath!) as! VideoPickerCell
        let thumbnailFrame = view.convert(selectedCell.thumbnailView.frame, from: selectedCell.thumbnailView.superview)
        let transitionView = UIImageView(image: transitionImage)
        transitionView.frame = thumbnailFrame
        transitionView.contentMode = .scaleAspectFill
        transitionView.layer.masksToBounds = true
        view.addSubview(transitionView)
        
        // Calculate the frame to which we animate the transition view. This should correspond exactly with
        // the player view's presentation size, i.e. the size of the content as it is scaled to fit the player view's bounds.
        let aspect = transitionImage.size.width / transitionImage.size.height
        let fitSize = playerVC.playerView.frame.sizeThatFitsInside(withAspect: aspect)
        let toCenter = view.convert(playerVC.playerView.center, from: playerVC.playerView.superview)
        let transitionViewToFrame = CGRect(center: toCenter, size: fitSize)
        
        // Transport the player toolbar along with transition.
        let playerToolbar = playerVC.playerToolbar!
        let playerToolbarToFrame = view.convert(playerToolbar.frame, from: playerToolbar.superview)
        playerToolbar.frame = playerToolbarToFrame.offsetBy(dx: 0, dy: playerToolbarToFrame.size.height)
        view.addSubview(playerToolbar)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            transitionView.frame = transitionViewToFrame
            playerVC.view.alpha = 1
        }, completion: { finished in
            // Remove the transition image and reveal the player view.
            playerVC.playerView.isHidden = false
            transitionView.removeFromSuperview()
            playerVC.transitionView = transitionView
            
            // Put back the player toolbar.
            playerVC.view.addSubview(playerToolbar)
            playerVC.updateLayout()
            
            // Complete the transition.
            playerVC.didMove(toParentViewController: self)
        })
        // Animate the player toolbar without bouncing.
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            playerToolbar.frame = playerToolbarToFrame
        }, completion: nil)
        
        logOUT()
    }
    
    func transition(from playerVC: VideoPlayerViewController, withTransitionImage transitionImage: UIImage?) {
        logIN()
        guard let transitionImage = transitionImage else {
            // TODO: Handle transition without image.
            logError("Can't make transition without a transition image.")
            logOUT()
            return
        }
        
        let aspect = transitionImage.size.width / transitionImage.size.height
        let fitSize = playerVC.playerView.frame.sizeThatFitsInside(withAspect: aspect)
        let fromCenter = view.convert(playerVC.playerView.center, from: playerVC.playerView.superview)
        let fromFrame = CGRect(center: fromCenter, size: fitSize)
        
        let transitionView = UIImageView(image: transitionImage)
        transitionView.contentMode = .scaleAspectFill
        transitionView.layer.masksToBounds = true
        transitionView.frame = fromFrame
        view.addSubview(transitionView)
        
        let selectedCell = collectionView.cellForItem(at: selectedIndexPath!) as! VideoPickerCell
        let thumbnailFrame = view.convert(selectedCell.thumbnailView.frame, from: selectedCell.thumbnailView.superview)
        
        // Transport the player toolbar along with transition.
        let playerToolbar = playerVC.playerToolbar!
        playerToolbar.frame = view.convert(playerToolbar.frame, from: playerToolbar.superview)
        view.addSubview(playerToolbar)
        
        let playerToolbarToFrame = playerToolbar.frame.offsetBy(dx: 0, dy: playerToolbar.frame.size.height)
        
        playerVC.willMove(toParentViewController: nil)
        playerVC.playerView.isHidden = true
        playerVC.disableLayoutUpdates = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            transitionView.frame = thumbnailFrame
            playerVC.view.alpha = 0
            playerToolbar.frame = playerToolbarToFrame
        }, completion: { finished in
            // Remove transition views
            transitionView.removeFromSuperview()
            playerToolbar.removeFromSuperview()
            
            // Complete the transition.
            playerVC.view.removeFromSuperview()
            playerVC.removeFromParentViewController()
            playerVC.didMove(toParentViewController: nil)
        })
        
        // Reset the current player view controller
        playerViewController = nil
        
        logOUT()
    }
}
