import UIKit
import MultipeerConnectivity

class SharedController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    lazy var images = { return [UIImage]() }()
    var collectionView: UICollectionView!
    var mcSession: MCSession?
    var peerID: MCPeerID?
//    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    var mcAdvertiserAssistant: MCNearbyServiceAdvertiser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shared"
        view.backgroundColor = .systemBackground
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
        collectionView = createCollectionView()
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewConstraints()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importImage)
          )
        
        let seeDevicesConnected = UIBarButtonItem(
            image: UIImage(systemName: "cloud"),
            style: .plain,
            target: self,
            action: #selector(devicesConnected)
        )
                
        let showConnectionPrompt = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(showConnectionPrompt))
        
        navigationItem.rightBarButtonItems = [showConnectionPrompt, seeDevicesConnected]
    }
    
    
    @objc func importImage() {
      let picker = UIImagePickerController()
      picker.allowsEditing = true
      picker.delegate = self
      present(picker, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell.")
        }
          
        cell.imageView.image = images[indexPath.item]
        cell.imageView.contentMode = .scaleToFill
  
        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.addSubview(cell)
        cell.addSubview(cell.imageView)
                
        addCellConstraints(cell)
        addStyleCell(cell)

        return cell
    }
    
    func createCollectionView() -> UICollectionView {
            let layout = UICollectionViewFlowLayout()
          
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            layout.itemSize = CGSize(width: 120, height: 150)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          
            collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
          
            collectionView.delegate = self
            collectionView.dataSource = self
          
            return collectionView
    }
    
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHost))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func startHost(action: UIAlertAction) {
//        guard let mcSession = mcSession else { return }
//        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "photo-share", discoveryInfo: nil, session: mcSession)
        
        mcAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID!, discoveryInfo: nil, serviceType: "photo-share")
        mcAdvertiserAssistant?.delegate = self
        mcAdvertiserAssistant?.startAdvertisingPeer()
        
//        mcAdvertiserAssistant?.start()
        }
    
    @objc func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "photo-share", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        }
    
    @objc func devicesConnected(){
        var devices = ""
        
        if let mcSession = mcSession {
            if mcSession.connectedPeers.count > 0 {
                for device in mcSession.connectedPeers {
                    devices += "\(device.displayName)\n"
                }
            devices = devices.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let ac = UIAlertController(title: "Devices connected", message: devices, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            ac.addAction(UIAlertAction(title: "Disconnect", style: .default, handler: disconnectDevices))
            present(ac, animated: true)
                
            } else {
                let ac = UIAlertController(title: "No device connected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
            }
        }
    }
                     
      func disconnectDevices(_: UIAlertAction) {
            mcSession?.disconnect()
    }
}


extension SharedController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
    guard let image = info[.editedImage] as? UIImage else { return }
    images.insert(image, at: 0)
    collectionView.reloadData()
    
    dismiss(animated: true)
      
      guard let mcSession = mcSession else { return }
      
      if mcSession.connectedPeers.count > 0 {
          if let imageData = image.pngData() {
              do {
                  try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
              } catch {
                  let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                  ac.addAction(UIAlertAction(title: "Ok", style: .default))
                  present(ac, animated: true)
              }
          }
      }
      
  }
}
