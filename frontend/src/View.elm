module View exposing (view)

import Html exposing (..)
import Model exposing (Model)
import Messages exposing (Msg)


view : Model -> Html Msg
view model =
    div [] [ text "Yay" ]
