module OUI.Material.TextField exposing (..)

import Color
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input exposing (labelHidden)
import Html.Attributes
import OUI
import OUI.Icon exposing (Icon)
import OUI.Material.Color
import OUI.Material.Icon
import OUI.Material.Typography
import OUI.Text
import OUI.TextField


ifThenElse : Bool -> a -> a -> a
ifThenElse value ifTrue ifFalse =
    if value then
        ifTrue

    else
        ifFalse


transition : String -> Attribute msg
transition =
    Html.Attributes.style "transition"
        >> Element.htmlAttribute


type alias Theme =
    { height : Int
    , leftRightPaddingWithoutIcon : Int
    , leftRightPaddingWithIcon : Int
    , paddingBetweenIconAndText : Int
    , supportingTextTopPadding : Int
    , paddingBetweenSupportingTextAndCharacterCounter : Int
    , iconSize : Int
    , filled :
        { topBottomPadding : Int
        }
    , outlined :
        { labelLeftRightPadding : Int
        , labelBottom : Int
        , shape : Int
        }
    }


defaultTheme : Theme
defaultTheme =
    { height = 56
    , leftRightPaddingWithoutIcon = 16
    , leftRightPaddingWithIcon = 12
    , paddingBetweenIconAndText = 16
    , supportingTextTopPadding = 4
    , paddingBetweenSupportingTextAndCharacterCounter = 16
    , iconSize = 24
    , filled =
        { topBottomPadding = 8
        }
    , outlined =
        { labelLeftRightPadding = 4
        , labelBottom = 8
        , shape = 4 -- TODO use shape.corner.extra-small
        }
    }


render :
    OUI.Material.Typography.Typescale
    -> OUI.Material.Color.Scheme
    -> Theme
    -> List (Attribute msg)
    -> OUI.TextField.TextField msg
    -> Element msg
