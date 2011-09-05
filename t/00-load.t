#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CGI::SocialMedia' ) || print "Bail out!
";
}

diag( "Testing CGI::SocialMedia $CGI::SocialMedia::VERSION, Perl $], $^X" );
