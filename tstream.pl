#!/usr/bin/perl

use strict;
use warnings;
use lib "./extlib/lib/perl5";
use AnyEvent::Twitter::Stream;
use Encode;
use Config::Pit;

my $config = pit_get("twitter", require => {
    "username" => "userrname",
    "password" => "password",
});

my $done = AnyEvent->condvar;

my @words = ();
my $listener = AnyEvent::Twitter::Stream->new(
    username => $config->{username},
    password => $config->{password},
    method => "filter",
    track => join(",", @words),
    on_tweet => sub {
        my $tweet = shift;
        my $sn = (15 - length $tweet->{user}{screen_name});
        printf "%s%${sn}s : %s\n",
          Encode::encode( 'utf-8', $tweet->{user}{screen_name} ), ' ',
          Encode::encode( 'utf-8', $tweet->{text} );
    },
    on_keepalive => sub {
        warn "ping\n";
    },
    timeout => 45,
);

$done->recv;
