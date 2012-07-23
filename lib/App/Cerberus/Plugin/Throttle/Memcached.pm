package App::Cerberus::Plugin::Throttle::Memcached;

use strict;
use warnings;
use Cache::Memcached::Fast();

#===================================
sub new {
#===================================
    my ( $class, $conf ) = @_;
    my $cache = Cache::Memcached::Fast->new($conf);
    bless { cache => $cache }, $class;
}

#===================================
sub counts {
#===================================
    my ( $self, %keys ) = @_;
    my %reverse;
    my @ids = values %keys;
    @reverse{@ids} = keys %keys;

    my $result = $self->{cache}->get_multi(@ids);
    my %result = map { $reverse{$_} => $result->{$_} } @ids;
}

#===================================
sub incr {
#===================================
    my ( $self, %keys ) = @_;
    my @set = map [ $_, 1, $keys{$_} ], keys %keys;
    my $result = $self->{cache}->add_multi(@set);
    for ( keys %$result ) {
        $self->{cache}->incr($_)
            unless $result->{$_};
    }

}

1;

# ABSTRACT: A Memcached backend for the Throttle plugin

