module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Start
import Page.PollNew
import Page.PollVote
import Http
import Page


type Msg
    = NoOp
      -- Message wrapper for Material Design Lite
    | Mdl (Material.Msg Msg)
      -- Page messages
    | StartMsg Page.Start.Msg
    | UserMsg Page.User.Msg
    | PollNewMsg Page.PollNew.Msg
    | PollVoteMsg Page.PollVote.Msg
      -- Routing between pages
    | PageLoaded (Result Http.Error Page.Page)
    | SetRoute Route.Route
