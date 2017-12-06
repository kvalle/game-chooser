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
import Dict.Extra
import List.Extra
import Tuple


type Msg
    = NoOp


type alias Model =
    { poll : Poll }


type alias Name =
    String


selector : Poll -> List ( Game, List Name )
selector poll =
    -- Turn the poll into a list of games, together with the list of people
    -- that voted for that game.
    Dict.toList poll.votes
        |> List.concatMap (\( name, gameIds ) -> List.map (flip (,) name) gameIds)
        |> List.Extra.groupWhile (\a b -> (Tuple.first a) == (Tuple.first b))
        |> List.concat
        |> List.sortBy Tuple.first
        |> List.Extra.groupWhile (\a b -> (Tuple.first a) == (Tuple.first b))
        |> List.filterMap
            (\ls ->
                (Maybe.map2 (,)
                    (List.head ls |> Maybe.map Tuple.first)
                    (Just <| List.map Tuple.second ls)
                )
            )
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
            --Dict.values model.poll.games
            selector model.poll
    in
        Lists.ul [] <| List.map gameElement games


gameElement : ( Game, List Name ) -> Html msg
gameElement ( game, voters ) =
    let
        votes =
            List.length voters |> toString
    in
        Lists.li [ Lists.withSubtitle ]
            [ Lists.content []
                [ Lists.avatarImage game.thumbnail_url []
                , text game.title
                , Lists.subtitle [] [ text <| votes ++ " of 5 people voted this" ]
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
