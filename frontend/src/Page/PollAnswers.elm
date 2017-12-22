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
import Data.Game exposing (Game)
import Material
import Material.List as Lists
import Data.AppState exposing (AppState)
import Task exposing (Task)
import Backend.Poll
import Http
import Dict exposing (Dict)
import Tuple


type Msg
    = NoOp


type alias Model =
    { poll : Poll }


type alias Name =
    String


selector : Poll -> List ( Game, List Name )
selector poll =
    poll.voters
        |> Dict.toList
        |> List.filterMap
            (\( id, votes ) ->
                Maybe.map2 (,)
                    (Dict.get id poll.games)
                    (Just votes)
            )
        |> List.sortBy (Tuple.second >> List.length)
        |> List.reverse


init : AppState -> PollId -> Task Http.Error Model
init appState pollId =
    Task.map Model <|
        Backend.Poll.getById appState.environment pollId


view : Model -> AppState -> (Material.Msg msg -> msg) -> Html msg
view model appState mdlMsg =
    let
        games =
            selector model.poll

        numberOfParticipants =
            Dict.size model.poll.votes
    in
        div []
            [ h3 [] [ text <| "Poll results" ]
            , Lists.ul [] <| List.map (gameElement numberOfParticipants) games
            ]


gameElement : Int -> ( Game, List Name ) -> Html msg
gameElement numberOfParticipants ( game, voters ) =
    let
        votes =
            List.length voters |> toString
    in
        Lists.li [ Lists.withSubtitle ]
            [ Lists.content []
                [ Lists.avatarImage game.thumbnail_url []
                , text game.title
                , Lists.subtitle []
                    [ text votes
                    , text " of "
                    , text <| toString numberOfParticipants
                    , text " people voted this"
                    ]
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
