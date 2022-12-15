//
//  RoundedClickAnimatedButton.swift
//  EasyUIRawLib
//
//  Created by Boris Elkin on 15.12.2022.
//
/*
import UIKit
class RoundedClickAnimatedButton:ClickAnimatedButton {
    
    //Основной цвет кнопки
    @IBInspectable var color:UIColor?
    
    //Второй цвет для градиента
    @IBInspectable var colorSecond:UIColor?
    
    //Заливка или только обводка
    @IBInspectable var isBordered:Bool = false
    
    //Цвет текста
    @IBInspectable var textColor:UIColor?
    
    //Радиус
    @IBInspectable var radius:Int = -1
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let _color = color ?? UIColor.buttonGradientTop()
        if isBordered {
            layer.borderWidth = 1
            layer.borderColor = _color.cgColor
            backgroundColor = .clear
        } else {
            layer.borderWidth = 0
            
            if let _colorSecond = colorSecond {
                DispatchQueue.main.async {
                    self.addGradientLayer(color1: _color, color2: _colorSecond, color3: nil).cornerRadius = self.frame.height * 0.5
                    if self.radius > 0 {
                        self.addGradientLayer(color1: _color, color2: _colorSecond, color3: nil).cornerRadius = CGFloat(self.radius)
                    }
                }
            } else {
                if color != nil {
                    self.backgroundColor = color!
                } else {
                    DispatchQueue.main.async {
                        self.backgroundColor = UIColor.init(hexString: "#9225D8")
                        //Прощай, градиент
                        /*self.addGradientLayer(color1: UIColor.buttonGradientTop(), color2: UIColor.buttonGradientBottom(), color3: nil).cornerRadius = self.frame.height * 0.5
                        if self.radius > 0 {
                            self.addGradientLayer(color1: UIColor.buttonGradientTop(), color2: UIColor.buttonGradientBottom(), color3: nil).cornerRadius = CGFloat(self.radius)
                        }*/
                    }
                }
            }
        }
        
        let _textColor = textColor ?? UIColor.white
        setTitleColor(_textColor, for: .normal)
        
        titleLabel?.textAlignment = .center
        contentHorizontalAlignment = .center
        //showsTouchWhenHighlighted = true
        
        contentEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height * 0.5
            if self.radius > 0 {
                self.layer.cornerRadius = CGFloat(self.radius)
            }
            self.setTitleColor(_textColor, for: .normal)
            self.layoutIfNeeded()
        }
    }
    
    func changeGradientColors(firstColor: UIColor, secondColor: UIColor) {
        DispatchQueue.main.async {
            self.addGradientLayer(color1: firstColor, color2: secondColor, color3: nil).cornerRadius = CGFloat(self.radius > 0 ? CGFloat(self.radius) : self.frame.height * 0.5)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        awakeFromNib()
    }
    
    override var isEnabled:Bool {
        didSet {
            isUserInteractionEnabled = isEnabled
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
*/
