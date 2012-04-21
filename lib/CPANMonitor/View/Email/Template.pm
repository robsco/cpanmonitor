package CPANMonitor::View::Email::Template;

use strict;
use base 'Catalyst::View::Email::Template';

__PACKAGE__->config(
    stash_key       => 'email_template',
    template_prefix => 'email',
    default => { view => 'HTML', content_type => 'text/plain' },
);

=head1 NAME

CPANMonitor::View::Email::Template - Templated Email View for CPANMonitor

=head1 DESCRIPTION

View for sending template-generated email from CPANMonitor. 

=head1 AUTHOR

A clever guy

=head1 SEE ALSO

L<CPANMonitor>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
