module Page exposing (Page(..))

import Page.Home
import Page.User
import Page.PollNew
import Page.PollVote
import Page.PollAnswers


type Page
    = Blank
    | Home Page.Home.Model
    | User Page.User.Model
    | PollNew Page.PollNew.Model
    | PollVote Page.PollVote.Model
    | PollAnswers Page.PollAnswers.Model
    | Error String
