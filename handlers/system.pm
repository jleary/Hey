use warnings;
use strict;
use Net::DBus;

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    if($phrase =~ /^(compose|open) (an |((a |)new |))email$/i){&compose_email()}
    elsif($phrase =~ /^open url .*/){&open_url(@params)}
    elsif($phrase =~ /^get max(|imum) keyboard brightness$/){&get_kbd_max_brightness()}
    elsif($phrase =~ /^get keyboard brightness$/){&get_kbd_brightness()}
    elsif($phrase =~ /^set keyboard brightness to \d+$/){&set_kbd_brightness($params[3])}
    else{&explain($verb)}
}

sub explain{
    my $verb = $_[0];
    my %explanations = (
        open    => {order=> 1, text=>"hey system open url http...\nhey system open a new email"},
        compose => {order=> 2, text=>'hey system compose a new email'},
        get     => {order=> 3, text=>'hey system get [max] keyboard brightness'},
        set     => {order=> 4, text=>'hey system set keyboard brightness to VALUE'},
        help    => {order=> 0, text=>'possible verbs: open, get, set, lock, and compose.'}
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


sub open_url{
    my $bus = Net::DBus->find;
    my @params = @_;
    my $srv = $bus->get_service("org.freedesktop.portal.Desktop");
    my $obj = $srv->get_object("/org/freedesktop/portal/desktop");
    $params[1] = "https://" . $params[1] if $params[1] !~ /^http(s|):\/\//;
    $obj->OpenURI('',$params[1],{});
    return 0;
}

sub compose_email{
    my $bus = Net::DBus->find;
    my $srv = $bus->get_service("org.freedesktop.portal.Desktop");
    my $obj = $srv->get_object("/org/freedesktop/portal/desktop",);
    $obj->ComposeEmail('',{});
}

sub get_kbd_max_brightness{
    my $bus = Net::DBus->system;
    my $srv = $bus->get_service("org.freedesktop.UPower");
    my $obj = $srv->get_object("/org/freedesktop/UPower/KbdBacklight", "org.freedesktop.UPower.KbdBacklight");
    print $obj->GetMaxBrightness;
    print "\n";
    return 0;
    
}
sub get_kbd_brightness{
    my $bus = Net::DBus->system;
    my $srv = $bus->get_service("org.freedesktop.UPower");
    my $obj = $srv->get_object("/org/freedesktop/UPower/KbdBacklight", "org.freedesktop.UPower.KbdBacklight");
    print $obj->GetBrightness;
    print "\n";
    return 0;
  }
sub set_kbd_brightness{
    my $brightness = $_[0];
    my $bus = Net::DBus->system;
    my $srv = $bus->get_service("org.freedesktop.UPower");
    my $obj = $srv->get_object("/org/freedesktop/UPower/KbdBacklight", "org.freedesktop.UPower.KbdBacklight");
    my $max_brightness = $obj->GetMaxBrightness;
    if($brightness <= $max_brightness){
        $obj->SetBrightness($brightness);
        return 0;
    }else{
        $obj->SetBrightness($max_brightness);
        warn <<EOF;
Warning: Brightness level given exceeds maximum allowable brightness value...
Setting keyboard backlight to maximum allowable brightness of $max_brightness.
EOF
        return 5;
    }

}

return 1;


