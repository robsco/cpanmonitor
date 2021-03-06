package CPANMonitor::Form::Alert;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler';

use MetaCPAN::API;

has_field distribution => ( type         => 'Text',
                             required => 1,
                        tags         => { no_errors => 1 },
                        wrapper_attr => { id => 'field-distribution' },
                      );

has_field email => ( type         => 'Email',
                        tags         => { no_errors => 1 },
                        wrapper_attr => { id => 'field-email' },
                      );

has_field development => ( type => 'Checkbox',
                           label => 'Include Development Releases',
                           tags         => { no_errors => 1 },
                        wrapper_attr => { id => 'field-development' },
                      );

has_field submit => ( type         => 'Submit',
                      value        => 'Add',
                      wrapper_attr => { id => 'field-submit', },
                    );


sub html_attributes
{
	my ($self, $field, $type, $attr, $result) = @_;
    
	if( $type eq 'label' && $result->has_errors )
	{
		push @{$attr->{class}}, 'error';
	}
}

1;

