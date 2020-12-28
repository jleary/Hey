#!/usr/bin/perl -w
use warnings;
use strict;
use File::DesktopEntry;
use Cwd qw/cwd/;

#Todo:
# [        ]: Implement .desktop launcher using X11::FreeDesktop::DesktopEntry
# [        ]: Use display names instead of desktop file names
# [        ]: Implement "alternate names" and verbs register functions in each PM
# [        ]: Using the aforementioned register function, build a Config::Tiny file that does lookup
# [        ]: Use proper "Hey::ApplicationName" formatted library functionality
# [        ]: Move Lock Screen to Gnome (and use freedesktop for System (even though it doesn't seem to work with gnome)


#Parse ARGV
my $application = $ARGV[0];
my $verb        = '';
my @params      = ();
if($ARGV[1] && $ARGV[1] =~ /^(to|do)$/i && $ARGV[2]) {
    $verb = $ARGV[2];
    @params = @ARGV[3..$#ARGV] if(scalar @ARGV >= 3);
}elsif($ARGV[1]){
    $verb = $ARGV[1]; 
    @params = @ARGV[2..$#ARGV] if(scalar @ARGV >= 2);
}else{
    print "Usage: hey APPLICATION [do] VERB [PARAMETERS]\n" and exit 2;
}
#Dispatch To Proper Handler
$verb = lc $verb;
if($verb =~ /^(launch|run|open)$/ && $application ne 'system'){
    #Handle the launching of .desktop files locally
    my $app = File::DesktopEntry->new($application);
    my $target = '';
        print @params;
    if($verb eq 'open'){
        $target = $params[0];# or print 'Error: File name required' and exit 1;
    }else{
        $target = cwd;
    }
    $app->exec($target) or print "Error: Application not launched.\n" and exit 1;
    exit 0;
}else{
    #Crudely determine which pm to load
    if($application =~ /^[a-zA-Z1-9]$/ && -e "./handlers/" . lc($application) . '.pm'){
        require "./handlers/$application.pm";
        &dispatch($verb,@params);
    }else{
        print "Error: Application interface library not available\n" and exit 2;
    }
}


