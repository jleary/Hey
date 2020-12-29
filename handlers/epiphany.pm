use warnings;
use strict;
use Net::DBus;

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    if($phrase =~ /^open new window$/i){&new_window()}
    elsif($phrase =~ /^open new incognito window$/i){&new_incognito_window()}
    else{&explain($verb)}
}

sub explain{
    my $verb = $_[0];
    my %explanations = (
        open    => 'hey epiphany open new [incognito] window',
        default => 'possible verbs: open.'
    );
    print "Usage: ";
    print ($explanations{$verb} or $explanations{'default'});
    print "\n";
    return 4;
}

sub new_window{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.Epiphany");
    my $obj = $srv->get_object("/org/gnome/Epiphany","org.gtk.Actions");
    $obj->Activate('new-window',[],{});
    return 0;
}

sub new_incognito_window{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.Epiphany");
    my $obj = $srv->get_object("/org/gnome/Epiphany","org.gtk.Actions");
    $obj->Activate('new-incognito',[],{});
    return 0;
}

return 1;
