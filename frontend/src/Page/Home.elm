module Page.Home
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.AppState exposing (AppState)
import Route exposing (Route(..))
import Material.Textfield as Textfield
import Material.Options as Options
import Material
import Material.Button as Button
import Json.Decode
import Json.Decode


type Msg
    = Edit String
    | Submit


type alias Model =
    { username : String }


init : Model
init =
    { username = "" }


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState homeMsg mdlMsg =
    div [ class "home-wrapper" ]
        [ Textfield.render mdlMsg
            [ 0 ]
            appState.mdl
            [ Textfield.label "Board Game Geek username?"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value model.username
            , Options.onInput (homeMsg << Edit)
            , Options.on "keydown" (keyCodeDecoder keys.enter <| homeMsg Submit)
            ]
            []
        , Button.render mdlMsg
            [ 1 ]
            appState.mdl
            [ Button.raised
            , Button.ripple
            , Options.onClick (homeMsg Submit)
            , Button.disabled |> Options.when (model.username == "")
            ]
            [ text "Submit" ]
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        Edit newName ->
            ( { model | username = newName }, Cmd.none )

        Submit ->
            ( model, Route.newUrl (User model.username) )


keyCodeDecoder : Int -> msg -> Json.Decode.Decoder msg
keyCodeDecoder keyCode msg =
    let
        checkKey actualCode =
            if actualCode == keyCode then
                Json.Decode.succeed msg
            else
                Json.Decode.fail "Wrong key"
    in
        Json.Decode.field "keyCode" Json.Decode.int
            |> Json.Decode.andThen checkKey


keys :
    { arrowDown : Int
    , arrowUp : Int
    , enter : Int
    , escape : Int
    , questionMark : Int
    , tab : Int
    , a : Int
    }
keys =
    { arrowDown = 40
    , arrowUp = 38
    , enter = 13
    , questionMark = 191
    , escape = 27
    , tab = 8
    , a = 65
    }
