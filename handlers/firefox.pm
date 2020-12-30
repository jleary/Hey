use warnings;
use strict;
#Note: This uses command line arguments for now as Firefox-ESR in X11 on Debian does not expose 
#DBus functionality 

sub dispatch{
    my $verb   = $_[0];
    my @params = @_[1..$#_];
    my $phrase = join ' ', @_;
    if($phrase =~ /^open new window($|\s.+)/i){
        if($1 ne ''){
            &new_window($1);
        }else{
            &new_window();
        }
    }
    elsif($phrase =~ /^open new tab($|\s.+)/){
        if($1 ne ''){
            &new_tab($1);
        }else{
            &new_tab();
        }
    }
    else{&explain($verb)}
}


sub explain{
    my $verb = $_[0];
    my %explanations = (
        open    => '"hey firefox open new tab [url]" or "hey firefox open new window [url]"',
        default => 'possible verbs: open.'
    );
    print "Usage: ";
    print ($explanations{$verb} or $explanations{'default'});
    print "\n";
    return 4;
}

sub new_window{
    my $url = ($_[0] or '');
    `firefox --new-window "$url"`;
    return 0;
}

sub new_tab{
    my $url = ($_[0] or 'about:blank');
    `firefox --new-tab "$url"`;
    return 0;
}

return 1;
