package EMS::Descriptors::Homepage;

use Moose;

extends 'EMS::Objects::Page';

sub initialize {
  my $self = shift;
  
  $self->template('homepage.tt2');
  $self->sections(
    #first section
    [
      #block descriptor
      {
        title		=> 'Company description',
        type 		=> EMS::Defaults->text,
      },
      {
        title		=> 'Company history',
        type		=> EMS::Defaults->text,
      },
    ]
  );
  
  return $self;
}
