module Page.User exposing (Model, Msg(..), view, init, update)

import Html exposing (..)
import Task exposing (Task)
import Data.AppState exposing (AppState)
import Backend.User
import Data.User exposing (User)
import Http


type Msg
    = NoOp


type alias Model =
    User


init : AppState -> String -> Task Http.Error Model
init appState name =
    Backend.User.getByName appState.environment name


view : Model -> Html Msg
view model =
    div []
        [ text "User page for: "
        , text model.username
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    ( model, Cmd.none )
