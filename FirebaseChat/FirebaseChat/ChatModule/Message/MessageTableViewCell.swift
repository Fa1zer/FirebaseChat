//
//  MessageTableViewCell.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        
        
    }
    
}
