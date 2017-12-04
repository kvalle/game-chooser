module Views exposing (frame, loading)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.AppState exposing (AppState)
import Material.Progress


frame : AppState -> Html msg -> Html msg
frame appState content =
    div [ id "app-content" ] [ content ]


loading : Html msg
loading =
    div [ class "fill-screen center-content" ]
        [ Material.Progress.indeterminate ]
