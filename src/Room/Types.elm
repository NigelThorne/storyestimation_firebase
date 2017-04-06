module Room.Types exposing (..)

import Dict exposing (Dict)
import RemoteData exposing (..)
import Firebase.Common as Firebase


type alias Card =
    String

type alias Name =
    String

type alias Topic =
    String

type alias UserId =
    String

type alias Vote =
    Maybe Card

type alias Deck =
    List Card

type alias Decks =
    List Deck

type alias Room =
    { name : Maybe Name
    , topic : Maybe Topic
    , votes : Dict UserId Vote
    , voters : Dict UserId Name
    , showVotes : Bool
    , deckId : Maybe Int
    }


type alias Model =
    { room : RemoteData String Room
    , decks : RemoteData String Decks
    , error : Maybe Firebase.Error
    }


type Msg
    = HeardRoom (Result String Room)
    | HeardDecks (Result String Decks)
    | ChangeName Name
    | ChangeTopic Topic
    | ChangeDeck Int
    | RevealResults Bool
    | VoteFor Vote
    | Error Firebase.Error
