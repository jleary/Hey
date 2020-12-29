use warnings;
use strict;
use Net::DBus;

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    if($phrase =~ /^subscribe to url .+$/i){&subscribe_to_url($params[-1])}
    elsif($phrase =~ /^check for updates$/i){&check_for_updates()}
    else{&explain($verb)}
}

sub explain{
    my $verb = $_[0];
    my %explanations = (
        subscribe => 'hey gpodder subscribe to url https://...',
        check     => 'hey gpodder check for updates',
        default   => 'possible verbs: subscrube, check' 
    );
    print "Usage: ";
    print ($explanations{$verb} or $explanations{'default'});
    print "\n";
    return 4;
}

sub subscribe_to_url{
    my $url = $_[0];
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gpodder");
    my $obj = $srv->get_object("/gui","org.gpodder.interface");
    $obj->subscribe_to_url($url);
    return 0;
}

sub check_for_updates{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gpodder");
    my $obj = $srv->get_object("/podcasts","org.gpodder.podcasts");
    $obj->check_for_updates();
    return 0;
}


return 1;
