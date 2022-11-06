//
//  HomeViewCellTableViewCell.swift
//  Prueba-Ingreso
//
//  Created by LUIS SUAREZ on 13/04/21.
//

import UIKit

class HomeViewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var btnVer: UIButton!
    var buttonTapCallback: () -> ()  = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnVer.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didTapButton() {
            buttonTapCallback()
        }

}
