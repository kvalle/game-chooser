module Route
    exposing
        ( Route(..)
        , fromLocation
        , modifyUrl
        , newUrl
        )

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, top, oneOf, parseHash, s, string, int)


-- ROUTING --


type Route
    = Home
    | User String
    | NewPoll String
    | AnswerPoll String
    | Poll String
    | Unknown


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home top
        , Url.map User (s "u" </> string)
        , Url.map NewPoll (s "poll" </> string </> s "new")
        , Url.map AnswerPoll (s "poll" </> string </> s "answer")
        , Url.map Poll (s "poll" </> string)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                User username ->
                    [ "u", username ]

                NewPoll pollId ->
                    [ "poll", pollId, "new" ]

                AnswerPoll pollId ->
                    [ "poll", pollId, "answer" ]

                Poll pollId ->
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
            Home
        else
            parseHash route location |> Maybe.withDefault Unknown
