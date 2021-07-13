////
////  CustomCalloutView.swift
////  Business Search Solution
////
////  Created by Sarmad Ishfaq on 15/06/2021.
////  Copyright © 2021 Softgear. All rights reserved.
////
//
//import Foundation
//
//class CustomAnnotation: NSObject, MGLAnnotation {
//
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//    var image: UIImage
//
//    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: UIImage) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//        self.image = image
//    }
//}
//
//// MGLAnnotationView subclass
//class CustomAnnotationView: MGLAnnotationView {
//
//    
//    let imageView : UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "annotation")
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//    
//    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        
//        addSubview(imageView)
//        NSLayoutConstraint.activate([
//        
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
//
//protocol CustomCalloutViewDelegate : class {
//    func navigateButtonPressed(coordinates : CLLocationCoordinate2D)
//}
//
//class CustomCalloutView: UIView, MGLCalloutView {
//
//    var representedObject: MGLAnnotation
//    // Required views but unused for now, they can just relax
//    lazy var leftAccessoryView = UIView()
//    lazy var rightAccessoryView = UIView()
//
//    weak var delegate: MGLCalloutViewDelegate?
//    weak var navigateDelegate : CustomCalloutViewDelegate? = nil
//    
//    //MARK: Subviews -
//    let titleLabel:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 17.0)
//        return label
//    }()
//
//    let subtitleLabel:UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let imageView:UIImageView = {
//        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        imageview.translatesAutoresizingMaskIntoConstraints = false
//        imageview.contentMode = .scaleAspectFit
//        return imageview
//    }()
//
//    lazy var NavigateButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("Navigate", for: .normal)
//        button.setTitleColor(.appBlack, for: .normal)
//        button.backgroundColor = .appRed
//        button.addTarget(self, action: #selector(navigateButtonPressed), for: .touchUpInside)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    required init(annotation: CustomAnnotation) {
//        self.representedObject = annotation
//        // init with 100% of width and 200px tall
//        super.init(frame: CGRect(origin: CGPoint(), size: CGSize(width: UIScreen.main.bounds.width, height: 250)))
//
//        self.titleLabel.text = self.representedObject.title ?? ""
//        self.subtitleLabel.text = self.representedObject.subtitle ?? ""
//        self.imageView.image = annotation.image
//        setup()
//    }
//
//    required init?(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setup() {
//        // setup this view's properties
//        self.backgroundColor = UIColor.appBlack
//        // And their Subviews
//        self.addSubview(titleLabel)
//        self.addSubview(subtitleLabel)
//        self.addSubview(imageView)
//        addSubview(NavigateButton)
//        // Add Constraints to subviews
//        let spacing:CGFloat = 8.0
//        
//        
//
//        
//        NSLayoutConstraint.activate([
//        
//            
//            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
//            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing),
//            imageView.heightAnchor.constraint(equalToConstant: 70),
//            imageView.widthAnchor.constraint(equalToConstant: 70),
//
//            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
//            titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: spacing * 2),
//            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing),
//
//            subtitleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
//            subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing),
//            subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing),
//        
//            NavigateButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            NavigateButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            NavigateButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            NavigateButton.heightAnchor.constraint(equalToConstant: 50),
//        ])
//    }
//
//    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
//        //Center bottom
//        self.center = view.center.applying(CGAffineTransform(translationX: 0, y: view.bounds.height/2 - self.bounds.height/2))
//        view.addSubview(self)
//    }
//
//    func dismissCallout(animated: Bool) {
//        if (animated){
//            //Implement animation here
//            removeFromSuperview()
//        } else {
//            removeFromSuperview()
//        }
//    }
//    @objc func navigateButtonPressed(){
//        if let delegate = navigateDelegate {
//            delegate.navigateButtonPressed(coordinates: representedObject.coordinate)
//        }
//    }
//}
