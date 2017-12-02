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
import Data.Poll exposing (PollId)
import Material
import Route exposing (Route(..))
import Data.AppState exposing (AppState)


type Msg
    = GoToPoll PollId
    | SubmitAnswer


type alias Model =
    PollId


init : PollId -> Model
init pollId =
    pollId


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
            ( model, Route.newUrl <| Poll pollId )

        SubmitAnswer ->
            ( model, Route.newUrl <| AnswerPoll model )
