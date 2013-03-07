use 5.010;
use strict;
use warnings;
use Test::More 0.96 import => ['!pass'];
use Test::TCP;

use Dancer2 ':syntax';
use Dancer2::Plugin::Deferred;
use LWP::UserAgent;

test_tcp(
  client => sub {
    my $port = shift;
    my $url  = "http://localhost:$port/";

    my $ua = LWP::UserAgent->new( cookie_jar => {} );
    my $res;

    $res = $ua->get( $url . "show" );
    like $res->content, qr/^message:\s*$/sm, "no messages pending";

    $res = $ua->get( $url . "link" );
    my $location = $res->content;
    chomp $location;
    $res = $ua->get( $location );
    like $res->content, qr/^message: sayonara/sm,
      "message set and returned via keep/link";

    $res = $ua->get( $url . "show" );
    like $res->content, qr/^message:\s*$/sm, "no messages pending";

  },

  server => sub {
    my $port = shift;

    set confdir => '.';
    set port => $port, startup_info => 0;

    Dancer2->runner->server->port($port);
    @{engine('template')->config}{qw(start_tag end_tag)} = qw(<% %>);

    set show_errors => 1;

    set views => path( 't', 'views' );
    set session => 'Simple';

    get '/show' => sub {
      template 'index';
    };

    get '/link' => sub {
      deferred msg => "sayonara";
      template 'link' => { link => uri_for( '/show', {deferred_param} ) };
    };

    start;
  },
);
done_testing;

# COPYRIGHT
