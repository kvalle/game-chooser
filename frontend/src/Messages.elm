module Messages exposing (Msg(..))

import Material
import Route
import Page.User


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetRoute Route.Route
    | UserMsg Page.User.Msg
    | UserPageLoaded (Result String Page.User.Model)
