port module Room.Ports exposing (..)

import Room.Types exposing (..)
import Firebase.Auth exposing (..)
import Firebase.Common exposing (..)


port room : (String -> msg) -> Sub msg

port roomError : (Error -> msg) -> Sub msg

port roomListen : () -> Cmd msg

port roomSilence : () -> Cmd msg

------------------------------------------------------------

port decks : (String -> msg) -> Sub msg

port decksListen : () -> Cmd msg

port decksSilence : () -> Cmd msg

port decksError : (Error -> msg) -> Sub msg

------------------------------------------------------------

port voteSend : ( UID, Vote ) -> Cmd msg

port voteSendError : (Error -> msg) -> Sub msg

------------------------------------------------------------

port nameSend : ( UID, Name ) -> Cmd msg

port nameSendError : (Error -> msg) -> Sub msg

------------------------------------------------------------

port topicSend : ( Topic ) -> Cmd msg

------------------------------------------------------------

port votingCompleteSend : ( Bool ) -> Cmd msg

port votingCompleteSendError : (Error -> msg) -> Sub msg

------------------------------------------------------------

port cardSend : ( UID, Card ) -> Cmd msg

port cardSendError : (Error -> msg) -> Sub msg
