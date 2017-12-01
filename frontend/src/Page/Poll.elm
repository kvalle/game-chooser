module Page.Poll
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Data.Poll exposing (PollId)
import Material
import Data.AppState exposing (AppState)


type Msg
    = NoOp


type alias Model =
    PollId


init : PollId -> Model
init pollId =
    pollId


view : Model -> AppState -> (Material.Msg msg -> msg) -> Html msg
view model appState mdlMsg =
    text <| "Hello, I am poll " ++ model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
