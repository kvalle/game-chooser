module Page.AnswerPoll
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Poll exposing (PollId, Poll)
import Material
import Backend.Poll
import Route
import Data.AppState exposing (AppState)
import Task exposing (Task)
import Http


type Msg
    = GoToPoll PollId
    | SubmitAnswer


type alias Model =
    Poll


init : AppState -> String -> Task Http.Error Model
init appState pollId =
    Backend.Poll.getById appState.environment pollId


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState newPollMsg mdlMsg =
    div [ class "answer-poll-wrapper" ]
        [ h3 [] [ text <| "Answer poll" ]
        , text "asdf"
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToPoll pollId ->
            ( model, Route.newUrl <| Route.Poll pollId )

        SubmitAnswer ->
            -- TODO
            ( model, Cmd.none )
