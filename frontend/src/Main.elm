module Main exposing (..)

import Html
import Messages exposing (Msg(..))
import Material
import Navigation
import Route exposing (Route(..))
import Data.AppState exposing (AppState)
import Task
import Html exposing (..)
import Views
import Page exposing (Page(..))
import Page.Home
import Page.User
import Page.PollNew
import Page.PollVote
import Page.PollAnswers
import Data.Environment


type alias Model =
    { appState : AppState
    , pageState : PageState
    }


type PageState
    = Loaded Page
    | TransitioningFrom Page


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { view = view
        , init = init
        , update = update
        , subscriptions = .appState >> Material.subscriptions Mdl
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( model, cmd ) =
            updateWithRoute (Route.fromLocation location)
                { pageState = Loaded Blank
                , appState =
                    { mdl = Material.model
                    , environment = Data.Environment.fromLocation location
                    , hostname = location.host
                    }
                }
    in
        ( model, Cmd.batch [ cmd, Material.init Mdl ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Mdl mdlMsg ->
            let
                ( appState, cmd ) =
                    Material.update Mdl mdlMsg model.appState
            in
                ( { model | appState = appState }, cmd )

        SetRoute route ->
            updateWithRoute route model

        Messages.HomeMsg subMsg ->
            case getPage model.pageState of
                Page.Home subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.Home.update subMsg model.appState subModel
                    in
                        ( { model | pageState = Loaded (Page.Home newModel) }
                        , Cmd.map HomeMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.UserMsg subMsg ->
            case getPage model.pageState of
                Page.User subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.User.update subMsg model.appState subModel
                    in
                        ( { model | pageState = Loaded (Page.User newModel) }
                        , Cmd.map UserMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.PollNewMsg subMsg ->
            case getPage model.pageState of
                Page.PollNew subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.PollNew.update subMsg subModel
                    in
                        ( { model | pageState = Loaded (Page.PollNew newModel) }
                        , Cmd.map PollNewMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.PollVoteMsg subMsg ->
            case getPage model.pageState of
                Page.PollVote subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.PollVote.update subMsg model.appState subModel
                    in
                        ( { model | pageState = Loaded (Page.PollVote newModel) }
                        , Cmd.map PollVoteMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.PageLoaded (Ok page) ->
            ( { model | pageState = Loaded page }
            , Cmd.none
            )

        Messages.PageLoaded (Err error) ->
            ( { model | pageState = Loaded (Error "Failed to load poll") }
            , Cmd.none
            )


{-| Helper function for update. Given a Route and a Model, either load the right
page directly, or set transition state and initialise loading of data for the
new page.
-}
updateWithRoute : Route -> Model -> ( Model, Cmd Msg )
updateWithRoute route model =
    let
        transition page initTask =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }
            , initTask
                |> Task.map page
                |> Task.attempt PageLoaded
            )
    in
        case route of
            Route.Home ->
                ( { model | pageState = Loaded (Page.Home Page.Home.init) }
                , Cmd.none
                )

            Route.PollAnswers pollId ->
                transition Page.PollAnswers <| Page.PollAnswers.init model.appState pollId

            Route.PollNew pollId ->
                ( { model | pageState = Loaded (Page.PollNew <| Page.PollNew.init pollId) }
                , Cmd.none
                )

            Route.PollVote pollId ->
                transition Page.PollVote <| Page.PollVote.init model.appState pollId

            Route.User name ->
                transition Page.User <| Page.User.init model.appState name

            Route.Unknown ->
                ( { model | pageState = Loaded (Error "404") }
                , Cmd.none
                )


view : Model -> Html Msg
view model =
    case model.pageState of
        TransitioningFrom page ->
            Views.loading
                |> Views.frame model.appState

        Loaded Blank ->
            Html.text ""
                |> Views.frame model.appState

        Loaded (Error error) ->
            Html.text error
                |> Views.frame model.appState

        Loaded (Page.Home homeModel) ->
            Page.Home.view homeModel model.appState HomeMsg Mdl
                |> Views.frame model.appState

        Loaded (Page.PollNew newPollModel) ->
            Page.PollNew.view newPollModel model.appState PollNewMsg Mdl
                |> Views.frame model.appState

        Loaded (Page.PollVote newPollModel) ->
            Page.PollVote.view newPollModel model.appState PollVoteMsg Mdl
                |> Views.frame model.appState

        Loaded (Page.PollAnswers pollModel) ->
            Page.PollAnswers.view pollModel model.appState Mdl
                |> Views.frame model.appState

        Loaded (Page.User userModel) ->
            Page.User.view userModel model.appState UserMsg Mdl
                |> Views.frame model.appState


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
