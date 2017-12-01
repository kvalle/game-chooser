module Page.NewPoll
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Data.Poll exposing (PollId)


type Msg
    = NoOp


type alias Model =
    PollId


init : PollId -> Model
init pollId =
    pollId


view : Model -> Html msg
view model =
    text <| "new poll: " ++ model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
