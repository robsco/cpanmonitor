package CPANMonitor::Form::Search;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler';
   
has_field distribution => ( type         => 'Text',
                             required => 1,
                        tags         => { no_errors => 1 },
                        wrapper_attr => { id => 'field-distribution' },
                      );


has_field submit => ( type         => 'Submit',
                      value        => 'Search',
                      wrapper_attr => { id => 'field-submit', },
                    );

1;

