package CPANMonitor::Schema::ResultSet::User;

=head1 NAME

Affiliates::Schema::ResultSet::Voucher

=cut

use strict;
use warnings;



use base 'DBIx::Class::ResultSet';

sub auto_create
{
    my $self = shift;
     
    $self->create( @_ );
}



1;
