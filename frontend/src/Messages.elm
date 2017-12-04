module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Home
import Page.PollNew
import Page.PollVote
import Http


type Msg
    = NoOp
      -- Message wrapper for Material Design Lite
    | Mdl (Material.Msg Msg)
      -- Page messages
    | HomeMsg Page.Home.Msg
    | UserMsg Page.User.Msg
    | PollNewMsg Page.PollNew.Msg
    | PollVoteMsg Page.PollVote.Msg
      -- Routing between pages
    | SetRoute Route.Route
    | UserPageLoaded (Result Http.Error Page.User.Model)
    | PollVotePageLoaded (Result Http.Error Page.PollVote.Model)
