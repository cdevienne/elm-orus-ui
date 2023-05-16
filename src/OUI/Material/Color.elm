module OUI.Material.Color exposing
    ( KeyColors
    , Scheme
    , darkFromKeyColors
    , defaultDarkScheme
    , defaultKeyColors
    , defaultLightScheme
    , focusStateLayerOpacity
    , getColor
    , getElementColor
    , getOnColor
    , getOnElementColor
    , hoverStateLayerOpacity
    , lightFromKeyColors
    , pressStateLayerOpacity
    , setAlpha
    , toElementColor
    , withShade
    )

import Color exposing (Color)
import Color.Convert as Convert
import Element
import OUI


hoverStateLayerOpacity : Float
hoverStateLayerOpacity =
    0.08


focusStateLayerOpacity : Float
focusStateLayerOpacity =
    0.12


pressStateLayerOpacity : Float
pressStateLayerOpacity =
    0.12


toElementColor : Color.Color -> Element.Color
toElementColor =
    Color.toRgba
        >> Element.fromRgb


getElementColor : OUI.Color -> Scheme -> Element.Color
getElementColor c =
    getColor c
        >> toElementColor


getOnElementColor : OUI.Color -> Scheme -> Element.Color
getOnElementColor c =
    getOnColor c
        >> toElementColor


getColor : OUI.Color -> Scheme -> Color.Color
getColor c =
    case c of
        OUI.Primary ->
            .primary

        OUI.PrimaryContainer ->
            .primaryContainer

        OUI.Secondary ->
            .secondary

        OUI.SecondaryContainer ->
            .secondaryContainer

        OUI.Tertiary ->
            .tertiary

        OUI.TertiaryContainer ->
            .tertiaryContainer

        OUI.Error ->
            .error

        OUI.ErrorContainer ->
            .errorContainer


getOnColor : OUI.Color -> Scheme -> Color.Color
getOnColor c =
    case c of
        OUI.Primary ->
            .onPrimary

        OUI.PrimaryContainer ->
            .onPrimaryContainer

        OUI.Secondary ->
            .onSecondary

        OUI.SecondaryContainer ->
            .onSecondaryContainer

        OUI.Tertiary ->
            .onTertiary

        OUI.TertiaryContainer ->
            .onTertiaryContainer

        OUI.Error ->
            .onError

        OUI.ErrorContainer ->
            .onErrorContainer


setAlpha : Float -> Color.Color -> Color.Color
setAlpha value color =
    let
        rgba =
            Color.toRgba color
    in
    Color.fromRgba
        { rgba
            | alpha = value
        }


{-| Utility function to convert a color to CIELCH color space
-}
toCIELCH : Color -> { l : Float, c : Float, h : Float }
toCIELCH =
    Convert.colorToLab
        >> (\{ l, a, b } ->
                { l = l
                , c = sqrt (a * a + b * b)
                , h = atan2 b a
                }
           )


{-| Utility function to convert CIELCH color space back to a color
-}
fromCIELCH : { l : Float, c : Float, h : Float } -> Color
fromCIELCH =
    (\{ l, c, h } ->
        { l = l
        , a = c * cos h
        , b = c * sin h
        }
    )
        >> Convert.labToColor


{-| Simulates adding a color in front (subtractive color mixing).

    --Darkens the color by 50%
    withShade (Color.rgb255 255 255 255) 0.5

    --Makes the color 50% more red
    withShade (Color.rgb255 255 0 0) 0.5

-}
withShade : Color -> Float -> Color -> Color
withShade c2 amount c1 =
    let
        alpha =
            c1
                |> Color.toRgba
                |> .alpha

        fun a b =
            { l = (a.l * (1 - amount) + b.l * amount) / 1
            , c = (a.c * (1 - amount) + b.c * amount) / 1
            , h = (a.h * (1 - amount) + b.h * amount) / 1
            }
    in
    fun (toCIELCH c1) (toCIELCH c2)
        |> fromCIELCH
        |> Color.toRgba
        |> (\color -> { color | alpha = alpha })
        |> Color.fromRgba


type alias KeyColors =
    { primary : Color
    , secondary : Color
    , tertiary : Color
    , error : Color
    , neutral : Color
    , neutralVariant : Color
    }


defaultKeyColors =
    { primary = Color.rgb255 0x67 0x50 0xA4
    , secondary = Color.rgb255 0x62 0x5B 0x71
    , tertiary = Color.rgb255 0x7D 0x52 0x60
    , error = Color.rgb255 0xB3 0x26 0x1E
    , neutral = Color.rgb255 0x40 0x40 0x40
    , neutralVariant = Color.rgb255 0x40 0x40 0x40
    }


defaultLightScheme : Scheme
defaultLightScheme =
    lightFromKeyColors defaultKeyColors


defaultDarkScheme : Scheme
defaultDarkScheme =
    darkFromKeyColors defaultKeyColors


