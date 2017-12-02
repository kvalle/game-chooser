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


type Msg
    = GoToPoll PollId
    | SetSelection GameId Bool
    | SubmitAnswer


type alias Model =
    Poll


init : AppState -> String -> Task Http.Error Model
init appState pollId =
    Backend.Poll.getById appState.environment pollId


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState newPollMsg mdlMsg =
    div [ class "answer-poll-wrapper" ]
        [ h3 [] [ text <| "What do you want to play?" ]
        , submitButton (Dict.values model.games) (newPollMsg SubmitAnswer) mdlMsg appState.mdl
        , div [ class "game-cards" ] <|
            Views.GameCard.cards
                (newPollMsg <<< SetSelection)
                mdlMsg
                appState.mdl
                (Dict.values model.games)
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToPoll pollId ->
            ( model, Route.newUrl <| Route.Poll pollId )

        SetSelection gameId state ->
            ( { model
                | games =
                    Dict.update gameId
                        (Maybe.map (Data.Game.setSelection state))
                        model.games
              }
            , Cmd.none
            )

        SubmitAnswer ->
            -- TODO
            ( model, Cmd.none )
