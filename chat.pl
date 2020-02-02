
:- module(chat_server,
	  [ server/0,
	    server/1				% ?Port
	   
	  ]).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/websocket)).
:- use_module(library(http/html_write)).
:- use_module(library(http/js_write)).
:- use_module(library(http/hub)).
:- use_module(library(debug)).



server :-
	server(3050).

server(Port) :-
	(   debugging(chat),
	    current_prolog_flag(gui, true)
	->  prolog_ide(thread_monitor)
	;   true
	),
	http_server(http_dispatch, [port(Port)]).



:- http_handler(root(.),    chat_page,      []).
:- http_handler(root(chat),
		http_upgrade_to_websocket(
		    accept_chat,
		    [ guarded(false),
		      subprotocols([chat])
		    ]),
		[ id(chat_websocket)
		]).

chat_page(_Request) :-
	reply_html_page(
	    title('Expert Web System'),
	    \chat_page).



chat_page -->
	style,
	html([ h1('Expert Web System...'),
	       div([ id(chat)
		   ], []),
	       input([ placeholder('Type a message and hit RETURN'),
		       id(input),
		       onkeypress('handleInput(event)')
		     ], [])
	     ]),
	script.


style -->
	html(style([ 'body,html { height:100%; overflow: hidden; }\n',
		     '#chat { height: calc(100% - 450px); overflow-y:scroll; \c
			      border: solid 1px black; padding:5px; }\n',
		     '#input { width:100%; border:solid 1px black; \c
			       padding: 5px; box-sizing: border-box; }\n'
		   ])).


script -->
	{ http_link_to_id(chat_websocket, [], WebSocketURL)
	},
	js_script({|javascript(WebSocketURL)||
function handleInput(e) {
  if ( !e ) e = window.event;  // IE
  if ( e.keyCode == 13 ) {
    var msg = document.getElementById("input").value;
    sendChat(msg);
    document.getElementById("input").value = "";
  }
}

var connection;

function openWebSocket() {
  connection = new WebSocket("ws://"+window.location.host+WebSocketURL,
			     ['chat']);

  connection.onerror = function (error) {
    console.log('WebSocket Error ' + error);
  };

  connection.onmessage = function (e) {
    var chat = document.getElementById("chat");
    var msg = document.createElement("div");
    msg.appendChild(document.createTextNode(e.data));
    var child = chat.appendChild(msg);
    child.scrollIntoView(false);
  };
}

function sendChat(msg) {
  connection.send(msg);
}

window.addEventListener("DOMContentLoaded", openWebSocket, false);
		  |}).

work_at("hello", "Friday").

accept_chat(WebSocket) :-
	 ws_receive(WebSocket, Message),
    (   Message.opcode == close
    ->  true
    ;   work_at(Message.data, Time),
        ws_send(WebSocket, text(Time)),
        accept_chat(WebSocket)
    ).

