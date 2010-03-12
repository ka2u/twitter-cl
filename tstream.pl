#!/usr/bin/perl

use strict;
use warnings;
use lib "./extlib/lib/perl5";
use AnyEvent::Twitter::Stream;
use Encode;

my $done = AnyEvent->condvar;

my @words = ();
my $listener = AnyEvent::Twitter::Stream->new(
    username => "",
    password => "",
    method => "filter",
    track => join(",", @words),
    on_tweet => sub {
        my $tweet = shift;
        print Encode::encode('utf-8', "$tweet->{user}{screen_name}: $tweet->{text}\n");
    },
    on_keepalive => sub {
        warn "ping\n";
    },
    timeout => 45,
);

$done->recv;
