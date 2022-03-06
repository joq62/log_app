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
-module(basic_eunit).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/logger.hrl").
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=application:start(log_app),
    ok=t1_test(),
    ok=t2_test(),
    
    ok=t22_test(),
%   ok=test3(),
 %   ok=test4(),
    init:stop(),
    ok.


setup_test()->
 %   {ok,[Config]}=file:consult("config/sys.config"),
 %   gl=Config,
    ok=application:start(log_app),
       
    ok.

t1_test()->
    ok=test1(),
    ok.
t2_test()->
    ok=test2(),
  
    timer:sleep(1000),
    ok.

t22_test()->
    timer:sleep(1000),
    log:update(),
    io:format("log:read(3) ~p~n",[{log:read(3),?MODULE,?FUNCTION_NAME,?LINE}]),
    io:format("log:error(3) ~p~n",[{log:error(3),?MODULE,?FUNCTION_NAME,?LINE}]),
    io:format("log:critical(3) ~p~n",[{log:critical(3),?MODULE,?FUNCTION_NAME,?LINE}]),
    ok.

t3_test()->
   % ok=test3(),
    ok.
t4_test()->
    ok=test4(),
    ok.

stop_test()->
   % init:stop(),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
test4()->
    AllInfo=parse:read_all(),
    gl=io:format("~p~n",[AllInfo]),
    Error=parse:error(AllInfo,7),
    gl=io:format("~p~n",[Error]),
    print(Error),
    ok.

print([])->
    ok;
print([Info|T]) ->
    ?debugFmt("~p~n", [Info]),
   % io:format("~p~n",[Info]),
    print(T).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
test1()->
 %   [Vm1|_]=test_nodes:get_nodes(),
    rpc:call(node(),logger,log,[info,"info1"],5000),
    rpc:call(node(),logger,log,[error,"error1"],5000),
    ?LOG_EMERGENCY(#{name=>"joq62"}),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
-define(Log(Vm,Level,What,Result,Reason),log(Vm,Level,?MODULE,?FUNCTION_NAME,?LINE,What,Result,Reason,node(),pid_to_list(self()))).
test2()->
    
    
  %  [Vm1|_]=test_nodes:get_nodes(),
    ok=log(node(),alert,?MODULE,?FUNCTION_NAME,?LINE,"what 1","error 1","reason 1",node(),pid_to_list(self())),
    ok=?Log(node(),critical,"what 2","error 2","reason 2"),
    loop(1*5),
    %pc:cast(node(),erlang,apply,[m,f,[]]),

  %  rpc:call(Vm1,logger,log,[alert,#{when=>xx,level=>alert, }],5000),
   % rpc:call(Vm1,logger,log,[error,"error1"],5000),
   
    ok.

log(Vm,Level,Module,Function,Line,What,Result,Reason,Node,User)->
    
    Id=integer_to_list(os:system_time(microsecond),36),
   % Level1=atom_to_list(Level),
    Module1=atom_to_list(Module),
    Function1=atom_to_list(Function),
    Line1=integer_to_list(Line),
    
    Node1=atom_to_list(Node),
  %  Msg=#{id=>Id,node=>Node1,at=>Module1++":"++Function1++":"++Line1,what=>What,result=>Result,reason=>Reason,user=>User},
    Msg=#{id=>Id,node=>Node1,where=>Module1++":"++Function1++"/"++Line1,what=>What,result=>Result,reason=>Reason,user=>User},
   
    rpc:call(node(),logger,log,[Level,Msg],5000),
    ok.
    
loop(0)->
    ok;
loop(N) ->
    ok=log(node(),alert,?MODULE,?FUNCTION_NAME,?LINE,"what 1","alert ",integer_to_list(N),node(),pid_to_list(self())),
    ok=log(node(),error,?MODULE,?FUNCTION_NAME,?LINE,"what 1","error ",integer_to_list(N),node(),pid_to_list(self())),
    ok=log(node(),critical,?MODULE,?FUNCTION_NAME,?LINE,"what 1","critical ",integer_to_list(N),node(),pid_to_list(self())),
    loop(N-1).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

test3()->
    timer:sleep(2000),
    {ok,Bin}=file:read_file("logs/error.1"),       
    L1=string:tokens(binary_to_list(Bin),"\n"),
    %gl=io:format("L1 ~p~n",[{L1,?MODULE,?FUNCTION_NAME,?LINE}]),
    L2=[[string:sub_string(Str,1,32),string:sub_string(Str,34,1000)]||Str<-L1],
   % gl=io:format("L2 ~p~n",[{L2,?MODULE,?FUNCTION_NAME,?LINE}]),
    L3=[[Time,string:tokens(LevelInfo,":")]||[Time,LevelInfo]<-L2],
    io:format("L3 ~p~n",[{L3,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    L4=filter1(L3,[]),
    io:format("L4 ~p~n",[{L4,?MODULE,?FUNCTION_NAME,?LINE}]),
    Error= [[{time,T},{level,"error"},{info,Info}]||[{time,T},{level,"error"},{info,Info}]<-L4],
    io:format("error ~p~n",[{Error,?MODULE,?FUNCTION_NAME,?LINE}]),

    Critical= [[{time,T},{level,"critical"},{info,Info}]||[{time,T},{level,"critical"},{info,Info}]<-L4],
    io:format("Critical ~p~n",[{Critical,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    
    ok.


filter1([],R)->
    R;    
filter1([[Time,LevelInfo]|T],Acc) ->
    [Level|Info]=LevelInfo,
    filter1(T,[[{time,Time},{level,Level},{info,Info}]|Acc]).
    
setup()->
  
    % Simulate host
    R=rpc:call(node(),test_nodes,start_nodes,[],2000),
%    [Vm1|_]=test_nodes:get_nodes(),

%    Ebin="ebin",
 %   true=rpc:call(Vm1,code,add_path,[Ebin],5000),
 
    R.
