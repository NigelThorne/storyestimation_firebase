port module Firebase.Auth
    exposing
        ( authenticate
        , authResponse
        , Email
        , UID
        , User
        , AuthData
        )

import Exts.Maybe exposing (..)
import RemoteData exposing (..)
import Firebase.Common exposing (..)


type alias Email =
    String


type alias UID =
    String


type alias User =
    { uid : UID
    , email : Maybe Email
    , photoURL : Maybe String
    , emailVerified : Bool
    , displayName : Maybe String
    , isAnonymous : Bool
    }


type alias AuthData =
    RemoteData Error User


port authenticate : () -> Cmd msg


port authError : (Error -> msg) -> Sub msg


port authStateChanged : (Maybe User -> msg) -> Sub msg


authResponse : Sub AuthData
authResponse =
    Sub.batch
        [ authError Failure
        , authStateChanged (maybe NotAsked Success)
        ]
