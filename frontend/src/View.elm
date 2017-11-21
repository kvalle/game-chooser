module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import Messages exposing (Msg(..))
import Material
import Material.Button as Button
import Material.Options as Options exposing (css)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ text "foo" ]
