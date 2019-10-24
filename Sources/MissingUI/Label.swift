//
//  File.swift
//  
//
//  Created by Tiziano Coroneo on 24/10/2019.
//

import SwiftUI

/// The `Label` default font name, that is used if you don't specify a different `fontName` in the `Label.init`.
public var defaultLabelFontName: String = "Courier"

/// The `Label` default font size, that is used if you don't specify a different `fontSize` in the `Label.init`.
public var defaultLabelFontSize: CGFloat = 18

/**
A `Text` that has a default font already set, so that you don't have to remember to set the `font` modifier.
*/
@inlinable
public func Label<S: StringProtocol>(
    _ string: S,
    fontName: String = defaultLabelFontName,
    fontSize: CGFloat = defaultLabelFontSize
) -> Text {
    return Text(string)
        .font(.custom(fontName, size: fontSize))
}

/**
A `Text` that has a default font already set, so that you don't have to remember to set the `font` modifier.
*/
@inlinable
public func Label(
    _ key: LocalizedStringKey,
    tableName: String? = nil,
    bundle: Bundle? = nil,
    comment: StaticString? = nil,
    fontName: String = defaultLabelFontName,
    fontSize: CGFloat = defaultLabelFontSize
) -> Text {
    return Text(
        key,
        tableName: tableName,
        bundle: bundle,
        comment: comment
    ).font(.custom(fontName, size: fontSize))
}

/**
A `Text` that has a default font already set, so that you don't have to remember to set the `font` modifier.
*/
@inlinable
public func Label(
    verbatim content: String,
    fontName: String = defaultLabelFontName,
    fontSize: CGFloat = defaultLabelFontSize
) -> Text {
    return Text(verbatim: content)
        .font(.custom(fontName, size: fontSize))
}
