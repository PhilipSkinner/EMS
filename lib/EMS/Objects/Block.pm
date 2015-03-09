package EMS::Objects::Block;

use Moose;

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

sub saveContent {
  my $self = shift;
  
  warn "Method saveContent should be overwritten.";
  
  return 0;
}

1;
