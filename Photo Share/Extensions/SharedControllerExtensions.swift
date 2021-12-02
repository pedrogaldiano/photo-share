//
//  SharedControllerStyles.swift
//  Photo Share
//
//  Created by PEDRO GALDIANO DE CASTRO on 02/12/21.
//

import Foundation
import UIKit

extension SharedController {
    func collectionViewConstraints(){
      NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
      ])
    }
  
    func addCellConstraints(_ cell: Cell) {
      NSLayoutConstraint.activate([
        cell.imageView.topAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.topAnchor, constant: 4),
        cell.imageView.bottomAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.bottomAnchor, constant: -4),
        cell.imageView.leftAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.leftAnchor, constant: 4),
        cell.imageView.rightAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.rightAnchor, constant: -4),
      ])
    }
  
    func addStyleCell(_ cell: Cell) {
      cell.layer.borderWidth = 1
      cell.layer.borderColor = UIColor.lightGray.cgColor
      cell.layer.cornerRadius = 5
    }
}

import MultipeerConnectivity
extension SharedController: MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        print("\n\n\n CHEGOOOOU AQUI \n\n\n")
        invitationHandler(true, self.mcSession)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to \(peerID.displayName)")
        case .notConnected:
            print("Could not connect to \(peerID.displayName)")
        case .connecting:
            print("Trying to connect to \(peerID.displayName)")
        @unknown default:
            print("Something went wrong when trying to connect to \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
}


