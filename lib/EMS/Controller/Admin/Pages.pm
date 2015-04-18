package EMS::Controller::Admin::Pages;
use Moose;
use namespace::autoclean;
use EMS::Defaults;
use JSON qw (from_json to_json);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

EMS::Controller::Admin::Pages - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) ActionClass('AdminCheck') {
    my ( $self, $c ) = @_;

    $c->stash(template => 'admin/pages/index.tt2');
}

sub add :Local :Args(0) ActionClass('AdminCheck') {
    my ($self, $c) = @_;
    
    my @descriptors = $c->model('DB::Descriptor')->search({})->all();
    $c->stash(descriptors => \@descriptors);
    $c->stash(template => 'admin/pages/add.tt2');        
}

sub form :Local :Args(1) ActionClass('AdminCheck') {
    my ($self, $c, $pageId) = @_;
    
    my $page = $c->model('DB::Page')->find({ uid => $pageId });
    
    #load our descriptor
    my $descriptor = undef;
    my $blockLookup = [];
    if ($page) {
        $descriptor = $c->model('DB::Descriptor')->find({ class => $page->type() });
        
        #do the lookup for presenting existing data
        foreach my $section ($page->sections) {
            foreach my $block ($section->blocks) {
                push @{$blockLookup}, from_json($block->content());
            }
        }        
    } else {
        $descriptor = $c->model('DB::Descriptor')->find({ uid => $c->request->params->{descriptor} });
    }
    
    #create a model for the form
    my $model = [];
    my $sectionCount = 0;
    my $blockCount = 0;
    eval {
        (my $file = $descriptor->class()) =~ s/\:\:/\//g;
        require $file . '.pm';
        my $obj = $descriptor->class()->new();

        foreach my $s ($obj->sections) {
            my $section = {
                count 	=> $sectionCount,
                blocks 	=> [],
            };
            #read the blocks
            foreach my $b (@{$s}) {
                if (defined $b->{type} && $b->{type} ne '') {
                    push @{$section->{blocks}}, {
                        count => $blockCount,
                        type => $b->{type},
                        title => $b->{title},
                        data => $blockLookup->[$blockCount],
                    };
                } else {
                    push @{$section->{blocks}}, {
                        count => $blockCount,
                        type	=> EMS::Defaults->text,
                        title => $b->{title},
                        data => $blockLookup->[$blockCount],
                    };
                }
                
                $blockCount++;
            }            
            
            push @{$model}, $section;
            
            $sectionCount++;
        }            
    };
    
    if ($@) {
        my $error = $@;
        print STDERR $error;
        
        die $@;
    }

    use Data::Dumper;
    
    print STDERR Dumper({ model => $model });

    $c->stash(model => $model);    
    $c->stash(descriptor => $descriptor);
    $c->stash(page => $page);
    $c->stash(template => 'admin/pages/form.tt2');
}

sub save :Local :Args(1) ActionClass('AdminCheck') {
    my ($self, $c, $pageId) = @_;
    
    my $page = $c->model('DB::Page')->find({ uid => $pageId });
    
    if (!$page) {
        #create it
        $page = $c->model('DB::Page')->create({
            name 	=> $c->request->params->{name},
            type	=> $c->request->params->{descriptor},
            status	=> $c->request->params->{status},
            parent	=> $c->request->params->{parent},
        });
        
        #we also need to setup the sections and blocks ready to receive content
        eval {
            (my $file = $page->type()) =~ s/\:\:/\//g;
            require $file . '.pm';
            my $obj = $page->type()->new();
            
            #it should now be initialized, so we can read the section layout
            foreach my $s ($obj->sections) {
                #create the section
                my $section = $c->model('DB::Section')->create({
                    page 	=> $page->uid(),
                });
                
                #read the blocks
                foreach my $b (@{$s}) {
                    if (defined $b->{type} && $b->{type} ne '') {
                        my $block = $c->model('DB::Block')->create({
                            section	=> $section->uid(),
                            type	=> $b->{type},
                            content	=> '',
                            status	=> 'active',
                        });                    
                    } else {
                        #wack a default in there
                        my $block = $c->model('DB::Block')->create({
                            section	=> $section->uid(),
                            type	=> EMS::Defaults->text,
                            content	=> '',
                            status	=> 'active',
                        });
                    }
                }
            }            
        };
        
        if ($@) {
            my $error = $@;
            print STDERR $error;
            
            die $error;
        };
    } else {	
        #change the name
        $page->name($c->request->params->{name});
        $page->update();
    }
    
    #now the real fun begins, saving some data

    my $sectionCount = 0;
    my $blockCount = 0;    
    #get the sections and rename
    foreach my $section ($page->sections) {
        $section->name($c->request->params->{'section_name_' . $sectionCount});
        $section->update();
        
        #its the blocks turn
        foreach my $block ($section->blocks) {
            #we instantiate the block type, pass in every value given for the block and then rely on its internal saving mechanism
            eval {
                (my $file = $block->type()) =~ s/\:\:/\//g;
                require $file . '.pm';
                my $obj = $block->type()->new();
                
                $obj->loadFrom($block);
                
                #gather our keys
                my $data = {};
                foreach my $key (keys %{$c->request->params}) {
                    if ($key =~ m/^block_data_(\d+)_(.*?)$/i) {
                        if ($1 == $blockCount) {
                            if (ref $c->request->params->{$key} ne 'ARRAY') {
                                $c->request->params->{$key} = [$c->request->params->{$key}];
                            }
                    
                            foreach my $entry (@{$c->request->params->{$key}}) {
                                if (!$data->{$2}) {
                                    $data->{$2} = $entry;
                                } else {
                                    if (ref $data->{$2} ne 'ARRAY') {
                                        $data->{$2} = [$data->{$2}];
                                    }
                                
                                    push @{$data->{$2}}, $entry;
                                }
                            }
                        }
                    }
                }
                
                #any files
                foreach my $key (keys %{$c->request->uploads}) {
                    if ($key =~ m/^block_data_$blockCount\_(.*?)$/i) {
                        if (ref $c->request->uploads->{$key} ne 'ARRAY') {
                            $c->request->uploads->{$key} = [$c->request->uploads->{$key}];
                        }
                        
                        foreach my $file (@{$c->request->uploads->{$key}}) {
                            if (!$data->{$1}) {
                                $data->{$1} = $file->tempname;
                            } else {
                                if (ref $data->{$1} ne 'ARRAY') {
                                    $data->{$1} = [$data->{$1}];
                                }
                                
                                push @{$data->{$1}}, $file->tempname;
                            }
                        }
                    }                
                }
                
                use Data::Dumper;
                
                print STDERR Dumper({ data => $data });
                
                $obj->setContent($data);
                $block->content($obj->jsonContent);
                $block->update();                
            } or do {
                my $error = $@;
                print STDERR $error;
                
                die $error;
            };
            
            $blockCount++;
        }
        
        $sectionCount++;
    }
    
    #redirect
    $c->response->redirect('/admin/pages');
    return;
}

=encoding utf8

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
