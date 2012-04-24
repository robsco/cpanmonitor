package CPANMonitor::Script::Monitor;

use CPANMonitor::Schema;

# instantiated via Catalst::ScriptRunner;

sub new_with_options
{
	my ( $class, $app_name, $app ) = @_;

	my $self = bless {}, $class;
	
	return $self;
}

# default run method

sub run
{
	my $self = shift;
		
	my $schema = CPANMonitor::Schema->connect( $ENV{ CPANMONITOR_DB } || 'dev' );
	
	my @alerts = $schema->resultset('Alert')->all;
	
	foreach my $alert ( @alerts )
	{
		$alert->update_from_api;
	}
	
	

}


1;


