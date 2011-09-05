#!perl -Tw

use strict;
use warnings;
use Test::More tests => 10;
use Test::NoWarnings;

BEGIN {
	use_ok('CGI::SocialMedia');
}

ROBOT: {
	my $sm = new_ok('CGI::SocialMedia');
	ok(!defined($sm->as_string()));

	$sm = new_ok('CGI::SocialMedia' => [ twitter => 'example' ]);
	ok(!defined($sm->as_string()));
	ok(defined($sm->as_string(twitter_follow_button => 1)));

	$ENV{'REQUEST_METHOD'} = 'GET';
	$ENV{'HTTP_ACCEPT_LANGUAGE'} = 'fr-FR';
	$ENV{'HTTP_USER_AGENT'} = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; fr-FR; rv:1.9.2.19) Gecko/20110707 Firefox/3.6.19';
	$sm = new_ok('CGI::SocialMedia' => []);
	ok(defined($sm->as_string(facebook_like_button => 1)));
	ok($sm->as_string(facebook_like_button => 1) =~ /fr_FR/);
}