render typescale colorscheme theme attrs textfield =
    let
        p =
            OUI.TextField.properties textfield

        isEmpty =
            p.value == ""

        hasError =
            OUI.Material.Color.isError p.color

        isOutlined =
            p.type_ == OUI.TextField.Outlined

        isFilled =
            p.type_ == OUI.TextField.Filled

        labelHoldPlace =
            isEmpty && not p.hasFocus

        hasLeadingIcon =
            p.leadingIcon /= Nothing

        hasTrailingIcon =
            p.trailingIcon /= Nothing

        focusEvents =
            List.filterMap identity
                [ p.onFocus |> Maybe.map Events.onFocus
                , p.onLoseFocus |> Maybe.map Events.onLoseFocus
                ]

        bgColorAttr =
            case p.type_ of
                OUI.TextField.Filled ->
                    colorscheme.surfaceContainerHighest
                        |> OUI.Material.Color.toElementColor
                        |> Background.color

                OUI.TextField.Outlined ->
                    colorscheme.surface
                        |> OUI.Material.Color.toElementColor
                        |> Background.color

        topBorderWidth =
            if isOutlined then
                ifThenElse p.hasFocus 2 1

            else
                0

        bottomBorderWidth =
            ifThenElse p.hasFocus 2 1

        leftBorderWidth =
            if isOutlined then
                ifThenElse p.hasFocus 2 1

            else
                0

        rightBorderWidth =
            if isOutlined then
                ifThenElse p.hasFocus 2 1

            else
                0

        inputLeftOffset =
            if hasLeadingIcon then
                theme.leftRightPaddingWithIcon + theme.iconSize + theme.paddingBetweenIconAndText

            else
                theme.leftRightPaddingWithoutIcon

        inputMoveDownBy =
            if isFilled && not labelHoldPlace then
                (theme.height - theme.filled.topBottomPadding)
                    - (theme.height // 2 + typescale.body.large.lineHeight // 2)

            else
                0

        borderColor =
            if hasError || p.hasFocus then
                OUI.Material.Color.getElementColor p.color colorscheme

            else
                OUI.Material.Color.toElementColor colorscheme.onSurfaceVariant

        borderAttrs =
            transition "color 0.15s"
                :: Border.color borderColor
                :: (case p.type_ of
                        OUI.TextField.Filled ->
                            [ Border.widthEach
                                { bottom = bottomBorderWidth
                                , top = 0
                                , right = 0
                                , left = 0
                                }
                            ]

                        OUI.TextField.Outlined ->
                            [ Border.widthEach
                                { bottom = bottomBorderWidth
                                , top = topBorderWidth
                                , right = rightBorderWidth
                                , left = leftBorderWidth
                                }
                            , Border.rounded theme.outlined.shape
                            ]
                   )

        heightAttr =
            Element.height <|
                Element.px <|
                    case p.type_ of
                        OUI.TextField.Filled ->
                            theme.height

                        OUI.TextField.Outlined ->
                            theme.height

        paddingAttrs =
            case p.type_ of
                OUI.TextField.Filled ->
                    [ Element.paddingEach
                        { top =
                            ifThenElse labelHoldPlace
                                bottomBorderWidth
                                theme.filled.topBottomPadding
                        , bottom =
                            ifThenElse labelHoldPlace
                                0
                                (theme.filled.topBottomPadding - bottomBorderWidth)
                        , left =
                            ifThenElse hasLeadingIcon
                                theme.leftRightPaddingWithIcon
                                theme.leftRightPaddingWithoutIcon
                        , right =
                            ifThenElse hasTrailingIcon
                                theme.leftRightPaddingWithIcon
                                theme.leftRightPaddingWithoutIcon
                        }
                    , Element.spacing theme.paddingBetweenIconAndText
                    ]

                OUI.TextField.Outlined ->
                    [ Element.padding <|
                        ifThenElse p.hasFocus 0 1
                    ]

        label =
            p.label

        labelColor =
            if hasError || p.hasFocus then
                OUI.Material.Color.getElementColor p.color colorscheme

            else
                OUI.Material.Color.toElementColor colorscheme.onSurface

        labelElement =
            let
                staticAttrs =
                    [ transition "all 0.15s"
                    , Font.color labelColor
                    , Element.htmlAttribute <| Html.Attributes.style "pointer-events" "none"
                    ]
            in
            if labelHoldPlace then
                OUI.Text.bodyLarge label
                    |> OUI.Material.Typography.render typescale
                    |> Element.el
                        (staticAttrs
                            ++ [ Element.moveDown <|
                                    toFloat <|
                                        (theme.height // 2 - typescale.body.large.size // 2)
                                            - topBorderWidth
                               , Element.moveRight <|
                                    toFloat <|
                                        inputLeftOffset
                                            - leftBorderWidth
                               ]
                        )

            else if isOutlined then
                let
                    topOffset =
                        typescale.body.small.size // 2
                in
                OUI.Text.bodySmall label
                    |> OUI.Material.Typography.render typescale
                    |> Element.el
                        (staticAttrs
                            ++ [ Element.moveUp <| toFloat <| topOffset
                               , Element.moveRight <|
                                    toFloat <|
                                        (theme.leftRightPaddingWithoutIcon - theme.outlined.labelLeftRightPadding)
                               , Element.paddingXY theme.outlined.labelLeftRightPadding 0
                               , Element.htmlAttribute
                                    (Html.Attributes.style "background"
                                        ("linear-gradient(to bottom, transparent 0 "
                                            ++ String.fromInt topOffset
                                            ++ "px, "
                                            ++ Color.toCssString colorscheme.surface
                                            ++ " "
                                            ++ String.fromInt topOffset
                                            ++ "px)"
                                        )
                                    )
                               ]
                        )

            else
                OUI.Text.bodySmall label
                    |> OUI.Material.Typography.render typescale
                    |> Element.el
                        (staticAttrs
                            ++ [ Element.moveDown <|
                                    toFloat <|
                                        theme.filled.topBottomPadding
                                            + (typescale.body.large.lineHeight - typescale.body.large.size)
                                            // 2
                               , Element.moveRight <|
                                    toFloat <|
                                        inputLeftOffset
                                            - leftBorderWidth
                               ]
                        )

        fontColorAttr =
            colorscheme.onSurface
                |> OUI.Material.Color.toElementColor
                |> Font.color
    in
    Element.column
        (Element.spacing theme.supportingTextTopPadding
            :: Element.inFront labelElement
            :: attrs
        )
    <|
        Element.row
            (bgColorAttr
                :: fontColorAttr
                :: heightAttr
                :: borderAttrs
                ++ paddingAttrs
            )
            ((case p.leadingIcon of
                Just icon ->
                    [ OUI.Material.Icon.renderWithSizeColor 24 colorscheme.onSurfaceVariant [] icon
                    ]

                Nothing ->
                    []
             )
                ++ [ Input.text
                        (bgColorAttr
                            :: Border.width 0
                            -- 12 is the default vertical padding of Input.text
                            -- and is needed to have enough height for the text
                            :: Element.paddingXY 0 12
                            :: (Element.moveDown <| toFloat inputMoveDownBy)
                            :: focusEvents
                            ++ OUI.Material.Typography.attrs typescale OUI.Text.Body OUI.Text.Large
                        )
                        { onChange = p.onChange
                        , text = p.value
                        , label = Input.labelHidden p.label
                        , placeholder = Nothing
                        }
                   ]
            )
            :: (case p.supportingText of
                    Just text ->
                        [ Element.el
                            [ colorscheme.onSurfaceVariant
                                |> OUI.Material.Color.toElementColor
                                |> Font.color
                            , Element.paddingXY theme.leftRightPaddingWithoutIcon 0
                            ]
                            (OUI.Text.bodySmall text
                                |> OUI.Material.Typography.render typescale
                            )
                        ]

                    Nothing ->
                        []
               )