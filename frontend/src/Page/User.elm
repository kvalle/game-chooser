module Page.User exposing (Model, Msg(..), view, init, update)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Data.AppState exposing (AppState)
import Backend.User
import Backend.Game
import Data.User exposing (User)
import Data.Game exposing (Game, GameId)
import Http
import Material.Card as Card
import Material.Options as Options
import Material.Typography as Typography
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Toggles as Toggles
import Material
import Utils


type Msg
    = SetSelection GameId Bool
    | SelectAll
    | DeselectAll


type alias Model =
    { user : User
    , games : List Game
    }


init : AppState -> String -> Task Http.Error Model
init appState name =
    let
        getUser =
            Backend.User.getByName appState.environment name

        getGames =
            Backend.Game.getByName appState.environment name
    in
        Task.map2 Model getUser getGames


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState userMsg mdlMsg =
    div [ class "user-wrapper" ]
        [ h2 []
            [ text <|
                String.join ""
                    [ model.user.firstname
                    , " "
                    , model.user.lastname
                    , " ("
                    , model.user.username
                    , ")"
                    ]
            ]
        , h4 []
            [ text <| toString (List.length model.games) ++ " games "
            , text <| "(" ++ toString (model.games |> List.filter .selected |> List.length) ++ " selected)"
            ]
        , button [ onClick (userMsg SelectAll) ] [ text "Select all" ]
        , button [ onClick (userMsg DeselectAll) ] [ text "Deselect all" ]
        , div [ class "game-cards" ] <| List.indexedMap (gameCard userMsg mdlMsg appState.mdl) model.games
        ]


gameCard : (Msg -> msg) -> (Material.Msg msg -> msg) -> Material.Model -> Int -> Game -> Html msg
gameCard userMsg mdlMsg mdlModel index game =
    Card.view
        [ Options.cs "game-card"
        , Options.css "width" "200px"
        , Elevation.transition 250
        , if game.selected then
            Elevation.e4
          else
            Elevation.e0
        ]
        [ Card.title
            [ Options.css "height" "200px"
            , Options.css "padding" "0"
            , Options.css "position" "relative"
            , Options.onClick <| userMsg <| SetSelection game.id (not game.selected)
            ]
            [ div
                [ class <|
                    if game.selected then
                        "game-card-image"
                    else
                        "game-card-image game-card-deselected"
                , style [ ( "background", "url('" ++ game.thumbnail_url ++ "') center / cover" ) ]
                ]
                []
            , Card.head
                [ Options.scrim 0.8
                , Options.css "padding" "16px"
                , Options.css "width" "100%"
                , Options.css "font-size" "1.3rem"
                , Color.text Color.white
                , Typography.title
                , Typography.contrast 1.0
                ]
                [ text game.title ]
            ]
        , Card.actions
            [ Card.border ]
            [ Toggles.checkbox mdlMsg
                [ index ]
                mdlModel
                [ Options.onToggle <| userMsg <| SetSelection game.id (not game.selected)
                , Toggles.ripple
                , Toggles.value game.selected
                ]
                [ text "Selected" ]
            ]
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        SetSelection id selected ->
            ( { model
                | games =
                    Utils.updateById id (Data.Game.setSelection selected) model.games
              }
            , Cmd.none
            )

        SelectAll ->
            ( { model | games = model.games |> List.map (Data.Game.setSelection True) }
            , Cmd.none
            )

        DeselectAll ->
            ( { model | games = model.games |> List.map (Data.Game.setSelection False) }
            , Cmd.none
            )
