package EMS::JSON;

use Moose;

has c => (
  is	=> 'ro',
  isa	=> 'EMS',
);

sub error {
  my $self = shift;
  my $txt = shift;
  my $code = shift;
  
  $self->c->stash({ meta => { code => $code }, error => { message => $txt } });
  $self->c->forward('View::JSON');

  return;
}

sub payload {
  my $self = shift;
  my $payload = shift;
  
  $self->c->stash({ meta => { code => 200 }, data => $payload });
  $self->c->forward('View::JSON');

  return;
}

1;
