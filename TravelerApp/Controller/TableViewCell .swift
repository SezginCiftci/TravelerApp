//
//  TableViewCell .swift
//  TravelerApp
//
//  Created by Sezgin Çiftci on 6.01.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var cellTitle = UILabel()
    var cellComment = UILabel()
    
    func configureUI() {

        //cellTitle
        addSubview(cellTitle)
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        cellTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        cellTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        cellTitle.contentMode = .scaleToFill
        cellTitle.textColor = .systemRed
        cellTitle.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        //cellComment
        addSubview(cellComment)
        cellComment.translatesAutoresizingMaskIntoConstraints = false
        cellComment.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: 10).isActive = true
        cellComment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        cellComment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        cellComment.contentMode = .scaleToFill
        cellComment.textColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        cellComment.font = UIFont.italicSystemFont(ofSize: 12)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
