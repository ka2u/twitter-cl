#!/usr/bin/perl

use strict;
use warnings;
use lib "./extlib/lib/perl5";
use AnyEvent::Twitter;
use Encode;

my $cv = AnyEvent->condvar;

my $twitter = AnyEvent::Twitter->new(
    username => '',
    password => '',
    bandwidth => 0.35,
);

$twitter->reg_cb (
    error => sub {
        my ($twitter, $error) = @_;
        warn "Error: $error\n";
    },
    statuses_friends => sub {
        my ($twitter, @statuses) = @_;
        print_statuses(@statuses);
    },
    statuses_mentions => sub {
        my ($twitter, @statuses) = @_;
        print_statuses(@statuses);
    },
);

sub print_statuses {
    my @statuses = @_;
    for (@statuses) {
        my ($pp_status, $raw_status) = @$_;
        my $name = $pp_status->{screen_name};
        my $sn = (15 - length $name); 
        printf "%s%${sn}s : %s\n",
            Encode::encode('utf-8', $pp_status->{screen_name}), 
            ' ',
            Encode::encode('utf-8', $pp_status->{text});
    }
}

$twitter->receive_statuses_friends;

$twitter->start;

$cv->recv;
