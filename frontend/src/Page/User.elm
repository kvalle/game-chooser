module Page.User exposing (Model, Msg(..), view, init, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Data.AppState exposing (AppState)
import Backend.User
import Backend.Game
import Backend.Poll
import Data.User exposing (User)
import Data.Poll exposing (PollId)
import Data.Game exposing (Game, GameId)
import Http
import Material.Options as Options
import Material.Button as Button
import Material
import Utils exposing ((<<<))
import Route exposing (Route(..))
import Views.GameCard


type Msg
    = SetSelection GameId Bool
    | SelectAll
    | DeselectAll
    | CreatePoll
    | PollCreated (Result Http.Error PollId)


type State
    = Selecting
    | Saving
    | Failed


type alias Model =
    { state : State
    , user : User
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
        Task.map2 (Model Selecting) getUser getGames


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
            , selectAllButton model.games (userMsg SelectAll) mdlMsg appState.mdl
            , deselectAllButton model.games (userMsg DeselectAll) mdlMsg appState.mdl
            , div [] <|
                case model.state of
                    Selecting ->
                        [ createPollButton model userMsg mdlMsg appState.mdl ]

                    Failed ->
                        [ createPollButton model userMsg mdlMsg appState.mdl
                        , span [] [ text "Creating poll failed :( Please try again…" ]
                        ]

                    Saving ->
                        [ Button.render mdlMsg
                            [ 0 ]
                            appState.mdl
                            [ Button.disabled ]
                            [ text "Creating…" ]
                        ]
            ]
        , div [ class "game-cards" ] <|
            Views.GameCard.cards
                (userMsg <<< SetSelection)
                mdlMsg
                appState.mdl
                model.games
        ]


selectAllButton : List Game -> msg -> (Material.Msg msg -> msg) -> Material.Model -> Html msg
selectAllButton games msg mdlMsg mdlModel =
    Button.render mdlMsg
        [ 0 ]
        mdlModel
        [ Button.raised
        , Button.disabled |> Options.when (List.all .selected games)
        , Options.onClick msg
        ]
        [ text "Select all" ]


deselectAllButton : List Game -> msg -> (Material.Msg msg -> msg) -> Material.Model -> Html msg
deselectAllButton games msg mdlMsg mdlModel =
    Button.render mdlMsg
        [ 0 ]
        mdlModel
        [ Button.raised
        , Button.disabled |> Options.when (List.all (not << .selected) games)
        , Options.onClick msg
        ]
        [ text "Deselect all" ]


createPollButton : Model -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Material.Model -> Html msg
createPollButton model userMsg mdlMsg mdlModel =
    Button.render mdlMsg
        [ 0 ]
        mdlModel
        [ Button.raised
        , Button.colored
        , Button.disabled |> Options.when (List.all (not << .selected) model.games)
        , Options.onClick (userMsg CreatePoll)
        ]
        [ text "Create poll" ]


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

        CreatePoll ->
            let
                selectedGameIds =
                    model.games |> List.filter .selected |> List.map .id
            in
                ( { model | state = Saving }
                , Task.attempt PollCreated <|
                    Backend.Poll.create appState.environment selectedGameIds
                )

        PollCreated result ->
            case result of
                Ok pollId ->
                    ( model
                    , Route.newUrl (NewPoll pollId)
                    )

                Err error ->
                    ( { model | state = Failed }, Cmd.none )
