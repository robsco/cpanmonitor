package CPANMonitor::View::Email;

use strict;
use base 'Catalyst::View::Email';

__PACKAGE__->config(
    stash_key => 'email'
);

=head1 NAME

CPANMonitor::View::Email - Email View for CPANMonitor

=head1 DESCRIPTION

View for sending email from CPANMonitor. 

=head1 AUTHOR

A clever guy

=head1 SEE ALSO

L<CPANMonitor>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
