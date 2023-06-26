module OUI.Dropdown exposing (new)

{-| A dropdown menu/selector implementation

The API is largely inspired by
[paack-ui](https://package.elm-lang.org/packages/PaackEng/paack-ui/latest/UI-Dropdown)

@docs basic, filterable

-}

import OUI.Icon exposing (Icon)


type SelectionType item msg
    = SingleSelect (Maybe item -> msg) (Maybe item)
    | MultiSelect (List item -> msg) (List item)


type alias Properties item msg =
    { selection : SelectionType item msg
    , itemToText : item -> String
    , itemToIcon : Maybe (item -> Icon)
    , itemToTrailingIcon : Maybe (item -> Icon)
    , onFilterChangeMsg : Maybe (String -> msg)
    }


type Dropdown item msg
    = Dropdown (Properties item msg)


basic :
    { onSelectMsg : Maybe item -> msg
    }
    -> Dropdown item msg
basic config =
    Dropdown
        { selection = SingleSelect onSelectMsg Nothing
        }
