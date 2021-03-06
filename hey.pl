#!/usr/bin/perl -w
use warnings;
use strict;
use File::DesktopEntry;
use Cwd qw/cwd/;
use FindBin qw/$RealBin/;




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
if($verb =~ /^(launch|run|open)$/ && $application ne 'system' && join(' ',@params)!~ /^new( | .+ )(window|tab)/ ){
    #Handle the launching of .desktop files locally
    my $target = '';
    if($verb eq 'open'){
        $target = $params[0];# or print 'Error: File name required' and exit 1;
    }
    
   
    if(`which gtk-launch`){
        `gtk-launch $application $target`;
    }else{
        my $app = File::DesktopEntry->new($application);
        $target = cwd if $verb eq 'open';
        $app->exec($target) or print "Error: Application not launched. $!\n" and exit 1;
    }
    exit 0;
}else{
    #Crudely determine which pm to load
    if($application =~ /^[a-zA-Z1-9]+$/ && -e "$RealBin/handlers/" . lc($application) . '.pm'){
        require "$RealBin/handlers/".lc($application).".pm";
        &dispatch($verb,@params);
    }else{
        print "Error: Application interface library not available\n" and exit 2;
    }
}


