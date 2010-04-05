#!/usr/bin/perl

use strict;
use warnings;
use lib "./extlib/lib/perl5";
use Net::Twitter::Lite;
use Config::Pit;
use LWP::UserAgent;
use JSON;

my $config = pit_get("twitter", require =>{
    "username" => "username",
    "password" => "password",
});

my $nt = Net::Twitter::Lite->new(
    username => $config->{username},
    password => $config->{password},
);

my $word = $ARGV[0];
my $shortened;
if ($word =~ m{(http://.*)}) {
    my $url = $1;
    my $params = {
        login => '',
        apiKey => '',
        uri => $url,
        format => 'json',
    };
    my $endpoint = "http://api.bit.ly/v3/shorten";
    my $ua = LWP::UserAgent->new;
    my $res = $ua->post($endpoint, $params);
    if ($res->is_success) {
        $shortened = from_json($res->content);
    }
    else {
        die "missed shorten.";
    }
}
$word =~ s#http://.*#$shortened->{data}->{url}# unless $word =~ m{http://bit.ly/.*};
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
