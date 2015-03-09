use utf8;
package DB::Schema::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DB::Schema::Result::UserRole

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

=head1 TABLE: C<user_role>

=cut

__PACKAGE__->table("user_role");

=head1 ACCESSORS

=head2 user

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user>

=item * L</role>

=back

=cut

__PACKAGE__->set_primary_key("user", "role");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<DB::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "DB::Schema::Result::Role",
  { uid => "role" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 user

Type: belongs_to

Related object: L<DB::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "DB::Schema::Result::User",
  { uid => "user" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2015-03-09 21:11:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Kvl0DrOvwnUqZGXGHX/3oQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
