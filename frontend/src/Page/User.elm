module Page.User exposing (Model, Msg(..), view, init, update)

import Html exposing (..)
import Task exposing (Task)
import Process
import Time
import AppState exposing (AppState)


type Msg
    = NoOp


type alias Model =
    { username : String }


init : String -> Task String Model
init name =
    Process.sleep Time.second
        |> Task.andThen (always <| Task.succeed { username = name })


view : Model -> Html Msg
view model =
    div []
        [ text "User page for: "
        , text model.username
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    ( model, Cmd.none )