lightFromKeyColors : KeyColors -> Scheme
lightFromKeyColors keyColors =
    { primary = tone 40 keyColors.primary
    , primaryContainer = tone 90 keyColors.primary
    , onPrimary = tone 100 keyColors.primary
    , onPrimaryContainer = tone 10 keyColors.primary
    , inversePrimary = tone 80 keyColors.primary
    , secondary = tone 40 keyColors.secondary
    , secondaryContainer = tone 90 keyColors.secondary
    , onSecondary = tone 100 keyColors.secondary
    , onSecondaryContainer = tone 10 keyColors.primary
    , tertiary = tone 40 keyColors.tertiary
    , tertiaryContainer = tone 90 keyColors.tertiary
    , onTertiary = tone 100 keyColors.tertiary
    , onTertiaryContainer = tone 10 keyColors.tertiary
    , surface = tone 98 keyColors.neutral
    , surfaceDim = tone 87 keyColors.neutral
    , surfaceBright = tone 98 keyColors.neutral
    , surfaceContainerLowest = tone 100 keyColors.neutral
    , surfaceContainerLow = tone 96 keyColors.neutral
    , surfaceContainer = tone 94 keyColors.neutral
    , surfaceContainerHigh = tone 92 keyColors.neutral
    , surfaceContainerHighest = tone 90 keyColors.neutral
    , surfaceVariant = tone 90 keyColors.neutralVariant
    , onSurface = tone 10 keyColors.neutral
    , onSurfaceVariant = tone 30 keyColors.neutralVariant
    , inverseSurface = tone 20 keyColors.neutral
    , inverseOnSurface = tone 95 keyColors.neutral
    , background = tone 98 keyColors.neutral
    , onBackground = tone 10 keyColors.neutral
    , error = tone 40 keyColors.error
    , errorContainer = tone 90 keyColors.error
    , onError = tone 100 keyColors.error
    , onErrorContainer = tone 10 keyColors.error
    , outline = tone 50 keyColors.neutralVariant
    , outlineVariant = tone 80 keyColors.neutralVariant
    , shadow = tone 0 keyColors.neutral |> setAlpha 0.16
    , surfaceTint = keyColors.primary
    , scrim = tone 0 keyColors.neutral
    }


darkFromKeyColors : KeyColors -> Scheme
darkFromKeyColors keyColors =
    { primary = tone 80 keyColors.primary
    , primaryContainer = tone 30 keyColors.primary
    , onPrimary = tone 20 keyColors.primary
    , onPrimaryContainer = tone 90 keyColors.primary
    , inversePrimary = tone 40 keyColors.primary
    , secondary = tone 80 keyColors.secondary
    , secondaryContainer = tone 30 keyColors.secondary
    , onSecondary = tone 20 keyColors.secondary
    , onSecondaryContainer = tone 90 keyColors.primary
    , tertiary = tone 80 keyColors.tertiary
    , tertiaryContainer = tone 30 keyColors.tertiary
    , onTertiary = tone 20 keyColors.tertiary
    , onTertiaryContainer = tone 90 keyColors.tertiary
    , surface = tone 6 keyColors.neutral
    , surfaceDim = tone 6 keyColors.neutral
    , surfaceBright = tone 24 keyColors.neutral
    , surfaceContainerLowest = tone 4 keyColors.neutral
    , surfaceContainerLow = tone 10 keyColors.neutral
    , surfaceContainer = tone 12 keyColors.neutral
    , surfaceContainerHigh = tone 18 keyColors.neutral
    , surfaceContainerHighest = tone 22 keyColors.neutral
    , surfaceVariant = tone 30 keyColors.neutralVariant
    , onSurface = tone 90 keyColors.neutral
    , onSurfaceVariant = tone 80 keyColors.neutralVariant
    , inverseSurface = tone 90 keyColors.neutral
    , inverseOnSurface = tone 20 keyColors.neutral
    , background = tone 6 keyColors.neutral
    , onBackground = tone 90 keyColors.neutral
    , error = tone 80 keyColors.error
    , errorContainer = tone 30 keyColors.error
    , onError = tone 20 keyColors.error
    , onErrorContainer = tone 90 keyColors.error
    , outline = tone 60 keyColors.neutralVariant
    , outlineVariant = tone 30 keyColors.neutralVariant
    , shadow = tone 0 keyColors.neutral |> setAlpha 0.16
    , surfaceTint = keyColors.primary
    , scrim = tone 0 keyColors.neutral
    }


tone : Int -> Color -> Color
tone light color =
    let
        hsla =
            Color.toHsla color

        fLight =
            if light <= 0 then
                0.0

            else if light >= 100 then
                1.0

            else
                toFloat light / 100
    in
    Color.fromHsla
        { hsla
            | lightness = fLight
        }


type alias Scheme =
    { primary : Color
    , primaryContainer : Color
    , onPrimary : Color
    , onPrimaryContainer : Color
    , inversePrimary : Color
    , secondary : Color
    , secondaryContainer : Color
    , onSecondary : Color
    , onSecondaryContainer : Color
    , tertiary : Color
    , tertiaryContainer : Color
    , onTertiary : Color
    , onTertiaryContainer : Color
    , surface : Color
    , surfaceDim : Color
    , surfaceBright : Color
    , surfaceContainerLowest : Color
    , surfaceContainerLow : Color
    , surfaceContainer : Color
    , surfaceContainerHigh : Color
    , surfaceContainerHighest : Color
    , surfaceVariant : Color
    , onSurface : Color
    , onSurfaceVariant : Color
    , inverseSurface : Color
    , inverseOnSurface : Color
    , background : Color
    , onBackground : Color
    , error : Color
    , errorContainer : Color
    , onError : Color
    , onErrorContainer : Color
    , outline : Color
    , outlineVariant : Color
    , shadow : Color
    , surfaceTint : Color
    , scrim : Color
    }