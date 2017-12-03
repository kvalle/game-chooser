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
import Data.Game exposing (GameId, Game)
import Material
import Material.Options as Options
import Material.Button as Button
import Backend.Poll
import Route
import Data.AppState exposing (AppState)
import Task exposing (Task)
import Http
import Utils exposing ((<<<))
import Dict
import Views.GameCard


type State
    = Selecting
    | Saving
    | Failed


type alias Model =
    { state : State
    , poll : Poll
    }


setPoll : Poll -> Model -> Model
setPoll poll model =
    { model | poll = poll }


init : AppState -> String -> Task Http.Error Model
init appState pollId =
    Task.map (Model Selecting) <|
        Backend.Poll.getById appState.environment pollId


type Msg
    = GoToPoll PollId
    | SetSelection GameId Bool
    | SubmitAnswer
    | AnswerSubmitted (Result Http.Error ())


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        GoToPoll pollId ->
            ( model, Route.newUrl <| Route.Poll pollId )

        SetSelection gameId state ->
            let
                newPoll =
                    model.poll |> Data.Poll.setGame (Data.Game.setSelection state) gameId
            in
                ( model |> setPoll newPoll
                , Cmd.none
                )

        SubmitAnswer ->
            let
                selectedGameIds =
                    model.poll.games
                        |> Dict.values
                        |> List.filter .selected
                        |> List.map .id
            in
                ( { model | state = Saving }
                , Backend.Poll.vote appState.environment model.poll.id selectedGameIds
                    |> Task.attempt AnswerSubmitted
                )

        AnswerSubmitted result ->
            case result of
                Err err ->
                    ( { model | state = Failed }, Cmd.none )

                Ok () ->
                    ( model
                    , Route.newUrl <| Route.Poll model.poll.id
                    )


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState newPollMsg mdlMsg =
    div [ class "answer-poll-wrapper" ]
        [ h3 [] [ text <| "What do you want to play?" ]
        , span [] <|
            case model.state of
                Selecting ->
                    [ submitButton (Dict.values model.poll.games) (newPollMsg SubmitAnswer) mdlMsg appState.mdl ]

                Failed ->
                    [ submitButton (Dict.values model.poll.games) (newPollMsg SubmitAnswer) mdlMsg appState.mdl
                    , span [] [ text "Submitting answers failed :( Please try again…" ]
                    ]

                Saving ->
                    [ Button.render mdlMsg
                        [ 0 ]
                        appState.mdl
                        [ Button.disabled ]
                        [ text "Saving…" ]
                    ]
        , div [ class "game-cards" ] <|
            Views.GameCard.cards
                (newPollMsg <<< SetSelection)
                mdlMsg
                appState.mdl
                (Dict.values model.poll.games)
        ]


submitButton : List Game -> msg -> (Material.Msg msg -> msg) -> Material.Model -> Html msg
submitButton games msg mdlMsg mdlModel =
    Button.render mdlMsg
        [ 0 ]
        mdlModel
        [ Button.raised
        , Button.colored
        , Button.disabled |> Options.when (List.all (not << .selected) games)
        , Options.onClick msg
        ]
        [ text "Submit vote" ]
