module Page exposing (Page(..), PageState(..), getPage)

import Page.Start
import Page.User
import Page.PollNew
import Page.PollVote
import Page.PollAnswers


type Page
    = Blank
    | Start Page.Start.Model
    | User Page.User.Model
    | PollNew Page.PollNew.Model
    | PollVote Page.PollVote.Model
    | PollAnswers Page.PollAnswers.Model
    | Error String


type PageState
    = Loaded Page
    | TransitioningFrom Page


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
