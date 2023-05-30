module OUI.Menu exposing
    ( Menu
    , SelectionType(..)
    , new
    , withIcon
    , withItems
    , withMultiSelect
    , withSingleSelect
    , withTrailingIcon
    )

{-| A general purpose menu
-}

import OUI.Icon exposing (Icon)


type SelectionType item msg
    = NoSelect
    | SingleSelect (Maybe item -> msg) (Maybe item)
    | MultiSelect (List item -> msg) (List item)


type Menu constraint item msg
    = Menu
        { items : List item
        , itemToText : item -> String
        , itemToIcon : Maybe (item -> Icon)
        , itemToTrailingIcon : Maybe (item -> Icon)
        , selection : SelectionType item msg
        }


new : (item -> String) -> Menu { noSelect : () } item msg
new itemToText =
    Menu
        { itemToText = itemToText
        , items = []
        , itemToIcon = Nothing
        , itemToTrailingIcon = Nothing
        , selection = NoSelect
        }


withItems : List item -> Menu c item msg -> Menu c item msg
withItems items (Menu props) =
    Menu
        { props
            | items = items
        }


withIcon : (item -> Icon) -> Menu c item msg -> Menu c item msg
withIcon itemToIcon (Menu props) =
    Menu
        { props
            | itemToIcon = Just itemToIcon
        }


withTrailingIcon : (item -> Icon) -> Menu c item msg -> Menu c item msg
withTrailingIcon itemToIcon (Menu props) =
    Menu
        { props
            | itemToTrailingIcon = Just itemToIcon
        }


withSingleSelect :
    (item -> msg)
    -> Maybe Item
    -> Menu { noSelect : () } item msg
    -> Menu { hasSelect : (), singleSelect : () } item msg
withSingleSelect onSelect selected (Menu props) =
    Menu
        { props
            | selection = SingleSelect onSelect selected
        }


withMultiSelect :
    (List item -> msg)
    -> List Item
    -> Menu { noSelect : () } item msg
    -> Menu { hasSelect : (), multiSelect : () } item msg
withMultiSelect onSelect selected (Menu props) =
    Menu
        { props
            | selection = MultiSelect onSelect selected
        }
