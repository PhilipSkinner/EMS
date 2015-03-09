package EMS::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

EMS::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub login :Local :Args(0) {
    my ($self, $c) = @_;
    
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    
    if (!$username || $username eq '') {
        $c->json->error('Missing username field', '401');
        return;
    }
    
    if (!$password || $password eq '') {
        $c->json->error('Missing password field', '401');
        return;
    }
    
    if ($c->login($username, $password)) {
        $c->json->payload({ status => 1 });
        return;
    } else {
        $c->json->error('Incorrect details', '401');
        return;
    }        
}

sub register :Local :Args(0) {
    my ($self, $c) = @_;
    
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    
    if (!$username || $username eq '') {
        $c->json->error('Missing username field', '401');
        return;
    }
    
    if (!$password || $password eq '') {
        $c->json->error('Missing password field', '401');
        return;
    }
    
    my $user = $c->model('DB::User')->create({
        username => $username,
        password => $c->generatePassword($password),
    });    
    
    $c->json->payload({ status => 1 });
    return;
}

sub forgotten :Local :Args(0) {
    my ($self, $c) = @_;
}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
