//
//  Localization.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

//
//  LanguageHelper.swift
//  OryxCowFarmSole
//
//  Created by AlaaHallaq on 16/02/2021.
//

import Foundation

public var isAR: Bool {
    LanguageHelper.isRTL
}

import UIKit

// constants
fileprivate let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
public class LanguageHelper {
    /// get current Apple language
    public class func Language() -> String? {
        if let current = languageFullName() {
            let start = current.startIndex
            let abbr = current[start ..< current.index(start, offsetBy: 2)]
            return String(abbr).lowercased()
        }
        return nil
    }

    public class func languageFullName() -> String? {
        let userdef = UserDefaults.standard
        if let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as? NSArray {
            if let current = langArray.firstObject as? String {
                return current
            }
        }
        return nil
    }

    /// set @lang to be the first in Applelanguages list
    public class func setLanguage(to lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang, Language()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }

    public class var isRTL: Bool {
        return Language() == "ar"
    }

    public class func refreshUI() {
        let semantic: UISemanticContentAttribute = isAR ? .forceRightToLeft : .forceLeftToRight

        UIView
            .appearance().semanticContentAttribute = semantic

        UICollectionView
            .appearance().semanticContentAttribute = semantic

        UITableView
            .appearance().semanticContentAttribute = semantic

        UIScrollView
            .appearance().semanticContentAttribute = semantic

        UIStackView
            .appearance().semanticContentAttribute = semantic

        UINavigationBar
            .appearance().semanticContentAttribute = semantic
    }

    public class func setupSwizzlling() {
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
        MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews2))
        MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))

        refreshUI()
    }
}

public extension UILabel {
    @objc func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
        if self.tag <= 0 {
            if isAR {
                if self.textAlignment == .right || self.textAlignment == .center {
                    return
                }
            } else {
                if self.textAlignment == .left || self.textAlignment == .center {
                    return
                }
            }
        }
        if self.tag <= 0 {
            if isAR {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }
}

public extension UITextField {
    @objc func cstmlayoutSubviews2() {
        self.cstmlayoutSubviews2()
        if self.tag <= 0 {
            if isAR {
                if self.textAlignment == .right || self.textAlignment == .center { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left || self.textAlignment == .center { return }
                self.textAlignment = .left
            }
        }
    }
}

public extension UIApplication {
    @objc var cstm_userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if LanguageHelper.isRTL {
                direction = .rightToLeft
            }
            return direction
        }
    }
}

public extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        var bundle: Bundle = self
        let names = [LanguageHelper.languageFullName(), LanguageHelper.Language(), "Base"]
        for name in names {
            if
                let _path = self.path(
                    forResource: name,
                    ofType: "lproj"
                )
            {
                if let _bundle = Bundle(path: _path) {
                    bundle = _bundle
                    break
                }
            }
        }
        return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
    }
}

/// Exchange the implementation of two methods of the same Class
public func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}
