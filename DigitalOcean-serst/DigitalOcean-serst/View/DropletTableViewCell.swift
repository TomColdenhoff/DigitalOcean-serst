//
//  DropletTableViewCell.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 17/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import UIKit

class DropletTableViewCell: UITableViewCell {

    var dropletViewModel: Droplet? {
        didSet {
            
            guard let droplet = dropletViewModel else { return }
            
            serverNameLabel.text = droplet.name
            serverRegionSlugLabel.text = droplet.region.slug
            serverIpAddressLabel.text = droplet.networks.v4.first?.ip_address
            serverStatusImage.tintColor = droplet.status == "active" ? #colorLiteral(red: 0, green: 1, blue: 0.08235294118, alpha: 1) : #colorLiteral(red: 1, green: 0.2509803922, blue: 0, alpha: 1)
        }
    }
    
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var serverRegionSlugLabel: UILabel!
    @IBOutlet weak var serverIpAddressLabel: UILabel!
    @IBOutlet weak var serverStatusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            
        clipsToBounds = true
        contentView.layer.cornerRadius = 10.0
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
}
