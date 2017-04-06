port module Room.Ports exposing (..)

import Room.Types exposing (..)
import Firebase.Auth exposing (..)
import Firebase.Common exposing (..)


port handleRoom : (String -> msg) -> Sub msg
port handleDecks : (String -> msg) -> Sub msg
port handleError : (Error -> msg) -> Sub msg

port onInitialize : () -> Cmd msg
port onFinalize : () -> Cmd msg

port voteSend : ( UID, Vote ) -> Cmd msg
port nameSend : ( UID, Name ) -> Cmd msg
port deckSend : ( UID, Int ) -> Cmd msg
port cardSend : ( UID, Card ) -> Cmd msg

port topicSend : Topic -> Cmd msg
port votingCompleteSend : Bool -> Cmd msg

