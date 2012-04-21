package CPANMonitor::Form::Alert;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler';

use MetaCPAN::API;
         
has_field distribution => ( type         => 'Text',
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


sub validate_distribution
{
	my ( $self, $field ) = @_;
	
	my $mcpan = MetaCPAN::API->new;			
			
	my $metacpan_dist = $field->value;

	$metacpan_dist =~ s/::/-/g;
	
	eval {
		my $distribution = $mcpan->release( distribution => $metacpan_dist );
	};
	
	if ( my $exception = $@ )
	{
		$field->add_error( "Package not found" ) if $exception =~ /Not Found/;
	}
}

1;

