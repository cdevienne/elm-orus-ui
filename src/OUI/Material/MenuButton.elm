module OUI.Material.MenuButton exposing (..)

import Dropdown
import OUI.Button exposing (MenuButton)
import OUI.Material.Button as Button


type State
    = State
        { isOpen : Bool
        , focusedIndex : Int
        }


init : State
init =
    State
        { isOpen = False
        , focusedIndex = 0
        }


view : List (Attribute msg) -> MenuButton c item msg -> Element msg
view attrs menuBtn =

