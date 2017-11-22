module Page.User exposing (Model, Msg(..), view, init, update)

import Html exposing (..)
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
        , div [ class "game-cards" ] <| List.indexedMap (gameCard userMsg mdlMsg appState.mdl) model.games
        ]


gameCard : (Msg -> msg) -> (Material.Msg msg -> msg) -> Material.Model -> Int -> Game -> Html msg
gameCard userMsg mdlMsg mdlModel index game =
    Card.view
        [ Options.cs "game-card"
        , Options.cs "game-card-deselected" |> Options.when (not game.selected)
        , Options.css "width" "256px"
        , Elevation.e4
        ]
        [ Card.title
            [ Options.css "background" <| "url('" ++ game.thumbnail_url ++ "') center / cover"
            , Options.css "height" "256px"
            , Options.css "padding" "0"
            , Options.onClick <| userMsg <| SetSelection game.id (not game.selected)
            ]
            [ Card.head
                [ Options.scrim 0.8
                , Options.css "padding" "16px"
                , Options.css "width" "100%"
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
            ( { model | games = Utils.updateById id (Data.Game.setSelection selected) model.games }
            , Cmd.none
            )
