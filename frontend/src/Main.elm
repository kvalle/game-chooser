module Main exposing (..)

import Html
import Model exposing (Model)
import Messages exposing (Msg(..))
import View


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = View.view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
