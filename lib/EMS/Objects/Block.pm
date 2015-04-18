package EMS::Objects::Block;

use Moose;
use JSON qw( from_json to_json );

#default block attributes shared by all blocks
has multiple 	=> (
                      is 	=> 'rw', 
                      isa 	=> 'Int',
                      default	=> 0,
                  );
has ordered	=> (  
                      is 	=> 'rw',
                      isa 	=> 'Int',
                      default	=> 0,
                  );
has versions	=> (
                      is	=> 'rw',
                      isa	=> 'Int',
                      default	=> 0,
                  );
has content	=> (
                      is	=> 'rw',
                      default 	=> sub { {} },
                  );

sub getContent {
  my $self = shift;
  
  warn "Method getContent should be overwritten.";
  
  return undef;
}

sub setContent {
  my $self = shift;
  
  warn "Method setContent should be overwritten.";
  
  return 0;
}

sub loadFrom {
  my $self = shift;
  my $dbObj = shift;
  
  eval {
    $self->content(from_json($dbObj->content()));
  };  
  
  return $self;
}

sub jsonContent {
  my $self = shift;
  
  return to_json($self->content);
}

1;
