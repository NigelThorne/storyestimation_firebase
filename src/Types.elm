module Types exposing (..)

import Room.Types
import Firebase.Auth as Firebase
import Firebase.Common as Firebase
import RemoteData exposing (..)


type Msg
    = Authenticate
    | AuthResponse (RemoteData Firebase.Error Firebase.User)
    | RoomMsg Room.Types.Msg


type alias Model =
    { firebase : Firebase.AuthData
    , room : Maybe Room.Types.Model
    }
