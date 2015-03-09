package EMS::Objects::Page;

use Moose;

use EMS::Objects::Section;

has _sections => (
  traits	=> ['Array'],
  isa		=> 'ArrayRef[EMS::Objects::Section]',
  is		=> 'rw',
  default	=> sub { [] },
  handles	=> {
    sections		=> 'elements',
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

1;

