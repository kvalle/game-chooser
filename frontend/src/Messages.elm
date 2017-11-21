module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Home


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetRoute Route.Route
    | HomeMsg Page.Home.Msg
    | UserMsg Page.User.Msg
    | UserPageLoaded (Result String Page.User.Model)
