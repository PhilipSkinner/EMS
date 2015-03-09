package EMS;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use EMS::Factory::Page;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    
    Authentication
    Authentication::Store::DBIC
    Authentication::Credential::Password
    Authorization::Roles
    
    Session
    Session::Store::DBIC
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in ems.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'EMS',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header 			=> 1, # Send X-Catalyst header
    default_view 				=> 'Template',
    authentication => {
        dbic => {
            user_class 				=> 'DB::User',
            user_field 				=> 'username',
            password_field 			=> 'password',
            password_type 			=> 'SHA-2',
        }
    },
    'Plugin::Session' => {
        dbic_class 				=> 'DB::Session',
        expires 				=> 36000,
    },
    authorization => {
        dbic => {
            role_class 				=> 'DB::Role',
            role_field 				=> 'role',
            role_rel 				=> 'user_role',
            user_role_user_field 		=> 'user',
            user_role_class 			=> 'DB::UserRole',
            user_role_role_field 		=> 'role',
        }
    },
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

EMS - Catalyst based application

=head1 SYNOPSIS

    script/ems_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<EMS::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Philip Skinner

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub getPage {
    my $self = shift;
    my $id = shift;
    
    if (!$self->{pageFactory}) {
        $self->{pageFactory} = EMS::Factory::Page->new();
    }
        
    return $self->{pageFactory}->loadPage($self->model('DB::Page')->find({ uid => $id }));
}

1;
