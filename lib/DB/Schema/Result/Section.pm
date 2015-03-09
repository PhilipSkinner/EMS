use utf8;
package DB::Schema::Result::Section;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DB::Schema::Result::Section

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

=head1 TABLE: C<section>

=cut

__PACKAGE__->table("section");

=head1 ACCESSORS

=head2 uid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 page

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'enum'
  default_value: 'active'
  extra: {list => ["active","hidden","deleted"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "uid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "page",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "status",
  {
    data_type => "enum",
    default_value => "active",
    extra => { list => ["active", "hidden", "deleted"] },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</uid>

=back

=cut

__PACKAGE__->set_primary_key("uid");

=head1 RELATIONS

=head2 blocks

Type: has_many

Related object: L<DB::Schema::Result::Block>

=cut

__PACKAGE__->has_many(
  "blocks",
  "DB::Schema::Result::Block",
  { "foreign.section" => "self.uid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 page

Type: belongs_to

Related object: L<DB::Schema::Result::Page>

=cut

__PACKAGE__->belongs_to(
  "page",
  "DB::Schema::Result::Page",
  { uid => "page" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2015-03-09 20:05:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7q89UeaSqymyJStxodVLrg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
