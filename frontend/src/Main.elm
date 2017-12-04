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
import Page.Home
import Page.User
import Page.Poll
import Page.NewPoll
import Page.AnswerPoll
import Data.Environment


type alias Model =
    { appState : AppState
    , pageState : PageState
    }


type PageState
    = Loaded Page
    | TransitioningFrom Page


type Page
    = Blank
    | Home Page.Home.Model
    | User Page.User.Model
    | Poll Page.Poll.Model
    | NewPoll Page.NewPoll.Model
    | AnswerPoll Page.AnswerPoll.Model
    | Error String


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
                Home subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.Home.update subMsg model.appState subModel
                    in
                        ( { model | pageState = Loaded (Home newModel) }
                        , Cmd.map HomeMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.UserMsg subMsg ->
            case getPage model.pageState of
                User subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.User.update subMsg model.appState subModel
                    in
                        ( { model | pageState = Loaded (User newModel) }
                        , Cmd.map UserMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.NewPollMsg subMsg ->
            case getPage model.pageState of
                NewPoll subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.NewPoll.update subMsg subModel
                    in
                        ( { model | pageState = Loaded (NewPoll newModel) }
                        , Cmd.map NewPollMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.AnswerPollMsg subMsg ->
            case getPage model.pageState of
                AnswerPoll subModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.AnswerPoll.update subMsg model.appState subModel
                    in
                        ( { model | pageState = Loaded (AnswerPoll newModel) }
                        , Cmd.map AnswerPollMsg newCmd
                        )

                _ ->
                    -- Disregard messages when on other pages
                    ( model, Cmd.none )

        Messages.UserPageLoaded result ->
            case result of
                Ok subModel ->
                    ( { model | pageState = Loaded (User subModel) }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | pageState = Loaded (Error "Unable to load user info") }
                    , Cmd.none
                    )

        Messages.AnswerPollPageLoaded result ->
            case result of
                Ok subModel ->
                    ( { model | pageState = Loaded (AnswerPoll subModel) }
                    , Cmd.none
                    )

                Err error ->
                    let
                        _ =
                            Debug.log "ERR" error
                    in
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
        transition toMsg task =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }
            , Task.attempt toMsg task
            )
    in
        case route of
            Route.Home ->
                ( { model | pageState = Loaded (Home Page.Home.init) }
                , Cmd.none
                )

            Route.PollAnswers pollId ->
                ( { model | pageState = Loaded (Poll <| Page.Poll.init pollId) }
                , Cmd.none
                )

            Route.PollNew pollId ->
                ( { model | pageState = Loaded (NewPoll <| Page.NewPoll.init pollId) }
                , Cmd.none
                )

            Route.PollVote pollId ->
                -- ( { model | pageState = Loaded (AnswerPoll <| Page.AnswerPoll.init pollId) }
                -- , Cmd.none
                -- )
                transition AnswerPollPageLoaded (Page.AnswerPoll.init model.appState pollId)

            Route.User name ->
                transition UserPageLoaded (Page.User.init model.appState name)

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

        Loaded (Home homeModel) ->
            Page.Home.view homeModel model.appState HomeMsg Mdl
                |> Views.frame model.appState

        Loaded (NewPoll newPollModel) ->
            Page.NewPoll.view newPollModel model.appState NewPollMsg Mdl
                |> Views.frame model.appState

        Loaded (AnswerPoll newPollModel) ->
            Page.AnswerPoll.view newPollModel model.appState AnswerPollMsg Mdl
                |> Views.frame model.appState

        Loaded (Poll pollModel) ->
            Page.Poll.view pollModel model.appState Mdl
                |> Views.frame model.appState

        Loaded (User userModel) ->
            Page.User.view userModel model.appState UserMsg Mdl
                |> Views.frame model.appState


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
