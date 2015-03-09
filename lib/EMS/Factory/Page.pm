package EMS::Factory::Page;

use Moose;
use DB::Schema::Result::Page;
use EMS::Objects::Page;
use EMS::Objects::Section;
use JSON qw(from_json);

sub loadPage {
  my $self = shift;
  my $_page = shift;
      
  if (!$_page) {
    warn "EMS::Factory::Page->loadPage called without page parameter\n";
    return undef;
  }
  
  my $page = EMS::Objects::Page->new();
  $page->name($_page->name());
  $page->template($_page->template());
  
  foreach my $_section (@{$_page->getSections}) {
    my $section = EMS::Objects::Section->new();
    $section->name($_section->name());
    
    foreach my $_block ($_section->blocks) {
      my $file = $_block->type();
      $file =~ s/\:\:/\//g;
      $file .= '.pm';
      require $file;
      my $block = $_block->type()->new;
      
      $block->content(from_json($_block->content()));
      
      $section->addBlock($block);
    }
    
    $page->addSection($section);
  }
  
  return $page;
}

1;
