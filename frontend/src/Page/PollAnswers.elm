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
import Data.AppState exposing (AppState)
import Task exposing (Task)
import Backend.Poll
import Http


type Msg
    = NoOp


type alias Model =
    { poll : Poll }


init : AppState -> PollId -> Task Http.Error Model
init appState pollId =
    Task.map Model <|
        Backend.Poll.getById appState.environment pollId


view : Model -> AppState -> (Material.Msg msg -> msg) -> Html msg
view model appState mdlMsg =
    text <| "Hello, I am poll " ++ model.poll.id


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
