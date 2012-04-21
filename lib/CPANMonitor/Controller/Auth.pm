package CPANMonitor::Controller::Auth;

use Moose;
use namespace::autoclean;

BEGIN { extends 'CatalystX::Controller::Auth'; }

=head1 NAME

CPANMonitor::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
