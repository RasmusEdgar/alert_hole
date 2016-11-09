package AlertHole;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Enable config
  my $config = $self->plugin('Config');

  # Secret
  $self->secrets( $config->{'secrets'} );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/alert/*name')->to(controller => 'Hole', action => 'alerthole');

  # Reject all other stuff
  $r->any('/')->to(controller => 'Hole', action => 'failure');
  $r->any('/*name')->to(controller => 'Hole', action => 'failure');

}

1;
