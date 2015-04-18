use DB::Schema;
use SQL::Translator;

my $schema = DB::Schema->connect;
my $trans  = SQL::Translator->new (
      parser      => 'SQL::Translator::Parser::DBIx::Class',
      parser_args => {
          dbic_schema => $schema,
          add_fk_index => 1,
          sources => [qw/
            Block
            Page
            Role
            Section
            Session
            User
            UserRole
          /],
      },
      producer    => 'SQL::Translator::Producer::MySQL',
     ) or die SQL::Translator->error;
my $out = $trans->translate() or die $trans->error;

print $out;
