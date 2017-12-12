module Data.Environment exposing (Environment(..), fromLocation)

import Navigation


type Environment
    = Localhost
    | Test
    | Prod
    | Unknown String


fromLocation : Navigation.Location -> Environment
fromLocation location =
    case location.hostname of
        "localhost" ->
            Localhost

        "test.game.kjetilvalle.com" ->
            Test

        "game.kjetilvalle.com" ->
            Prod

        _ ->
            Unknown location.hostname
