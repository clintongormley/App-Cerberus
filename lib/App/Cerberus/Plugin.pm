package App::Cerberus::Plugin;

use strict;
use warnings;
use Carp;

#===================================
sub new {
#===================================
    my $class = shift;
    my $self = bless {}, $class;
    $self->init(@_);
    return $self;
}

#===================================
sub init { }
#===================================

#===================================
sub request {
#===================================
    my $self = shift;
    croak "The request() must be overriden in: " . ref $self;
}

1;

# ABSTRACT: A base class for App::Cerberus plugins

=head1 DESCRIPTION

If you want to write a plugin for L<App::Cerberus> then you must provide
a C<request> method, which accepts a L<Plack::Request> object as its first
argument, and a C<\%response> hashref as its second.

    package App::Cerberus::Plugin::Foo;

    use parent 'App::Cerberus::Plugin';

    sub request {
        my ($self, $request, $response) = @_;

        $response->{foo} = {.....};

    }

Optionally, you can also add an C<init> method, which will be called with
any options that were specified in the config file:

    sub init {
        my ($self,@args) = @_;
        ...
    }

