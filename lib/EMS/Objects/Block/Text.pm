package EMS::Objects::Block::Text;

use Moose;

extends 'EMS::Objects::Block';

sub setContent {
  my $self = shift;
  my $content = shift;
  
  $self->content($content);
  
  return 1;
}

sub getContent {
  my $self = shift;
  
  return $self->content->{text};
}

1;
