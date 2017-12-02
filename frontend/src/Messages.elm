module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Home
import Page.NewPoll
import Page.AnswerPoll
import Http


type Msg
    = NoOp
      -- Message wrapper for Material Design Lite
    | Mdl (Material.Msg Msg)
      -- Page messages
    | HomeMsg Page.Home.Msg
    | UserMsg Page.User.Msg
    | NewPollMsg Page.NewPoll.Msg
    | AnswerPollMsg Page.AnswerPoll.Msg
      -- Routing between pages
    | SetRoute Route.Route
    | UserPageLoaded (Result Http.Error Page.User.Model)
    | AnswerPollPageLoaded (Result Http.Error Page.AnswerPoll.Model)
