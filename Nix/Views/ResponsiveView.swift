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




//func getPreviewLayoutProperties(height: CGFloat, width: CGFloat) -> LayoutProperties{
//    return LayoutProperties(
//        dimensValues: CustomDimensValues(height: height, width: width),
//        customFontSize: CustomFontSize(height: height, width: width),
//        height: height,
//        width: width
//    )
//}
