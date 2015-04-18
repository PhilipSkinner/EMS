use utf8;
package DB::Schema::Result::Page;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DB::Schema::Result::Page

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<page>

=cut

__PACKAGE__->table("page");

=head1 ACCESSORS

=head2 uid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 type

  data_type: 'varchar'
  default_value: 'EMS::Descriptors::Page'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'enum'
  default_value: 'active'
  extra: {list => ["active","hidden","deleted"]}
  is_nullable: 0

=head2 parent

  data_type: 'integer'
  default_value: 1
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "uid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "type",
  {
    data_type => "varchar",
    default_value => "EMS::Descriptors::Page",
    is_nullable => 1,
    size => 255,
  },
  "status",
  {
    data_type => "enum",
    default_value => "active",
    extra => { list => ["active", "hidden", "deleted"] },
    is_nullable => 0,
  },
  "parent",
  {
    data_type      => "integer",
    default_value  => 1,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</uid>

=back

=cut

__PACKAGE__->set_primary_key("uid");

=head1 RELATIONS

=head2 pages

Type: has_many

Related object: L<DB::Schema::Result::Page>

=cut

__PACKAGE__->has_many(
  "pages",
  "DB::Schema::Result::Page",
  { "foreign.parent" => "self.uid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<DB::Schema::Result::Page>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "DB::Schema::Result::Page",
  { uid => "parent" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 sections

Type: has_many

Related object: L<DB::Schema::Result::Section>

=cut

__PACKAGE__->has_many(
  "sections",
  "DB::Schema::Result::Section",
  { "foreign.page" => "self.uid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-04-18 10:22:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:k4MpajQ9VvBbKaRPs4xYjQ

sub getSections {
  my $self = shift;
  
  my @rs = $self->sections;
    
  return \@rs;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
