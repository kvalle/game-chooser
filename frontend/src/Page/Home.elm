module Page.Home
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Html.Events exposing (onInput, onClick)
import Data.AppState exposing (AppState)
import Route exposing (Route(..))


type Msg
    = EditField String
    | Submit


type alias Model =
    { username : String }


init : Model
init =
    { username = "" }


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput EditField ] []
        , button [ onClick Submit ] [ text "Submit" ]
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        EditField newName ->
            ( { model | username = newName }, Cmd.none )

        Submit ->
            ( model, Route.modifyUrl (User model.username) )
