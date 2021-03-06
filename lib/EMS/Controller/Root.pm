package EMS::Controller::Root;
use Moose;
use namespace::autoclean;

use EMS::Objects::Page;
use EMS::Objects::Section;
use EMS::Objects::Block::Text;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

EMS::Controller::Root - Root Controller for EMS

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $id = $c->request->params->{id} || 1;
    my $page = $c->getPage($id);    
    
    if (!$page) {
        return $self->default($c);
    }
    
    $c->stash(page => $page);        
    $c->stash(template => $page->template);
    return;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Philip Skinner

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
