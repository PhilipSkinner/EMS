package EMS::Descriptors::Page;

use Moose;

extends 'EMS::Objects::Page';

use EMS::Defaults;

sub initialize {
  my $self = shift;
  
  $self->template('page.tt2');
  $self->sections(
    #first section
    [
      #block descriptor
      {
        type 		=> EMS::Defaults->text,
      },
    ]
  );
  
  return $self;
}
