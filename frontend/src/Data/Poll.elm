module Data.Poll exposing (Poll, PollId)

import Data.Game exposing (GameId)


type alias Poll =
    List GameId


type alias PollId =
    String
