//
//  CardDetailTableViewCell.swift
//  CardScanDemo
//
//  Created by Manali on 22/09/21.
//

import UIKit
protocol  CardDetailTableViewCellDelegate :class{
    func CardDetailTableViewCell(cell: CardDetailTableViewCell , didTappedThe button: UIButton?)

}
class CardDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btndelet(_ sender: Any) {
        celldelegate?.CardDetailTableViewCell(cell: self, didTappedThe: sender as?UIButton)
    }
    weak var  celldelegate :CardDetailTableViewCellDelegate?
    @IBOutlet weak var lbldelet: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lblcardnumber: UILabel!
    @IBOutlet weak var lblcardname: UILabel!
    @IBOutlet weak var lblcardexp: UILabel!
}
