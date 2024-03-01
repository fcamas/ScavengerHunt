//
//  TaskCell.swift
//  ScavengerHunt
//
//  Created by Fredy Camas on 2/28/24.
//

import UIKit

class PlaceCell: UITableViewCell {
   
    let completedImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints  = false
            return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(completedImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            completedImageView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            completedImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            completedImageView.widthAnchor.constraint(equalToConstant: 24),
            completedImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func configure(with task: Place){
        titleLabel.text = task.title
        titleLabel.textColor = task.isComplete ? .secondaryLabel : .label
        completedImageView.image = UIImage(systemName: task.isComplete ? "circle.inset.filled" : "circle")?.withRenderingMode(.alwaysTemplate)
         //completedImageView.tintColor = task.isComplete ? .systemBlue: .tertiaryLabel
        completedImageView.tintColor = task.isComplete ? .systemBlue: .systemPurple
        
    }
}
