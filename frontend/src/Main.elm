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
import Page.User


type alias Model =
    { appState : AppState
    , pageState : PageState
    }


type PageState
    = Loaded Page
    | TransitioningFrom Page


type Page
    = Blank
    | Home
    | User Page.User.Model
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
                , appState = { mdl = Material.model }
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

        Messages.UserMsg userMsg ->
            case getPage model.pageState of
                User userModel ->
                    let
                        ( newModel, newCmd ) =
                            Page.User.update userMsg model.appState userModel
                    in
                        ( { model | pageState = Loaded (User newModel) }
                        , Cmd.map UserMsg newCmd
                        )

                _ ->
                    -- Disregard user messages when on other pages
                    ( model, Cmd.none )

        Messages.UserPageLoaded result ->
            case result of
                Ok subModel ->
                    ( { model | pageState = Loaded (User subModel) }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | pageState = Loaded (Error error) }
                    , Cmd.none
                    )


updateWithRoute : Route -> Model -> ( Model, Cmd Msg )
updateWithRoute route model =
    let
        transition toMsg task =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }
            , Task.attempt toMsg task
            )

        pageErrored : String -> Model -> Model
        pageErrored errorMessage model =
            { model | pageState = Loaded (Error errorMessage) }
    in
        case route of
            Route.Home ->
                ( { model | pageState = Loaded Home }
                , Cmd.none
                )

            Route.User name ->
                transition UserPageLoaded (Page.User.init name)

            Route.Unknown ->
                ( { model | pageState = Loaded (Error "404") }
                , Cmd.none
                )


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage model.appState page

        TransitioningFrom page ->
            Views.loading |> Views.frame model.appState


viewPage : AppState -> Page -> Html Msg
viewPage appState page =
    case page of
        Blank ->
            Html.text "" |> Views.frame appState

        Error error ->
            Html.text error |> Views.frame appState

        Home ->
            Html.text "home page" |> Views.frame appState

        User userModel ->
            Page.User.view userModel
                |> Html.map UserMsg
                |> Views.frame appState


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
