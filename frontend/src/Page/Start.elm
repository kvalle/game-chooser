module Page.Start
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
import Views.Helper.KeyCode as KeyCode


type Msg
    = Edit String
    | Submit


type alias Model =
    String


init : Model
init =
    ""


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState startMsg mdlMsg =
    div [ class "fill-screen center-content" ]
        [ Textfield.render mdlMsg
            [ 0 ]
            appState.mdl
            [ Textfield.label "Board Game Geek username?"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value model
            , Options.onInput (startMsg << Edit)
            , Options.on "keydown" (KeyCode.decoderFor KeyCode.enter <| startMsg Submit)
            ]
            []
        , Button.render mdlMsg
            [ 1 ]
            appState.mdl
            [ Button.raised
            , Button.ripple
            , Options.onClick (startMsg Submit)
            , Button.disabled |> Options.when (model == "")
            ]
            [ text "Submit" ]
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        Edit newName ->
            ( newName, Cmd.none )

        Submit ->
            ( model, Route.newUrl (User model) )
