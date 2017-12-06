module Page.PollAnswers
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Data.Poll exposing (Poll, PollId)
import Data.Game exposing (Game, GameId)
import Material
import Material.List as Lists
import Data.AppState exposing (AppState)
import Task exposing (Task)
import Backend.Poll
import Http
import Dict exposing (Dict)


type Msg
    = NoOp


type alias Model =
    { poll : Poll }


type alias Name =
    String


init : AppState -> PollId -> Task Http.Error Model
init appState pollId =
    Task.map Model <|
        Backend.Poll.getById appState.environment pollId


view : Model -> AppState -> (Material.Msg msg -> msg) -> Html msg
view model appState mdlMsg =
    let
        games =
            Dict.values model.poll.games
    in
        Lists.ul [] <| List.map gameElement games


gameElement : Game -> Html msg
gameElement game =
    Lists.li [ Lists.withSubtitle ]
        [ Lists.content []
            [ Lists.avatarImage game.thumbnail_url []
            , text game.title
            , Lists.subtitle [] [ text "n of 5 people voted this" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
