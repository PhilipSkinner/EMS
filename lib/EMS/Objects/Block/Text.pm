package EMS::Objects::Block::Text;

use Moose;

extends 'EMS::Objects::Block';

sub saveContent {
  my $self = shift;
  my $content = shift;
  
  $self->content({
    text => $content,
  });
  
  return 1;
}

sub getContent {
  my $self = shift;
  
  return $self->content->{text};
}

1;
