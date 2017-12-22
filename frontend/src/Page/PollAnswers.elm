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


type alias GameViewModel =
    { title : String
    , thumbnail_url : String
    , numberOfVotes : Int
    , totalNumberOfVoters : Int
    }


selector : Poll -> List GameViewModel
selector poll =
    poll.games
        |> Dict.toList
        |> List.map
            (\( gameId, game ) ->
                GameViewModel
                    game.title
                    game.thumbnail_url
                    (Dict.get gameId poll.voters
                        |> Maybe.map List.length
                        |> Maybe.withDefault 0
                    )
                    (Dict.size poll.votes)
            )
        |> List.sortBy .numberOfVotes
        |> List.reverse


init : AppState -> PollId -> Task Http.Error Model
init appState pollId =
    Task.map Model <|
        Backend.Poll.getById appState.environment pollId


view : Model -> AppState -> (Material.Msg msg -> msg) -> Html msg
view model appState mdlMsg =
    div []
        [ h3 [] [ text <| "Poll results" ]
        , Lists.ul [] <| List.map gameElement (selector model.poll)
        ]


gameElement : GameViewModel -> Html msg
gameElement viewModel =
    Lists.li [ Lists.withSubtitle ]
        [ Lists.content []
            [ Lists.avatarImage viewModel.thumbnail_url []
            , text viewModel.title
            , Lists.subtitle []
                [ text <| toString viewModel.numberOfVotes
                , text " of "
                , text <| toString viewModel.totalNumberOfVoters
                , text " people voted this"
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
