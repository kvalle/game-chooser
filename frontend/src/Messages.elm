module Messages exposing (Msg(..))

import Material
import Route
import Page.User
import Page.Home
import Page.NewPoll
import Page.PollVote
import Http


type Msg
    = NoOp
      -- Message wrapper for Material Design Lite
    | Mdl (Material.Msg Msg)
      -- Page messages
    | HomeMsg Page.Home.Msg
    | UserMsg Page.User.Msg
    | NewPollMsg Page.NewPoll.Msg
    | AnswerPollMsg Page.PollVote.Msg
      -- Routing between pages
    | SetRoute Route.Route
    | UserPageLoaded (Result Http.Error Page.User.Model)
    | PollVotePageLoaded (Result Http.Error Page.PollVote.Model)
