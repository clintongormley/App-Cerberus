package App::Cerberus::Plugin::BrowserDetect;

use strict;
use warnings;
use HTTP::BrowserDetect();
use List::Util qw(first);
use Carp;
use parent 'App::Cerberus::Plugin';

#===================================
sub init {
#===================================
    my $self = shift;
    $self->{cache} = {};
}

#===================================
sub request {
#===================================
    my ( $self, $req, $response ) = @_;
    my $ua = $req->param('ua') or return;
    $response->{ua} = $self->{cache}{$ua} and return;

    my $detect = HTTP::BrowserDetect->new($ua);
    my $browser = first { $detect->$_ } @HTTP::BrowserDetect::BROWSER_TESTS;

    my %data   = (
        browser => $browser||'',
        device    => $detect->device    || '',
        os        => $detect->os_string || '',
        is_mobile => $detect->mobile    || 0,
        version   => {
            major => $detect->public_major   || '',
            minor => $detect->public_minor   || '',
            full  => $detect->public_version || ''
        },
        browser_properties => [ $detect->browser_properties ],
    );


    if ( $data{is_robot} = $detect->robot || 0) {
        my $robot = first { $detect->$_ } @HTTP::BrowserDetect::ROBOT_TESTS;
        $data{robot} = $robot || 'unknown';
    }

    $response->{ua} = $self->{cache}{$ua} = \%data;
}

1;

# ABSTRACT: Add user-agent information to App::Cerberus

=head1 DESCRIPTION

This plugin uses L<HTTP::BrowserDetect> to add information about the user agent
to Cerberus. For instance:

    "ua": {
        "is_robot": 0,
        "is_mobile": 1,
        "version": {
            "minor": ".1",
            "full": 5.1,
            "major": "5"
        },
        "browser": "safari",
        "device": "iphone",
        "browser_properties": [
            "ios",
            "iphone",
            "ipod",
            "mobile",
            "safari",
            "device"
        ],
        "os": "iOS"
    }

=head1 REQUEST PARAMS

User-Agent information is returned when an User-Agent value is passed in:

    curl http://host:port/?ua=Mozilla%2F5.0 (compatible%3B Googlebot%2F2.1%3B %2Bhttp%3A%2F%2Fwww.google.com%2Fbot.html)

=head1 CONFIGURATION

This plugin takes no configuration options:

    plugins:
      - BrowserDetect





