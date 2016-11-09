package AlertHole::Controller::Hole;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Log;

sub failure {
  my $self = shift;

  # Fetch config
  my $config = $self->config;

  $self->render(text => $config->{'failure_text'}, status => $config->{'failure_code'} );
}

sub loghole {
  my $self = shift;

  # Fetch config
  my $config = $self->config;

  my $user_agent = $self->req->headers->user_agent;

  # Check if user_agent string exists in hash of hashes
  if ( my @key = grep { $config->{'ua_strings'}{$_} eq $user_agent } keys $config->{'ua_strings'} ) {
    # Enable logging
    my $log = Mojo::Log->new(path => "$config->{'logpath'}/$config->{'logprefix'}-@{key}.log");
    $self->render(text => "@key OK\n");
    $log->warn('Alert received: '.$self->stash('name')); 
  } else {
    # Send to failure
    $self->redirect_to('/');
  }
}

1;
