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

    $res = $ua->get($url . "show");
    like $res->content, qr/^message:\s*$/sm, "no messages pending";

    $res = $ua->get($url . "direct/hello");
    like $res->content, qr/^message: hello/sm, "message set and returned";

    $res = $ua->get($url . "show");
    like $res->content, qr/^message:\s*$/sm, "no messages pending";

    $res = $ua->get($url . "indirect/goodbye");
    like $res->content, qr/^message: goodbye/sm, "message set and returned";

    $res = $ua->get($url . "show");
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

    get '/direct/:message' => sub {
      deferred msg => params->{message};
      template 'index';
    };

    get '/indirect/:message' => sub {
      deferred msg => params->{message};
      redirect '/fake';
    };

    get '/fake' => sub {
      redirect '/show';
    };

    get '/show' => sub {
      template 'index';
    };

    start;
  },
);
done_testing;

# COPYRIGHT
