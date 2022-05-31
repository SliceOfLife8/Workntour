//
//  CountriesDropDownCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 30/5/22.
//

import UIKit
import DropDown

class CountriesDropDownCell: DropDownCell {

    // MARK: - Outlets
    @IBOutlet weak var countryEmoji: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryPrefix: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        accessoryType = selected ? .checkmark : .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        countryPrefix.text?.removeAll()
    }

    func configure(flag: String?, name: String?, prefix: String?) {
        countryEmoji.text = flag
        countryName.text = name
        if let phoneExtension = prefix {
            countryPrefix.text = "+\(phoneExtension)"
        }
    }

}
