use strict;
use Net::DBus;

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    if($phrase =~ /^empty trash$/i){&empty_trash()}
    elsif($phrase =~ /^open new window$/i){&new_window()}
    elsif($phrase =~ /^toggle sidebar$/i){&show_hide_sidebar()}
    else{&explain($verb)}
}

sub explain{
    my $verb = $_[0];
    my %explanations = (
        empty   => 'hey nautilus empty trash',
        open    => 'hey nautilus open new window',
        toggle  => 'hey nautilus toggle sidebar',
        default => 'possible verbs: open, empty, toggle.'
    );
    print "Usage: ";
    print ($explanations{$verb} or $explanations{'default'});
    print "\n";
    return 4;
}

sub empty_trash{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.Nautilus");
    my $obj = $srv->get_object("/org/gnome/Nautilus","org.gnome.Nautilus.FileOperations");
    $obj->EmptyTrash;
    return 0;
}

sub new_window{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.Nautilus");
    my $obj = $srv->get_object("/org/gnome/Nautilus","org.gtk.Actions");
    $obj->Activate('new-window',[],{});
    return 0;
}

sub show_hide_sidebar{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.Nautilus");
    my $obj = $srv->get_object("/org/gnome/Nautilus","org.gtk.Actions");
    $obj->Activate('show-hide-sidebar',[],{});
    return 0;
}

return 1;
