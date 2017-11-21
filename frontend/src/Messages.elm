module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Home
import Http


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetRoute Route.Route
    | HomeMsg Page.Home.Msg
    | UserMsg Page.User.Msg
    | UserPageLoaded (Result Http.Error Page.User.Model)
