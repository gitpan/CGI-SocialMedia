#!perl -Tw

use strict;
use warnings;
use Test::More tests => 9;
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

	$ENV{'HTTP_ACCEPT_LANGUAGE'} = 'fr';
	$sm = new_ok('CGI::SocialMedia' => []);
	ok(defined($sm->as_string(facebook_like_button => 1)));
}
