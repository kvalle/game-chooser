module Route
    exposing
        ( Route(..)
        , fromLocation
        , modifyUrl
        , newUrl
        )

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, top, oneOf, parseHash, s, string)


-- ROUTING --


type Route
    = Start
    | User String
    | PollNew String
    | PollVote String
    | PollAnswers String
    | Unknown


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Start top
        , Url.map User (s "user" </> string)
        , Url.map PollNew (s "poll" </> string </> s "new")
        , Url.map PollAnswers (s "poll" </> string </> s "answers")
        , Url.map PollVote (s "poll" </> string)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Start ->
                    []

                User username ->
                    [ "user", username ]

                PollNew pollId ->
                    [ "poll", pollId, "new" ]

                PollAnswers pollId ->
                    [ "poll", pollId, "answers" ]

                PollVote pollId ->
                    [ "poll", pollId ]

                Unknown ->
                    []
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


newUrl : Route -> Cmd msg
newUrl =
    routeToString >> Navigation.newUrl


fromLocation : Location -> Route
fromLocation location =
    let
        _ =
            Debug.log "Location changed: " location
    in
        if String.isEmpty location.hash then
            Start
        else
            parseHash route location |> Maybe.withDefault Unknown
