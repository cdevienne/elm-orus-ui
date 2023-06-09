module OUI.Button exposing
    ( Button, Type(..), Action(..)
    , new
    , withIcon, color
    , onClick, link, disabled
    , elevatedButton, filledButton, outlinedButton, textButton, smallFAB, mediumFAB, largeFAB, extendedFAB, iconButton, filledIconButton, outlinedIconButton
    , properties
    )

{-| A button creation API

@docs Button, Type, Action


# Constructor

@docs new


# Basic properties

@docs withIcon, color


# Actions

A button must have one and only one action that can be set with one of the
following functions.

@docs onClick, link, disabled


# Button types

@docs elevatedButton, filledButton, outlinedButton, textButton, smallFAB, mediumFAB, largeFAB, extendedFAB, iconButton, filledIconButton, outlinedIconButton


# Internal

@docs properties

-}

import OUI exposing (Color(..))
import OUI.Icon exposing (Icon)


{-| A button type
-}
type Type
    = Elevated
    | Filled
    | Outlined
    | Text
    | SmallFAB
    | MediumFAB
    | LargeFAB
    | ExtendedFAB
    | FilledIcon
    | OutlinedIcon
    | Icon


{-| A button action
-}
type Action msg
    = Disabled
    | OnClick msg
    | Link String


{-| underlying properties of the button
-}
type alias Props msg =
    { text : String
    , icon : Maybe Icon
    , action : Action msg
    , color : Color
    , type_ : Type
    }


{-| A button
-}
type Button constraints msg
    = Button (Props msg)


{-| Create a button with the given label

A text and an action (onClick, link or disabled) must be set before it can be
rendered

The text is mandatory for icon buttons too and will be used as a 'aria-label'
property.

By default, the button is of the 'Elevated' type, and its color is 'Primary'

-}
new : String -> Button { needOnClickOrDisabled : (), hasNoIcon : () } msg
new label =
    Button
        { text = label
        , icon = Nothing
        , action = Disabled
        , color = Primary
        , type_ = Elevated
        }


{-| Set the button primary color
-}
color : Color -> Button a msg -> Button a msg
color value (Button props) =
    Button { props | color = value }


btntype : Type -> Button a msg -> Button a msg
btntype value (Button props) =
    Button { props | type_ = value }


{-| Set the button type to 'Elevated' (default)
-}
elevatedButton : Button a msg -> Button a msg
elevatedButton =
    btntype Elevated


{-| Set the button type to 'Filled'
-}
filledButton : Button a msg -> Button a msg
filledButton =
    btntype Filled


{-| Set the button type to 'Outlined'
-}
outlinedButton : Button a msg -> Button a msg
outlinedButton =
    btntype Outlined


{-| Set the button type to 'TextButton'
-}
textButton : Button a msg -> Button a msg
textButton =
    btntype Text


{-| Set the button type to 'SmallFAB'
-}
smallFAB : Button { a | hasIcon : () } msg -> Button { a | hasIcon : () } msg
smallFAB =
    btntype SmallFAB


{-| Set the button type to 'MediumFAB'
-}
mediumFAB : Button { a | hasIcon : () } msg -> Button { a | hasIcon : () } msg
mediumFAB =
    btntype MediumFAB


{-| Set the button type to 'LargeFAB'
-}
largeFAB : Button { a | hasIcon : () } msg -> Button { a | hasIcon : () } msg
largeFAB =
    btntype LargeFAB


{-| Set the button type to 'ExtendedFAB'
-}
extendedFAB : Button a msg -> Button a msg
extendedFAB =
    btntype ExtendedFAB


{-| Set the button type to 'FilledIconButton'
-}
filledIconButton : Button { a | hasIcon : () } msg -> Button { a | hasIcon : () } msg
filledIconButton =
    btntype FilledIcon


{-| Set the button type to 'OutlinedIconButton'
-}
outlinedIconButton : Button { a | hasIcon : () } msg -> Button { a | hasIcon : () } msg
outlinedIconButton =
    btntype OutlinedIcon


{-| Set the button type to 'IconButton'
-}
iconButton : Button { a | hasIcon : () } msg -> Button { a | hasIcon : () } msg
iconButton =
    btntype Icon


{-| Set the button icon

Can only be called once

-}
withIcon :
    Icon
    -> Button { a | hasNoIcon : () } msg
    -> Button { a | hasIcon : () } msg
withIcon value (Button props) =
    Button { props | icon = Just value }


{-| Set the button 'onClick' handler
-}
onClick : msg -> Button { a | needOnClickOrDisabled : () } msg -> Button { a | hasAction : () } msg
onClick msg (Button props) =
    Button { props | action = OnClick msg }


{-| Set the button as 'disabled'
-}
disabled : Button { props | needOnClickOrDisabled : () } msg -> Button { a | hasAction : () } msg
disabled (Button props) =
    Button props


{-| Set the button as a link to the given URL
-}
link : String -> Button { props | needOnClickOrDisabled : () } msg -> Button { a | hasAction : () } msg
link url (Button props) =
    Button
        { props
            | action = Link url
        }


{-| -}
properties :
    Button { constraints | hasAction : () } msg
    ->
        { text : String
        , icon : Maybe Icon
        , action : Action msg
        , color : Color
        , type_ : Type
        }
properties (Button props) =
    props
