all:
	rm -rf  *~ */*~  src/*.beam test/*.beam erl_cra*;
	rm -rf  catalog host_specs deployment_specs;
	rm -rf _build;
	rm -rf ebin;
	mkdir ebin;
	rebar3 compile;
	cp -r _build/default/lib/*/ebin/* ebin;	
	rm -rf _build;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -pa ebin -sname test -run basic_eunit start -setcookie test_cookie -config config/sys;
	rm -rf  catalog host_specs deployment_specs logs;	
	echo Done
check:
	rebar3 check

eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin/* erl_cra*;
	rm -rf _build;
	rm -rf ebin;
	mkdir ebin;
	rebar3 compile;
	cp -r _build/default/lib/*/ebin/* ebin;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -pa ebin -sname test -run basic_eunit start -setcookie test_cookie -config config/sys
release:
	rm -rf  *~ */*~  test_ebin/* erl_cra*;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -run release start config_app ../catalog/catalog.specs
