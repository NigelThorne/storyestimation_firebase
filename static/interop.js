/*global Elm, firebase, firebaseConfig */

function subscribeToFirebasePath(path, onValue, onError){
    console.log('LISTENING to ', path.toString());
    path.on(
        'value',
        function(snapshot) {
            onValue.send( JSON.stringify( snapshot.val() ) );
        },
        onError.send
    );
}

function setFirebaseValue(path, value, app){
    path.set(value).catch(app.ports.handleError.send);
}


(function () {
    // Start the Elm App.
    var app = Elm.App.fullscreen();

    // Initialize Firebase
    var firebaseApp = firebase.initializeApp(firebaseConfig);

    // Firebase Auth.
    app.ports.authenticate.subscribe(function () {
        console.log("Authenticating");
        firebase.auth().signInAnonymously()
            .catch(app.ports.authError.send);
    });


    firebaseApp.auth()
        .onAuthStateChanged(app.ports.authStateChanged.send);


    var GetRoomName = function(str){
        if(str.startsWith("/rooms/")){
            return str.substr(7);
        };
        return null;
    }

    // setTimeout(function() {
    // }, 1);

    var database = firebase.database();
    var decksPath = database.ref('/decks');


    function subscribeToDecks(decksPath, app){
        subscribeToFirebasePath(decksPath, app.ports.handleDecks, app.ports.handleError);
    }

    function subscribeToRooms(roomPath, app){
        subscribeToFirebasePath(roomPath, app.ports.handleRoom, app.ports.handleError);
    }

    var roomname = GetRoomName(window.location.pathname); 

    if(roomname!=null)
    {
        var roomPath = database.ref('/rooms/'+ roomname);
        var showVotesPath = roomPath.child('showVotes');
        var votePath = roomPath.child('votes');
        var namePath = roomPath.child('voters');

        app.ports.onInitialize.subscribe( function () {
            subscribeToDecks(decksPath, app);
            subscribeToRooms(roomPath, app);
        });

        app.ports.onFinalize.subscribe( function () {
            console.log('SILENCING', roomPath.toString());
            roomPath.off('value');
            decksPath.off('value');
        });

        app.ports.votingCompleteSend.subscribe( function (show) {
            setFirebaseValue(showVotesPath, show, app);
        });

        app.ports.topicSend.subscribe( function (msg) {
            var topic = msg,
                path = roomPath.child('topic');

            setFirebaseValue(votePath, null, app);
            setFirebaseValue(path, topic, app);
        });

        app.ports.voteSend.subscribe( function (msg) {
            var uid = msg[0],
                vote = msg[1],
                path = votePath.child(uid);

            setFirebaseValue(showVotesPath, false, app);
            setFirebaseValue(path, vote, app);
        });

        app.ports.nameSend.subscribe( function (msg) {
            var uid = msg[0],
                name = msg[1],
                path = namePath.child(uid);

            setFirebaseValue(path, name, app);
        });

        app.ports.deckSend.subscribe( function (msg) {
            var uid = msg[0],
                deckId = msg[1],
                path = roomPath.child('deckId');
            
            setFirebaseValue(path, deckId, app);
        });
    }
}());
