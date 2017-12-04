module Page.NewPoll
    exposing
        ( Model
        , Msg(..)
        , view
        , init
        , update
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Poll exposing (PollId)
import Material
import Material.Options as Options
import Material.Button as Button
import Route exposing (Route(..))
import Data.AppState exposing (AppState)


type Msg
    = GoToPollAnswers PollId
    | GoToPollVoting PollId


type alias Model =
    PollId


init : PollId -> Model
init pollId =
    pollId


view : Model -> AppState -> (Msg -> msg) -> (Material.Msg msg -> msg) -> Html msg
view model appState newPollMsg mdlMsg =
    let
        relativeUrl =
            "#/poll/" ++ model ++ "/answer"
    in
        div [ class "new-poll-wrapper" ]
            [ h3 [] [ text <| "Poll created!" ]
            , span [] [ text "Send this link to your friends: " ]
            , a
                [ class "new-poll-link"
                , href relativeUrl
                ]
                [ text <| appState.hostname ++ relativeUrl ]
            , Button.render mdlMsg
                [ 0 ]
                appState.mdl
                [ Button.raised
                , Options.cs "go-to-poll"
                , Options.onClick <| newPollMsg (GoToPollAnswers model)
                ]
                [ text "Go to poll" ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToPollAnswers pollId ->
            ( model, Route.newUrl <| PollAnswers pollId )

        GoToPollVoting pollId ->
            ( model, Route.newUrl <| PollVote pollId )
