all:
	rm -rf  *~ */*~  src/*.beam test/*.beam erl_cra*;
	rm -rf  catalog host_specs deployment_specs logs;
	rm -rf _build test_ebin;
	mkdir test_ebin;	
	rebar3 compile;	
	rm -rf _build test_ebin logs;
	echo Done
check:
	rebar3 check

eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs;
	rm -rf ebin;
	mkdir test_ebin;	
	rebar3 compile;
	erlc -o test_ebin test/*.erl;
	erl -pa _build/default/lib/*/ebin -pa test_ebin -sname test -run basic_eunit start -setcookie test_cookie -config config/sys
release:
	rm -rf  *~ */*~  test_ebin/* erl_cra*;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -run release start config_app ../catalog/catalog.specs
