module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Home
import Page.NewPoll
import Http


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SetRoute Route.Route
    | HomeMsg Page.Home.Msg
    | UserMsg Page.User.Msg
    | NewPollMsg Page.NewPoll.Msg
    | UserPageLoaded (Result Http.Error Page.User.Model)
