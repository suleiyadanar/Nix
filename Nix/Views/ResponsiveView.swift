//
//  ResponsiveView.swift
//  SupportDifferentScreensSwiftUI
//
//  Created by Su Lei Yadanar on 25.09.22.
//

import SwiftUI

struct ResponsiveView<Content:View>: View {
    var content:(Properties)-> Content
    init(@ViewBuilder content: @escaping (Properties)->Content){
        self.content = content
    }
    var body: some View {
        GeometryReader{geo in
            let height = geo.size.height
            let width = geo.size.width
            let onboarding = Onboarding(height:height, width: width)
            let dimensValues = CustomDimensValues(height:height, width:width)
            let customFontSize = CustomFontSize(height:height, width:width)
            let padding = Padding(height: height, width: width)
            let round = Roundness (height: height, width: width)
            let size = geo.size
            let isLandscape = size.width > size.height
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let isMaxSplit = isSplit() && size.width < 400
            let isAdoptable = isIpad && (isLandscape ? !isMaxSplit : !isSplit())
            
            let properties = Properties(
                dimensValues: dimensValues,
                customFontSize: customFontSize,
                round: round,
                padding: padding,
                height: height,
                width: width,
                isLandscape: isLandscape,
                isIPad: isIpad,
                isSplit: isSplit(),
                isMaxSplit: isMaxSplit,
                isAdoptable: isAdoptable,
                size: size,
                onBoarding: onboarding
            )
            
            content(properties)
                .frame(width: size.width, height: size.height)
        }
        
    }
    func isSplit() -> Bool {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return false}
        return screen.windows.first?.frame.size != screen.screen.bounds.size
    }
}

struct Padding {
    let widthRatio:CGFloat
    let heightRatio:CGFloat
    
    init(height:CGFloat, width:CGFloat){
        let widthToCalculate = height<width ? height : width
        switch widthToCalculate {
        case _ where widthToCalculate<700:
            widthRatio = width * 0.9
            heightRatio = height * 0.9
        case _ where widthToCalculate>=700 && widthToCalculate<1000:
            widthRatio = width * 0.7
            heightRatio = height * 0.7
        case _ where widthToCalculate>=1000:
            widthRatio = width * 0.7
            heightRatio = height * 0.7
        default:
            widthRatio = width * 0.5
            heightRatio = height * 0.2
        }
        
    }
}


struct Roundness {
    let sheet:CGFloat
    let item:CGFloat
    
    init(height:CGFloat, width:CGFloat){
        let widthToCalculate = height<width ? height : width
        switch widthToCalculate {
        case _ where widthToCalculate<700:
            sheet = 15
            item = 15
        case _ where widthToCalculate>=700 && widthToCalculate<1000:
            sheet = 40
            item = 20
        case _ where widthToCalculate>=1000:
            sheet = 50
            item = 25
        default:
            sheet = 15
            item = 15
        }
        
    }
    
}

struct CustomFontSize {
    let small:CGFloat
    let smallMedium:CGFloat
    let medium:CGFloat
    let mediumLarge:CGFloat
    let large:CGFloat
    let extraLarge:CGFloat
    init(height:CGFloat, width:CGFloat){
        let widthToCalculate = height<width ? height : width
        switch widthToCalculate {
        case _ where widthToCalculate<700:
            small = 12
            smallMedium = 16
            medium = 20
            mediumLarge = 25
            large = 35
            extraLarge = 45
        case _ where widthToCalculate>=700 && widthToCalculate<1000:
            small = 15
            smallMedium = 18
            medium = 22
            mediumLarge = 26
            large = 50
            extraLarge = 60
        case _ where widthToCalculate>=1000:
            small = 20
            smallMedium = 24
            medium = 28
            mediumLarge = 32
            large = 55
            extraLarge = 65
        default:
            small = 8
            smallMedium = 11
            medium = 14
            mediumLarge = 16
            large = 35
            extraLarge = 45
        }
    }
}

struct Onboarding {
    let cornerRadius: CGFloat
    let textBoxWidth: CGFloat
    let textBoxHeight: CGFloat
    init(height:CGFloat, width:CGFloat){
        let widthToCalculate = height<width ? height : width
        switch widthToCalculate{
        case _ where widthToCalculate < 375: // Smaller iPhone sizes
            cornerRadius = 5
            textBoxWidth = 330
            textBoxHeight = 40
        case _ where widthToCalculate >= 375 && widthToCalculate < 414: // Standard iPhone sizes
            cornerRadius = 6
            textBoxWidth = 340
            textBoxHeight = 50
        case _ where widthToCalculate >= 414 && widthToCalculate < 768: // Larger iPhones and small iPads
            cornerRadius = 9
            textBoxWidth = 340
            textBoxHeight = 60
        case _ where widthToCalculate >= 768 && widthToCalculate < 1024: // iPad and small iPad Pro
            cornerRadius = 11
            textBoxWidth = 380
            textBoxHeight = 80
        case _ where widthToCalculate >= 1024: // Larger iPads and iPad Pro
            cornerRadius = 13
            textBoxWidth = 400
            textBoxHeight = 85
        default:
            cornerRadius = 5
            textBoxWidth = 350
            textBoxHeight = 50
        }
    }
    
}
struct CustomDimensValues {
    let small:CGFloat
    let smallMedium:CGFloat
    let medium:CGFloat
    let mediumLarge:CGFloat
    let large:CGFloat
    let extraLarge:CGFloat
    init(height:CGFloat, width:CGFloat){
        let widthToCalculate = height<width ? height : width
        switch widthToCalculate{
        case _ where widthToCalculate < 375: // Smaller iPhone sizes
            small = 10
            smallMedium = 12
            medium = 14
            mediumLarge = 16
            large = 18
            extraLarge = 20
        case _ where widthToCalculate >= 375 && widthToCalculate < 414: // Standard iPhone sizes
            small = 12
            smallMedium = 14
            medium = 16
            mediumLarge = 18
            large = 20
            extraLarge = 24
        case _ where widthToCalculate >= 414 && widthToCalculate < 768: // Larger iPhones and small iPads
            small = 14
            smallMedium = 16
            medium = 18
            mediumLarge = 20
            large = 22
            extraLarge = 26
        case _ where widthToCalculate >= 768 && widthToCalculate < 1024: // iPad and small iPad Pro
            small = 16
            smallMedium = 18
            medium = 20
            mediumLarge = 22
            large = 24
            extraLarge = 28
        case _ where widthToCalculate >= 1024: // Larger iPads and iPad Pro
            small = 18
            smallMedium = 20
            medium = 22
            mediumLarge = 24
            large = 28
            extraLarge = 32
        default:
            small = 10
            smallMedium = 12
            medium = 14
            mediumLarge = 16
            large = 18
            extraLarge = 20
        }
    }
}

struct Properties {
    var dimensValues: CustomDimensValues
    var customFontSize: CustomFontSize
    var round: Roundness
    var padding: Padding
    var height: CGFloat
    var width: CGFloat
    var isLandscape: Bool
    var isIPad: Bool
    var isSplit: Bool
    var isMaxSplit: Bool
    var isAdoptable: Bool
    var size: CGSize
    var onBoarding: Onboarding
}

//func getPreviewLayoutProperties(height: CGFloat, width: CGFloat) -> LayoutProperties{
//    return LayoutProperties(
//        dimensValues: CustomDimensValues(height: height, width: width),
//        customFontSize: CustomFontSize(height: height, width: width),
//        height: height,
//        width: width
//    )
//}
