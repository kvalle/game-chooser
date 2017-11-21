module Views exposing (frame, loading)

import Html exposing (..)
import Html.Attributes exposing (..)
import AppState exposing (AppState)


frame : AppState -> Html msg -> Html msg
frame appState content =
    div [ style [ ( "border", "1px solid red" ) ] ]
        [ content ]


loading : Html msg
loading =
    text "loading"
