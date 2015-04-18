package EMS::View::Template;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    ENCODING => 'utf-8',
    WRAPPER => 'wrapper.tt2',
);

=head1 NAME

EMS::View::Template - TT View for EMS

=head1 DESCRIPTION

TT View for EMS.

=head1 SEE ALSO

L<EMS>

=head1 AUTHOR

Philip Skinner

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
