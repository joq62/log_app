-module(parse).

-export([
	 read_all/0,
	 read/2,
	 error/1,
	 error/2,
	 critical/1,
	 critical/2
	]).

-define(LogDir,"logs").

read(AllInfo,N)->
    lists:sublist(AllInfo,N).

read_all()->
    {ok,Files}=file:list_dir(?LogDir),
    LogFiles=[{LogFile,filename:join(?LogDir,LogFile)}||LogFile<-Files,
		       ".idx"/=filename:extension(LogFile),
		       ".siz"/=filename:extension(LogFile)],
    AllInfo=lists:append([p(File)||{_,File}<-LogFiles]),
    AllInfo.

p(File)->
    {ok,Bin}=file:read_file(File),       
    L1=string:tokens(binary_to_list(Bin),"\n"),
    L2=[[string:sub_string(Str,1,32),string:sub_string(Str,34,1000)]||Str<-L1],
    L3=[[Time,string:tokens(LevelInfo,":")]||[Time,LevelInfo]<-L2],
    L4=filter1(L3,[]),
    L4.
    


error(AllInfo)->
    [{{time,T},{level,"error"},{info,Info}}||{{time,T},{level,"error"},{info,Info}}<-AllInfo].
error(AllInfo,N)->
    lists:sublist(error(AllInfo),N).
   
  

critical(AllInfo)->
    [{{time,T},{level,"critical"},{info,Info}}||{{time,T},{level,"critical"},{info,Info}}<-AllInfo].
critical(AllInfo,N)->
    lists:sublist(critical(AllInfo),N).
   
   
    
filter1([],R)->
    R;    
filter1([[Time,LevelInfo]|T],Acc) ->
    [Level|Info]=LevelInfo,
    filter1(T,[{{time,Time},{level,Level},{info,Info}}|Acc]).
    
