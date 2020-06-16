//
//  DashboardViewController.swift
//  Budget Blocks
//
//  Created by Nick Nguyen on 6/16/20.
//  Copyright © 2020 Isaac Lyons. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func removeBorder(){
        
        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.green], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor.clear
        }
        
    }
    
    func setupSegment() {
        self.removeBorder()
        let segmentUnderlineWidth: CGFloat = self.bounds.width
        let segmentUnderlineHeight: CGFloat = 2.0
        let segmentUnderlineXPosition = self.bounds.minX
        let segmentUnderLineYPosition = self.bounds.size.height - 1.0
        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.backgroundColor = UIColor.clear
        
        self.addSubview(segmentUnderline)
        self.addUnderlineForSelectedSegment()
    }
    
    func addUnderlineForSelectedSegment(){
        
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.darkGray
        underline.tag = 1
        self.addSubview(underline)
        
        
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
        
    }
}

class DashboardViewController: UIViewController {

    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var balanceLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Your balance is"
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    private lazy var amountLabel: UILabel = {
        let lb = UILabel()
        lb.text = "$5,327.86"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        lb.textColor = .white
        return lb
     
    }()
    
    private lazy var hiUserLabel: UILabel = {
       let lb = UILabel()
        lb.text = "Hi \(UserController.shared.user.name)!"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        view.backgroundColor = .white
        return view
    }()
    
    
    private let greenView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.3165915608, green: 0.7718194127, blue: 0.7388673425, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return view
    }()
    
    lazy var mySegmentedControl: UISegmentedControl = {
       let sm = UISegmentedControl(items: ["Spending","Budget"])
        sm.translatesAutoresizingMaskIntoConstraints = false
        sm.selectedSegmentIndex = 0
        sm.selectedSegmentTintColor = .red
        sm.backgroundColor = .clear
        sm.tintColor = .red
        sm.apportionsSegmentWidthsByContent = true
        sm.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        sm.addTarget(self, action: #selector(switchToSpending), for: .valueChanged)
        sm.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return sm
    }()
    
    
    @objc func switchToSpending() {
//        mySegmentedControl.changeUnderlinePosition()
        switch mySegmentedControl.selectedSegmentIndex {
            case 0:
                let indexPath = IndexPath(item: 0, section: 0)
                nickCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            case 1:
                let indexPath = IndexPath(item: 1, section: 0)
                nickCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            default:
            break
        }
       
    }
    
    
    lazy var nickCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.isScrollEnabled = false
        cv.isPagingEnabled = true
        
        return cv
        
    }()
    
    
    
    
 //MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickCollectionView.register(PageHorizontalCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        hideKeyboardWhenTappedAround()
        navigationItem.hidesBackButton = true
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
       
        
        containerView.addSubview(greenView)
        
        greenView.addSubview(mySegmentedControl)
        greenView.addSubview(amountLabel)
        greenView.addSubview(balanceLabel)
        greenView.addSubview(hiUserLabel)
        
        containerView.addSubview(nickCollectionView)
        
        NSLayoutConstraint.activate([
            greenView.topAnchor.constraint(equalTo: containerView.topAnchor),
            greenView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            greenView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            nickCollectionView.topAnchor.constraint(equalTo: greenView.bottomAnchor),
            nickCollectionView.leadingAnchor.constraint(equalTo: greenView.leadingAnchor),
            nickCollectionView.trailingAnchor.constraint(equalTo: greenView.trailingAnchor),
            nickCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            mySegmentedControl.bottomAnchor.constraint(equalTo: greenView.bottomAnchor),
            mySegmentedControl.leadingAnchor.constraint(equalTo: greenView.leadingAnchor,constant: 100),
            mySegmentedControl.trailingAnchor.constraint(equalTo: greenView.trailingAnchor,constant: -100),
            
            amountLabel.centerXAnchor.constraint(equalTo: greenView.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: greenView.centerYAnchor),
            
            balanceLabel.bottomAnchor.constraint(equalTo: amountLabel.topAnchor,constant: -8),
            balanceLabel.centerXAnchor.constraint(equalTo: greenView.centerXAnchor),
            
            hiUserLabel.centerXAnchor.constraint(equalTo: greenView.centerXAnchor),
            hiUserLabel.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor,constant: -16)
            
        ])
        
 
        scrollViewContainer.addArrangedSubview(containerView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}
extension DashboardViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PageHorizontalCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height )
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        nickCollectionView.collectionViewLayout.invalidateLayout()
    }
}