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
import Utils


type Msg
    = ToggleGame GameId


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


view : Model -> Html Msg
view model =
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
        , h4 [] [ text <| toString (List.length model.games) ++ " games" ]
        , div [ class "game-cards" ] <| List.map gameCard model.games
        ]


gameCard : Game -> Html Msg
gameCard game =
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
            , Options.onClick <| ToggleGame game.id
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
        , Card.text []
            [ text "Lorem ipsum dolor sit amet" ]
        , Card.actions
            [ Card.border ]
            [ text "buttons here"
            ]
        ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        ToggleGame id ->
            ( { model | games = Utils.updateById id Data.Game.toggleSelection model.games }
            , Cmd.none
            )
