module Page.PollVote
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
import Material.Textfield as Textfield
import Backend.Poll
import Route
import Data.AppState exposing (AppState)
import Task exposing (Task)
import Http
import Utils exposing ((<<<))
import Dict
import Views.GameCard
import Views.Helper.KeyCode as KeyCode


type Msg
    = UpdateName String
    | SubmitName String
    | SetGameSelection GameId Bool
    | SubmitVotes
    | VotesSubmitted (Result Http.Error ())


type VoteState
    = Selecting
    | Saving
    | Failed


type alias Name =
    String


type Model
    = AskName Poll Name
    | AskGames Poll Name VoteState


setPoll : Poll -> Model -> Model
setPoll poll model =
    case model of
        AskName _ name ->
            AskName poll name

        AskGames _ name voteState ->
            AskGames poll name voteState


getPoll : Model -> Poll
getPoll model =
    case model of
        AskName poll name ->
            poll

        AskGames poll name voteState ->
            poll


getName : Model -> Name
getName model =
    case model of
        AskName poll name ->
            name

        AskGames poll name voteState ->
            name


setVoteState : VoteState -> Model -> Model
setVoteState voteState model =
    case model of
        AskName poll name ->
            -- no change
            model

        AskGames poll name _ ->
            AskGames poll name voteState


init : AppState -> String -> Task Http.Error Model
init appState pollId =
    Task.map (flip AskName "") <|
        Backend.Poll.getById appState.environment pollId


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        SetGameSelection gameId state ->
            let
                newPoll =
                    model |> getPoll |> Data.Poll.setGame (Data.Game.setSelection state) gameId
            in
                ( model |> setPoll newPoll
                , Cmd.none
                )

        SubmitName name ->
            ( AskGames (getPoll model) name Selecting
            , Cmd.none
            )

        UpdateName name ->
            ( AskName (getPoll model) name
            , Cmd.none
            )

        SubmitVotes ->
            let
                selectedGameIds =
                    model
                        |> getPoll
                        |> .games
                        |> Dict.values
                        |> List.filter .selected
                        |> List.map .id
            in
                case model of
                    AskName poll name ->
                        -- Not supposed to save votes in this state
                        ( model, Cmd.none )

                    AskGames poll name voteState ->
                        ( AskGames poll name Saving
                        , Backend.Poll.vote appState.environment poll.id name selectedGameIds
                            |> Task.attempt VotesSubmitted
                        )

        VotesSubmitted result ->
            case result of
                Err err ->
                    ( model |> setVoteState Failed
                    , Cmd.none
                    )

                Ok () ->
                    ( model
                    , Route.newUrl <| Route.PollAnswers (model |> getPoll |> .id)
                    )


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState msgWrapper mdlMsg =
    case model of
        AskName poll name ->
            viewNameForm name appState msgWrapper mdlMsg

        AskGames poll name voteState ->
            viewGames poll voteState appState msgWrapper mdlMsg


viewNameForm : String -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
viewNameForm name appState msgWrapper mdlMsg =
    div [ class "fill-screen center-content" ]
        [ Textfield.render mdlMsg
            [ 0 ]
            appState.mdl
            [ Textfield.label "What is your name?"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value name
            , Options.onInput (msgWrapper << UpdateName)
            , Options.on "keydown"
                (KeyCode.decoderFor KeyCode.enter <|
                    msgWrapper <|
                        SubmitName name
                )
            ]
            []
        , Button.render mdlMsg
            [ 1 ]
            appState.mdl
            [ Button.raised
            , Button.colored
            , Options.onClick (msgWrapper <| SubmitName name)
            , Button.disabled |> Options.when (name == "")
            ]
            [ text "Submit" ]
        ]


viewGames : Poll -> VoteState -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
viewGames poll voteState appState msgWrapper mdlMsg =
    div [ class "answer-poll-wrapper" ]
        [ h3 [] [ text <| "Which games do you want to play?" ]
        , span [] <|
            case voteState of
                Selecting ->
                    [ submitButton (Dict.values poll.games) (msgWrapper SubmitVotes) mdlMsg appState.mdl ]

                Failed ->
                    [ submitButton (Dict.values poll.games) (msgWrapper SubmitVotes) mdlMsg appState.mdl
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
                (msgWrapper <<< SetGameSelection)
                mdlMsg
                appState.mdl
                (Dict.values poll.games)
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
