//
//  KindKit
//

public enum Graphics {
}

public enum UI {
}

// MARK: KindAnimation

@_exported import KindAnimation

// MARK: KindAppTracking

@_exported import KindAppTracking

// MARK: KindCamera

@_exported import KindCamera

// MARK: KindCameraUI

@_exported import KindCameraUI

// MARK: KindCondition

@_exported import KindCondition

// MARK: KindCore

@_exported import KindCore

@available(*, deprecated, renamed: "KindCore.Formatter")
public typealias Formatter = KindCore.Formatter

// MARK: KindDataSource

@_exported import KindDataSource

// MARK: KindDebug

@_exported import KindDebug

// MARK: KindEmail

@_exported import KindEmail

// MARK: KindEvent

@_exported import KindEvent

// MARK: KindFilesLibrary

@_exported import KindFilesLibrary

// MARK: KindFlow

@_exported import KindFlow

// MARK: KindForm

@_exported import KindForm

// MARK: KindGraphics

@_exported import KindGraphics

public extension Graphics {
    
    @available(*, deprecated, renamed: "KindGraphics.Context")
    typealias Context = KindGraphics.Context
    
    @available(*, deprecated, renamed: "KindGraphics.DrawMode")
    typealias DrawMode = KindGraphics.DrawMode
    
    @available(*, deprecated, renamed: "KindGraphics.Fill")
    typealias Fill = KindGraphics.Fill
    
    @available(*, deprecated, renamed: "KindGraphics.FillRule")
    typealias FillRule = KindGraphics.FillRule
    
    @available(*, deprecated, renamed: "KindGraphics.Stroke")
    typealias Stroke = KindGraphics.Stroke
    
}

public extension UI {
    
    @available(*, deprecated, renamed: "KindGraphics.Border")
    typealias Border = KindGraphics.Border
    
    @available(*, deprecated, renamed: "KindGraphics.Color")
    typealias Color = KindGraphics.Color
    
    @available(*, deprecated, renamed: "KindGraphics.CornerRadius")
    typealias CornerRadius = KindGraphics.CornerRadius
    
    @available(*, deprecated, renamed: "KindGraphics.Font")
    typealias Font = KindGraphics.Font
    
    @available(*, deprecated, renamed: "KindGraphics.Image")
    typealias Image = KindGraphics.Image
    
    @available(*, deprecated, renamed: "KindGraphics.Text")
    typealias Text = KindGraphics.Text
    
    @available(*, deprecated, renamed: "KindGraphics.Shadow")
    typealias Shadow = KindGraphics.Shadow
    
    @available(*, deprecated, renamed: "KindGraphics.Transform")
    typealias Transform = KindGraphics.Transform
    
}

// MARK: KindJSON

@_exported import KindJSON

// MARK: KindKeychain

@_exported import KindKeychain

// MARK: KindLocation

@_exported import KindLocation

// MARK: KindLog

@_exported import KindLog

// MARK: KindLogUI

@_exported import KindLogUI

// MARK: KindMarkdown

@_exported import KindMarkdown

// MARK: KindMarkdownUI

@_exported import KindMarkdownUI

// MARK: KindMath

@_exported import KindMath

public extension Graphics {
    
    enum Guide {
        
        @available(*, deprecated, renamed: "KindMath.AngleGuide")
        public typealias Angle = KindMath.AngleGuide
        
        @available(*, deprecated, renamed: "KindMath.GridGuide")
        public typealias Grid = KindMath.GridGuide
        
        @available(*, deprecated, renamed: "KindMath.LinesGuide")
        public typealias Lines = KindMath.LinesGuide
        
        @available(*, deprecated, renamed: "KindMath.PointGuide")
        public typealias Point = KindMath.PointGuide
        
        @available(*, deprecated, renamed: "KindMath.RuleGuide")
        public typealias Rule = KindMath.RuleGuide
        
    }
    
}

@available(*, deprecated, renamed: "KindMath.Point")
public typealias Point = KindMath.Point

@available(*, deprecated, renamed: "KindMath.Size")
public typealias Size = KindMath.Size

@available(*, deprecated, renamed: "KindMath.Rect")
public typealias Rect = KindMath.Rect

// MARK: KindModule

@_exported import KindModule

#if swift(>=5.9)

// MARK: KindMonadicMacro

@_exported import KindMonadicMacro

#endif

// MARK: KindNetwork

@_exported import KindNetwork

// MARK: KindPermission

@_exported import KindPermission

// MARK: KindPlayer

@_exported import KindPlayer

// MARK: KindQRCode

@_exported import KindQRCode

// MARK: KindRemoteImage

@_exported import KindRemoteImage

// MARK: KindRemoteImageUI

@_exported import KindRemoteImageUI

// MARK: KindScreenUI

@_exported import KindScreenUI

// MARK: KindShell

@_exported import KindShell

// MARK: KindSQLite

@_exported import KindSQLite

// MARK: KindSuggestion

@_exported import KindSuggestion

@available(*, deprecated, renamed: "KindSuggestion.IEntity")
public typealias IInputSuggestion = KindSuggestion.IEntity

@available(*, deprecated, renamed: "KindSuggestion.IEntityStorable")
public typealias IInputSuggestionStorable = KindSuggestion.IStorable

public enum InputSuggestion {
    
    @available(*, deprecated, renamed: "KindSuggestion.Condition")
    public typealias Condition = KindSuggestion.Condition

    @available(*, deprecated, renamed: "KindSuggestion.DataSource")
    public typealias DataSource = KindSuggestion.DataSource

    @available(*, deprecated, renamed: "KindSuggestion.Static")
    public typealias Static = KindSuggestion.Static

    @available(*, deprecated, renamed: "KindSuggestion.Throttle")
    public typealias Throttle = KindSuggestion.Throttle

}

// MARK: KindSwiftUI

@_exported import KindSwiftUI

// MARK: KindSystem

@_exported import KindSystem

// MARK: KindTimer

@_exported import KindTimer

public enum Timer {
    
    @available(*, deprecated, renamed: "KindTimer.Clock")
    public typealias Clock = KindTimer.Throttle
    
    @available(*, deprecated, renamed: "KindTimer.Debounce")
    public typealias Debounce = KindTimer.Debounce
    
    @available(*, deprecated, renamed: "KindTimer.Every")
    public typealias Every = KindTimer.Every
    
    @available(*, deprecated, renamed: "KindTimer.Interval")
    public typealias Interval = KindTimer.Interval
    
    @available(*, deprecated, renamed: "KindTimer.Once")
    public typealias Once = KindTimer.Once
    
    @available(*, deprecated, renamed: "KindTimer.Throttle")
    public typealias Throttle = KindTimer.Throttle
    
}

// MARK: KindUI

@_exported import KindUI

// MARK: KindUIClock

@_exported import KindUIClock

// MARK: KindUndoRedo

@_exported import KindUndoRedo

// MARK: KindUserDefaults

@_exported import KindUserDefaults

// MARK: KindVideoPlayerUI

@_exported import KindVideoPlayerUI

// MARK: KindWebUI

@_exported import KindWebUI

// MARK: KindXML

@_exported import KindXML
