//
//  DialpadView.swift
//  phone
//
//  Created by rutinfc on 2020/02/20.
//  Copyright © 2020 rutinfc. All rights reserved.
//

import UIKit


@objc public protocol DialpadViewDelegate : NSObjectProtocol {
    
    @objc optional func didUpdate(number:String)
}

public enum DialpadKeyType {
    case normal, chonjiin, nara
}

public class DialpadView: UIView {
    
    private static let korInfo = ["1":"ㄱㅋ", "2":"ㄴ", "3":"ㄷㅌ", "4":"ㄹ", "5":"ㅁ", "6":"ㅂㅍ", "7":"ㅅ", "8":"ㅇ", "9":"ㅈㅊ", "0":"ㅎ", "✲":" ", "#":" "]
    private static let engInfo = ["1":".QZ", "2":"ABC", "3":"DEF", "4":"GHI", "5":"JKL", "6":"MNO", "7":"PRS", "8":"TUV", "9":"WXY", "0":"﹢", "✲":"‚", "#":";"]

    private let cellIdentifier = "DialpadNumberCell"
    private var collectionView : UICollectionView
    
    private var keyList : [String]?
    private var koreaList : [String]?
    private var engList : [String]?
    
    var currentNumber : String = ""
    weak var delegate : DialpadViewDelegate?
    
    var keyType : DialpadKeyType = .normal {
        didSet {
            self.loadInitialityInfo()
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
        self.loadDefaultKeyInfo()
        self.loadInitialityInfo()
        self.loadCollectionView()
    }
    
    required init?(coder: NSCoder) {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(coder: coder)
        self.loadDefaultKeyInfo()
        self.loadInitialityInfo()
        self.loadCollectionView()
    }
    
    private func loadCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        let nib = UINib(nibName: "DialpadNumberCell", bundle: Bundle(for: DialpadView.self))
        self.collectionView.register(nib, forCellWithReuseIdentifier: self.cellIdentifier)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func loadDefaultKeyInfo() {
        
        self.keyList = (0..<12).map { (index) -> String in
            
            if index < 9 {
                return String(index + 1)
            }  else if index == 9 {
                return "✲"
            } else if index == 11 {
                return "#"
            } else  {
                return "0"
            }
        }
    }
    
    private func loadInitialityInfo() {
        
        self.koreaList = self.keyList?.map({ (key) -> String in
            return DialpadView.korInfo[key] ?? ""
        })
        
        self.engList = self.keyList?.map({ (key) -> String in
            return DialpadView.engInfo[key] ?? ""
        })
    }
}

extension DialpadView : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.bounds.width / 3
        let height = self.bounds.height / 4
        
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DialpadView : UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        
        if let dialCell = cell as? DialpadNumberCell, let number = self.keyList?[indexPath.item] {
            dialCell.setNumber(key: number)
            dialCell.koreaText.text = self.koreaList?[indexPath.item]
            dialCell.engText.text = self.engList?[indexPath.item]
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.didUpdate?(number: self.currentNumber)
    }
}
