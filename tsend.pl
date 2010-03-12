#!/usr/bin/perl

use strict;
use warnings;
use lib "./extlib/lib/perl5";
use Net::Twitter::Lite;

my $nt = Net::Twitter::Lite->new(
    username => "",
    password => "",
);

my $word = $ARGV[0];
print "can I tweet $word?\n";
my $yn = <STDIN>;
chomp $yn;
if ($yn eq 'y') {
    my $result = eval { $nt->update($word) };
}
else {
    print "tweet cancel\n";
}

warn $@ if $@;
