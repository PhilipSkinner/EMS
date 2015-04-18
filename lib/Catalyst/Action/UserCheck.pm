package Catalyst::Action::UserCheck;

use Moose;
use namespace::autoclean;
use MRO::Compat;
extends 'Catalyst::Action';

sub match {
  my $self = shift;
  my $c = $_[0];

  if ($c->check_user_roles('user')) {     
    my $user = $c->userDetails();
    
    if ($user->status() eq 'P') {
      $c->response->redirect('/account?new=1');
      return;
    }
  
    return $self->next::method(@_);
  } else {
    $c->redirectToLogin();
  }
}

sub execute {
  my $self = shift;
  my $c = $_[1];

  if ($c->check_user_roles('user')) {     
    my $user = $c->userDetails();
    
    if ($user->status() eq 'P') {
      $c->response->redirect('/account?new=1');
      return;
    }

    return $self->next::method(@_);
  } else {
    $c->redirectToLogin();
  }
}

sub dispatch {
  my $self = shift;
  my $c = $_[0];
  
  if ($c->check_user_roles('user')) {     
    my $user = $c->userDetails();
    
    if ($user->status() eq 'P') {
      $c->response->redirect('/account?new=1');
      return;
    }

    return $self->next::method(@_);
  } else {
    $c->redirectToLogin();
  }
}
