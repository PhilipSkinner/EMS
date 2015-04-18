package EMS::Objects::Page;

use Moose;

use EMS::Objects::Section;

has sections => (
  traits	=> ['Array'],
  isa		=> 'ArrayRef',
  is		=> 'rw',
  default	=> sub { [] },
);

has _sections => (
  traits	=> ['Array'],
  isa		=> 'ArrayRef[EMS::Objects::Section]',
  is		=> 'rw',
  default	=> sub { [] },
  handles	=> {
    getSections		=> 'elements',
    addSection		=> 'push',
    mapSections		=> 'map',
    sectionCount	=> 'count',
    sortedSections	=> 'sort',
  },
);
has name => (
  isa		=> 'Str',
  is		=> 'rw',
);
has template => (
  isa		=> 'Str',
  is		=> 'rw',
);

sub BUILD {
  my $self = shift;
  
  $self->initialize();
}

sub initialize {
  my $self = shift;
  
  die "EMS::Objects::Page->initialize() called instead of being overridden";
}

1;

