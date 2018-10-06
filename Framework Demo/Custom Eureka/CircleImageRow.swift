//
//  CircleImageRow.swift
//  Framework Demo
//
//  Created by James Coleman on 06/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import Eureka

public class CircleCell: Cell<UIImage>, CellType {
    
    public var circleImage: UIImageView
    public var label: UILabel
    
    init() {
        self.circleImage = UIImageView()
        self.label = UILabel()
        
        super.init(style: .default, reuseIdentifier: nil)
        
        addSubview(circleImage)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.circleImage = UIImageView()
        self.label = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(circleImage)
        addSubview(label)
    }
    
    public override func setup() {
        super.setup()
        
        let circleMargin: CGFloat = 10
        let cellHeight: CGFloat = 200
        
        height = { return cellHeight }
        selectionStyle = .none
        
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        circleImage.backgroundColor = .lightGray
        circleImage.layer.cornerRadius = (cellHeight - (2 * circleMargin)) / 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        
        NSLayoutConstraint.activate([
            circleImage.widthAnchor.constraint(equalTo: circleImage.heightAnchor),
            
            circleImage.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: circleMargin),
            circleImage.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: circleMargin),
            circleImage.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: circleMargin),
            circleImage.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: circleMargin),
            
            circleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class CircleRow: Row<CircleCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
    
    public var image: UIImage? {
        didSet {
            cell.circleImage.image = image
            cell.setup()
        }
    }
    
    public var labelText: String? {
        didSet {
            cell.label.text = labelText
            cell.setup()
        }
    }
}
