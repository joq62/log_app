%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(log).     
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
-define(SERVER,?MODULE).
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state, {all_info}).



%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

-export([
	 %
	 update/0,
	 read/1,
	 error/0,
	 error/1,
	 critical/0,
	 critical/1
	]).

-export([
	 ping/0,
	 start/0,
	 stop/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%%-----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% Gen server functions
start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).

	 %
read(Num)->
    gen_server:call(?SERVER, {read,Num},infinity).

update()->
    gen_server:call(?SERVER, {update},infinity).
error()->
    gen_server:call(?SERVER, {error},infinity).
error(NumLatest)->
    gen_server:call(?SERVER, {error,NumLatest},infinity).

critical()->
    gen_server:call(?SERVER, {critical},infinity).
critical(N)->
    gen_server:call(?SERVER, {critical,N},infinity).			    

%%---------------------------------------------------------------
-spec ping()-> {atom(),node(),module()}|{atom(),term()}.
%% 
%% @doc:check if service is running
%% @param: non
%% @returns:{pong,node,module}|{badrpc,Reason}
%%
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: 
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
  

    {ok, #state{all_info=[]}}.
    
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------
handle_call({update},_From,State) ->
    AllInfo=parse:read_all(),
    Reply=ok,
    {reply, Reply, State#state{all_info=AllInfo}};

handle_call({read,Num},_From,State) ->
    Reply=case State#state.all_info of
	      []->
		  [];
	      AllInfo->
		  parse:read(AllInfo,Num)
	  end, 
    {reply, Reply, State};

handle_call({error},_From,State) ->
    Reply=case State#state.all_info of
	      []->
		  [];
	      AllInfo->
		  parse:error(AllInfo)
	  end, 
    {reply, Reply, State};

handle_call({error,Num},_From,State) ->
    Reply=case State#state.all_info of
	      []->
		  [];
	      AllInfo->
		  parse:error(AllInfo,Num)
	  end, 
    {reply, Reply, State};

handle_call({critical},_From,State) ->
    Reply=case State#state.all_info of
	      []->
		  [];
	      AllInfo->
		  parse:critical(AllInfo)
	  end, 
    {reply, Reply, State};

handle_call({critical,Num},_From,State) ->
    Reply=case State#state.all_info of
	      []->
		  [];
	      AllInfo->
		  parse:critical(AllInfo,Num)
	  end, 
    {reply, Reply, State};


handle_call({ping},_From,State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call({stop}, _From, State) ->    
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% -------------------------------------------------------------------
    
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info({Pid,divi,[A,B]}, State) ->
    Pid!{self(),A/B},
    {noreply, State};

handle_info({stop}, State) ->
    io:format("stop ~p~n",[{?MODULE,?LINE}]),
    exit(self(),normal),
    {noreply, State};

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
