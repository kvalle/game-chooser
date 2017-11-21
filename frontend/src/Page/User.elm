module Page.User exposing (Model, Msg(..), view, init, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Data.AppState exposing (AppState)
import Backend.User
import Backend.Game
import Data.User exposing (User)
import Data.Game exposing (Game)
import Http


type Msg
    = NoOp


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
        , ol [] <| List.map viewGame model.games
        ]


viewGame : Game -> Html msg
viewGame game =
    li [] [ text game.name ]


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    ( model, Cmd.none )
