use warnings;
use strict;
use Net::DBus;
use Net::DBus::Binding::Value;

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    if($phrase =~ /^lock( the | )screen(s|)$/i){&lock_screen()}
    elsif($phrase =~ /^increase( the | )screen(s|) brightness$/i){&step_up_screen_brightness()}
    elsif($phrase =~ /^decrease( the | )screen(s|) brightness$/i){&step_down_screen_brightness()}
    elsif($phrase =~ /^get( the | )screen(s|) brightness$/i){&get_screen_brightness()}
    elsif($phrase =~ /^set( the | )screen(s|) brightness to \d{1,3}$/i){&set_screen_brightness($params[-1])}
    else{&explain($verb)}
}

sub explain{
    my $verb = $_[0];
    my %explanations = (
        lock     => {order=> 1, text=>'hey gnome lock [the] screen[s]'},
        get      => {order=> 2, text=>'hey gnome get the screen[s] brightness'},
        set      => {order=> 3, text=>'hey gnome set the screen[s] brightness to VALUE'},
        increase => {order=> 4, text=>'hey gnome increase the screen[s] brightness'},
        decrease => {order=> 5, text=>'hey gnome decrease the screen[s] brightness'},
        help     => {order=> 0, text=>'possible verbs: lock, get, set, increase, decrease.'}
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

sub lock_screen{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.ScreenSaver");
    my $obj = $srv->get_object("/org/gnome/ScreenSaver");
    $obj->Lock;
    return 0;
}


sub step_up_screen_brightness{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.SettingsDaemon.Power");
    my $obj = $srv->get_object("/org/gnome/SettingsDaemon/Power",
                                "org.gnome.SettingsDaemon.Power.Screen");
    $obj->StepUp;
    return 0;
}

sub step_down_screen_brightness{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.SettingsDaemon.Power");
    my $obj = $srv->get_object("/org/gnome/SettingsDaemon/Power",
                                "org.gnome.SettingsDaemon.Power.Screen");
    $obj->StepDown;
    return 0;
}

sub get_screen_brightness{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.SettingsDaemon.Power");
    my $obj = $srv->get_object("/org/gnome/SettingsDaemon/Power",
                                "org.freedesktop.DBus.Properties");
    print $obj->Get('org.gnome.SettingsDaemon.Power.Screen','Brightness');
    print "\n";
    return 0;
}

sub set_screen_brightness{
    my $brightness = $_[0];
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.gnome.SettingsDaemon.Power");
    my $obj = $srv->get_object("/org/gnome/SettingsDaemon/Power",
                                "org.freedesktop.DBus.Properties");
    if($brightness > 100){
        warn <<EOF;
Warning: Brightness level exceded 100...
Setting brightness to 100
EOF
        $brightness = 100;
    }
    $brightness = Net::DBus::Binding::Value->new(Net::DBus::Binding::Message::TYPE_INT32,$brightness);
    $obj->Set('org.gnome.SettingsDaemon.Power.Screen','Brightness',$brightness);
    print "\n";
    return 0;
}



return 1;
