package EMS::Objects::Section;

use Moose;
use EMS::Objects::Block;

has name => (
  is 	=> 'rw',
  isa	=> 'Str',
);
has _blocks => (
  is		=> 'rw',
  traits	=> ['Array'],
  isa		=> 'ArrayRef',
  default	=> sub { [] },
  handles	=> {
    blocks		=> 'elements',
    addBlock		=> 'push',
    mapBlocks		=> 'map',
    blockCount		=> 'count',
    sortedBlocks	=> 'sort',
  },
);

1;
