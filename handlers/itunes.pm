use warnings;
use strict;
use Net::DBus;

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    #if($phrase =~ /^play url .+$/i){&open_url($params[-1])}
    if($phrase =~ /^play$/i){&play()}
    elsif($phrase =~ /^pause$/i){&pause()}
    elsif($phrase =~ /^stop$/i){&stop()}
    elsif($phrase =~ /^play pause$/i){&play_pause()}
    elsif($phrase =~ /^previous$/i){&previous()}
    elsif($phrase =~ /^next$/i){&next()}
    elsif($phrase =~ /^raise$/i){&raise()}
    elsif($phrase =~ /^quit$/i){&quit()}
    else{&explain($verb)}
}

sub explain{
    my $verb = $_[0];
    my %explanations = (
        play     => {order=> 1, text=>'hey itunes play [pause]'},
        pause    => {order=> 2, text=>'hey itunes pause'},
        stop     => {order=> 3, text=>'hey itunes stop'},
        previous => {order=> 4, text=>'hey itunes previous'},
        next     => {order=> 5, text=>'hey itunes next'},
        next     => {order=> 6, text=>'hey itunes raise'},
        next     => {order=> 7, text=>'hey itunes quit'},
        help     => {order=> 0, text=>'possible verbs: play, pause, stop, previous, next, raise, quit.'},
    );
    print "Usage: ";
    #print ($explanations{$verb} or $explanations{'default'});
    if($verb ne 'help' && $explanations{$verb}){
        print "$explanations{$verb}->{text}\n";
    }else{
        foreach(sort{$explanations{$a}->{order}<=>$explanations{$b}->{order} } keys %explanations){
            print "$explanations{$_}->{text}\n";
        }
    }
    return 4;
}
=pod
sub open_url{
    my $url = $_[0];
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->OpenUri($url);
    return 0;
}
=cut
sub play{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->Play();
    return 0;
}
sub pause{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->Pause();
    return 0;
}
sub play_pause{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->PlayPause();
    return 0;
}
sub stop{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->Stop();
    return 0;
}
sub previous{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->Previous();
    return 0;
}
sub next{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2.Player");
    $obj->next();
    return 0;
}
sub raise{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2");
    $obj->Raise();
    return 0;
}
sub quit{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.mpris.MediaPlayer2.itunes");
    my $obj = $srv->get_object("/org/mpris/MediaPlayer2","org.mpris.MediaPlayer2");
    $obj->Quit();
    return 0;
}



return 1;
