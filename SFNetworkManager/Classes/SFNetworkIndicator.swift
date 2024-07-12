//
//  SFNetworkIndicator.swift
//  SFNetworkManager
//
//  Created by sfh on 2024/7/4.
//

import UIKit
import NVActivityIndicatorView

/// hudStyle
public enum SFNetworkIndicatorStyle: CaseIterable {
    case light
    case dark
    case custom
}

public class SFNetworkIndicator: UIView {
    
    /// hud在y轴上的偏移量，默认屏幕居中，大于0偏上，小于0偏下
    var offset: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    
    /// hud最大宽度
    public var maxWith: CGFloat = UIScreen.main.bounds.width - 20 {
        didSet {
            setup()
        }
    }
    
    /// 内边距
    public var padding: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    /// 指示器与文字间距
    public var margin: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    /// 指示器宽高
    public var indicatorWH: CGFloat = 60.0 {
        didSet {
            setup()
        }
    }
    
    /// 提示信息字体
    public var textFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .medium) {
        didSet {
            setup()
        }
    }
    
    /// hud背景色, style = .custom时生效
    public var hudBackgroundColor: UIColor = #colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1) {
        didSet {
            setup()
        }
    }
    
    /// 指示器颜色, style = .custom时生效
    public var indicatorColor: UIColor = #colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1) {
        didSet {
            setup()
        }
    }
    
    /// 文字颜色, style = .custom时生效
    public var textColor: UIColor = #colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1) {
        didSet {
            setup()
        }
    }
    
    /// hud圆角
    public var radius: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    /// 遮罩颜色
    public var maskColor: UIColor = UIColor(white: 0, alpha: 0.4) {
        didSet {
            self.backgroundColor = maskColor
        }
    }
    
    fileprivate var message:String?
    fileprivate var type: NVActivityIndicatorType?
    fileprivate var style: SFNetworkIndicatorStyle
    
    public init(frame: CGRect, message: String?, type: NVActivityIndicatorType?, style: SFNetworkIndicatorStyle?) {
        self.message = message
        self.type = type
        self.style = style ?? .light
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.addSubview(hudView)
        if self.type != nil {
            hudView.contentView.addSubview(indicator)
        }
        if self.message != nil {
            hudView.contentView.addSubview(infoLabel)
        }
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as AnyObject
        var point = touch.location(in: self)
        point = self.hudView.layer.convert(point, from: self.layer)
        if self.hudView.layer.contains(point) {

        } else {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0.0
            } completion: { finish in
                self.removeFromSuperview()
            }
        }
    }
    
    func setup() {
        var hudW: CGFloat = 0
        var hudH: CGFloat = 0
        var topH: CGFloat = 0
        var labW: CGFloat = 0
        var labH: CGFloat = 0
        if self.message != nil {
            let size = (self.message! as NSString).boundingRect(
                with: CGSize(width: self.maxWith, height: CGFLOAT_MAX),
                options: [.usesFontLeading, .usesLineFragmentOrigin],
                attributes: [.font: self.textFont, .foregroundColor: self.textColor],
                context: nil).size
            labW = size.width > self.indicatorWH ? size.width : self.indicatorWH
            labH = size.height
            hudW = labW + 2 * self.padding
            topH = self.type != nil ? self.margin + self.indicatorWH : 0.0
            hudH = size.height + 2 * self.padding + topH
        } else {
            hudW = 2 * self.padding + self.indicatorWH
            topH = 0.0
            hudH = hudW
        }

        hudView.frame = CGRect(x: 0, y: 0, width: hudW, height: hudH)
        hudView.center.x = self.center.x
        hudView.center.y = self.center.y - self.offset
        hudView.layer.cornerRadius = self.radius
        hudView.layer.masksToBounds = self.radius > 0.0
        if self.type != nil {
            indicator.frame = CGRect(x: (hudW - self.indicatorWH) / 2, y: self.padding, width: self.indicatorWH, height: self.indicatorWH)
        }
        infoLabel.frame = CGRect(x: self.padding, y: self.padding + topH, width: labW, height: labH)
        infoLabel.text = self.message
        infoLabel.font = self.textFont
        
        switch self.style {
        case .light:
            self.hudView.effect = UIBlurEffect(style: .light)
            self.hudView.backgroundColor = .clear
            self.indicator.color = #colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1)
            self.infoLabel.textColor = #colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1)
            break
        case .dark:
            self.hudView.effect = UIBlurEffect(style: .dark)
            self.hudView.backgroundColor = .clear
            self.indicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.infoLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            break
        case .custom:
            self.hudView.effect = nil
            self.hudView.backgroundColor = self.hudBackgroundColor
            self.indicator.color = self.indicatorColor
            self.infoLabel.textColor = self.textColor
            break
        }
        
        if self.type != nil {
            self.indicator.stopAnimating()
            self.indicator.type = self.type!
            self.indicator.startAnimating()
        }
        
    }
    
    // MARK: lazyload
    
    lazy var hudView: UIVisualEffectView = {
        let view = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: 80, height: 100))
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 60, height: 60), type: .circleStrokeSpin, color: .black, padding: 0)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 80, width: 60, height: 20))
        label.text = "加载中..."
        label.textColor = .black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

}
