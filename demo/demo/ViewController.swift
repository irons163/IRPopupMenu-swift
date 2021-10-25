//
//  ViewController.swift
//  demo
//
//  Created by Phil on 2021/2/22.
//

import UIKit
import IRPopupMenu_swift

class ViewController: UIViewController, IRPopupMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showNormalArrowOfPopupMenu(_ sender: UIButton) {
        var position = sender.center
        position.x = sender.frame.minX
        position.y += sender.frame.height

        let imageSize = CGSize(width: 30, height: 30)
        let settingImage = image(WithImage: UIImage(named: "play")!, scaledToSize: imageSize)
        let infoImage = image(WithImage: UIImage(named: "pause")!, scaledToSize: imageSize)
        IRPopupMenu.init(showAtPoint: position, titles: ["Item1", "Item2"], icons: [settingImage!, infoImage!], menuWidth: 250) { popupMenu in
            popupMenu.priorityDirection = .IRPopupMenuPriorityDirectionTop
            popupMenu.arrowDirection = .IRPopupMenuArrowDirectionTop
            popupMenu.backColor = .red
            popupMenu.textColor = .blue
            popupMenu.dismissOnSelected = false
            popupMenu.isShowShadow = true
            popupMenu.delegate = self
            popupMenu.offset = 0
    //        popupMenu.minSpace = 0
            popupMenu.rectCorner = [.topLeft, .topRight]
            popupMenu.cornerRadius = 6
        }
    }
    
    @IBAction func showCustomArrowImageOfPopupMenu(_ sender: UIButton) {
        var position = sender.center
        position.x = sender.frame.minX
        position.y += sender.frame.height

        let imageSize = CGSize(width: 30, height: 30)
        let settingImage = image(WithImage: UIImage(named: "play")!, scaledToSize: imageSize)
        let infoImage = image(WithImage: UIImage(named: "pause")!, scaledToSize: imageSize)
        IRPopupMenu.init(showAtPoint: position, titles: ["Item1", "Item2"], icons: [settingImage!, infoImage!], menuWidth: 250) { popupMenu in
            let closeButton = UIButton(type: .custom)
            closeButton.setImage(UIImage(named: "close"), for: .normal)
            closeButton.imageView?.contentMode = .scaleAspectFit
            popupMenu.addSubview(closeButton)
            
            NSLayoutConstraint(item: closeButton, attribute: .left, relatedBy: .equal, toItem: popupMenu, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: closeButton, attribute: .bottom, relatedBy: .equal, toItem: popupMenu, attribute: .top, multiplier: 1, constant: -14).isActive = true
            NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            
            popupMenu.priorityDirection = .IRPopupMenuPriorityDirectionNone
            popupMenu.arrowDirection = .IRPopupMenuArrowDirectionNone
            popupMenu.backColor = .red
            popupMenu.textColor = .blue
            popupMenu.dismissOnSelected = false
            popupMenu.isShowShadow = true
            popupMenu.delegate = self
            popupMenu.arrowHeight = 0
            popupMenu.offset = 20
            popupMenu.minSpace = 0
            popupMenu.rectCorner = [.allCorners]
            popupMenu.cornerRadius = 10
        }
    }
    
    private func image(WithImage image: UIImage, scaledToSize newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: - IRPopupMenuDelegate
    func ybPopupMenu(ybPopupMenu: IRPopupMenu, didSelectedAtIndex index: NSInteger) {
        ybPopupMenu.dismiss()
        let alertController = UIAlertController(title: "\(index + 1)", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
            alertController.dismiss(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    func ybPopupMenu(ybPopupMenu: IRPopupMenu, cellForRowAtIndex index: NSInteger) -> UITableViewCell? {
        var cell = ybPopupMenu.tableView?.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier()) as? MenuTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(MenuTableViewCell.identifier(), owner: self, options: nil)?.first as? MenuTableViewCell
        }
        
        cell?.titleLabel.text = ybPopupMenu.titles?[index] as? String
        cell?.backgroundColor = .green
        cell?.titleLabel.textColor = .blue
        
        guard let images = ybPopupMenu.images else { return cell }
        
        if images.count >= index + 1 {
            if ((images[index] as? String) != nil) {
                cell?.iconImageView.image = UIImage(named: images[index] as! String)
            } else if ((images[index] as? UIImage) != nil) {
                cell?.iconImageView.image = images[index] as? UIImage
            } else {
                cell?.iconImageView.image = nil
            }
        } else {
            cell?.iconImageView.image = nil
        }
        
        return cell
    }
}

