module Room.State exposing (..)

-- import Dict
import Room.Ports exposing (..)
import Room.Rest exposing (..)
import Room.Types exposing (..)
import RemoteData as RemoteData exposing (..)
import Firebase.Auth exposing (User)
import Json.Decode as Decode


initialVote : Vote
initialVote =
    Nothing


initialName : Name
initialName =
    "Anonymous"


initialTopic : Topic
initialTopic =
    "Pick a Topic..."


--initialRoom : Name -> Room
--initialRoom name =
--    { name = name
--    , topic = Just "Unknown Topic"
--    , votes = Dict.empty
--    , voters = Dict.empty
--    , showVotes = False
--    , deckId = Nothing
--    }

initialState : ( Model, Cmd Msg )
initialState =
    ( { room = Loading
      , decks = Loading
      , error = Nothing
      }
    , onInitialize ()
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ handleRoom (Decode.decodeString decodeRoom >> HeardRoom)
        , handleDecks (Decode.decodeString decodeDecks >> HeardDecks)
        , handleError Error
        ]


update : User -> Msg -> Model -> ( Model, Cmd Msg )
update user msg model =
    case msg of
        Error err ->
            ( { model | error = Just err }
            , Cmd.none
            )

        HeardRoom response ->
            ( { model | room = RemoteData.fromResult response }
            , Cmd.none
            )

        HeardDecks response ->
            ( { model | decks = RemoteData.fromResult response }
            , Cmd.none
            )

        VoteFor card ->
            case model.room of
                Success room ->
                    ( model
                    , voteSend ( user.uid, card )
                    )

                _ ->
                    ( model, Cmd.none )

        ChangeName name ->
            case model.room of
                Success room ->
                    ( model
                    , nameSend ( user.uid, name )
                    )

                _ ->
                    ( model, Cmd.none )

        ChangeDeck deckId ->
            case model.decks of
                Success decks ->
                    ( model
                    , deckSend ( user.uid, deckId )
                    )

                _ ->
                    ( model, Cmd.none )

        RevealResults isRevealed ->
            case model.room of
                Success room ->
                    ( model
                    , votingCompleteSend (isRevealed)
                    )

                _ ->
                    ( model, Cmd.none )

        ChangeTopic topic ->
            case model.room of
                Success room ->
                    ( model
                    , topicSend topic
                    )

                _ ->
                    ( model, Cmd.none )
