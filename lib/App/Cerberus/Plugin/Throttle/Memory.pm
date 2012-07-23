package App::Cerberus::Plugin::Throttle::Memory;

use strict;
use warnings;

#===================================
sub new {
#===================================
    my $class = shift;
    warn "WARNING: You should not use ".__PACKAGE__." in production\n";
    bless {}, $class;
}

#===================================
sub counts {
#===================================
    my ( $self, %keys ) = @_;
    map { $_ => $self->{ $keys{$_} } } keys %keys;
}

#===================================
sub incr {
#===================================
    my ( $self, %keys ) = @_;
    $self->{$_}++ for keys %keys;
    $self->_expire_old;
}

#===================================
sub _expire_old {
#===================================
    my $self = shift;
    my $now = join '', App::Cerberus::Plugin::Throttle::timestamp();
    for my $key ( keys %$self ) {
        my ($ts) = ( $key =~ m/(\d+)$/ );
        delete $self->{$key}
            if $ts < 0 + substr( $now, 0, length($ts) );
    }
}

1;

# ABSTRACT: A in-memory TESTING ONLY backend for the Throttle plugin


