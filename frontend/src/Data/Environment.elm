module Data.Environment exposing (Environment(..), fromLocation)

import Navigation


type Environment
    = Localhost
    | Unknown String


fromLocation : Navigation.Location -> Environment
fromLocation location =
    case location.hostname of
        "localhost" ->
            Localhost

        _ ->
            Unknown location.hostname
