#!/usr/bin/perl

use strict;
use warnings;
use lib "./extlib/lib/perl5";
use Net::Twitter::Lite;
use Config::Pit;

my $config = pit_get("twitter", require =>{
    "username" => "username",
    "password" => "password",
});

my $nt = Net::Twitter::Lite->new(
    username => $config->{username},
    password => $config->{password},
);

my $word = $ARGV[0];
print "can I tweet '$word'?\n";
my $yn = <STDIN>;
chomp $yn;
if ($yn eq 'y') {
    my $result = eval { $nt->update($word) };
}
else {
    print "tweet cancel\n";
}

warn $@ if $@;
