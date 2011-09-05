package CGI::SocialMedia;

use warnings;
use strict;
use CGI::Lingua;
use I18N::LangTags::Detect;

=head1 NAME

CGI::SocialMedia - Put social media links into your website

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

Many websites these days have links and buttons into social media sites.
This module eases their addition into Twitter, Facebook and Google's PlusOne.

    use CGI::SocialMedia;

    my $sm = CGI::SocialMedia->new();
    # ...

=head1 SUBROUTINES/METHODS

=head2 new

Creates a CGI::SocialMedia object.

    use CGI::SocialMedia;

    my $sm = CGI::SocialMedia->new(twitter => 'example');
    # ...

=head3 Optional parameters

twitter: twitter account name

=cut

sub new {
	my ($class, %params) = @_;

	my $lingua;
	if($params{twitter}) {
		# Languages supported by Twitter according to
		# https://twitter.com/about/resources/tweetbutton
		$lingua = CGI::Lingua->new(supported => ['en', 'nl', 'fr', 'de', 'id', 'il', 'ja', 'ko', 'pt', 'ru', 'es', 'tr']),
	} else {
		# Facebook supports just about everything
		my @l = I18N::LangTags::Detect::detect();
		if(@l) {
			my $lang = $l[0];
			$lang =~ s/-/_/;
			$lingua = CGI::Lingua->new(supported => [$lang]);
		}
		unless($lingua) {
			$lingua = CGI::Lingua->new(supported => []);
		}
	}

	my $self = {
		_lingua => $lingua,
		_twitter => $params{twitter},
	};
	bless $self, $class;

	return $self;
}

=head2 as_string

Returns the HTML to be added to your website.

	my $sm = CGI::SocialMedia->new(twitter => 'mytwittername');

	print $sm->as_string(twitter_follow_button => 1, google_plusone => 1);

=head3 Optional parameters

twitter_follow_button: add a button to follow the account
twitter_tweet_button: add a button to tweet this page
facebook_like_button: add a Facebook like button
google_plusone: add a Google +1 button

=cut

sub as_string {
	my ($self, %params) = @_;

	my $alpha2;
	my $locale = $self->{_lingua}->locale();
	if($locale) {
		my @l = $locale->languages_official();
		$alpha2 = lc($l[0]->code_alpha2()) . '_' . uc($locale->code_alpha2());
	} else {
		$alpha2 = 'en_GB';
	}

	my $rc;

	if($self->{_twitter}) {
		if($params{twitter_follow_button}) {
			my $language = $self->{_lingua}->language();
			if(($language eq 'English') || ($language eq 'Unknown')) {
				$rc = '<a href="http://twitter.com/' . $self->{_twitter} . '" class="twitter-follow-button">Follow @' . $self->{_twitter} . '</a>';
			} else {
				$rc = '<a href="http://twitter.com/' . $self->{_twitter} . " class=\"twitter-follow-button\" data-lang=\"$alpha2\">Follow \@" . $self->{_twitter} . '</a>';
			}
		}
		if($params{twitter_tweet_button}) {
			$rc .= '<script src="http://platform.twitter.com/widgets.js" type="text/javascript"></script><p>';
			$rc .= '<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-via=' .
				$self->_twitter .
				'>Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>';
		}
	}
	if($params{facebook_like_button}) {
		$rc .= << 'END';
			<div id="facebook">
			<div id="fb-root"></div>
			<script type="text/javascript">
				document.write('<' + 'fb:like send="false" layout="button_count" width="100" show_faces="false" font=""></fb:like>');
				var s = document.createElement('SCRIPT'), s1 = document.getElementsByTagName('SCRIPT')[0];
				s.type = 'text/javascript';
				s.async = true;
END
		$rc .= "s.src = 'http://connect.facebook.net/$alpha2/all.js#xfbml=1';";

		$rc .= << 'END';
			s1.parentNode.insertBefore(s, s1);
		    </script>
		</div>

		<p>
END
	}
	if($params{google_plus}) {
		$rc .= << 'END';
			<div id="gplus">
				<script type="text/javascript" src="https://apis.google.com/js/plusone.js">
					{"parsetags": "explicit"}
				</script>
				<div id="plusone-div"></div>

				<script type="text/javascript">
					gapi.plusone.render("plusone-div",{"size": "medium", "count": "true"});
				</script>
			</div>
END
	}

	return $rc;
}

=head1 AUTHOR

Nigel Horne, C<< <njh at bandsman.co.uk> >>

=head1 BUGS

The multilingual support for the Facebook button doesn't yet work.

Please report any bugs or feature requests to C<bug-cgi-socialmedia at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CGI-SocialMedia>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SEE ALSO

HTTP::BrowserDetect


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CGI::SocialMedia


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CGI-SocialMedia>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CGI-SocialMedia>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CGI-SocialMedia>

=item * Search CPAN

L<http://search.cpan.org/dist/CGI-SocialMedia/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Nigel Horne.

This program is released under the following licence: GPL


=cut

1; # End of CGI::SocialMedia
