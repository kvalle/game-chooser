module Data.AppState exposing (AppState)

import Material
import Data.Environment exposing (Environment)


type alias AppState =
    { mdl : Material.Model
    , environment : Environment
    }
