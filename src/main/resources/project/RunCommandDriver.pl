# -------------------------------------------------------------------------
# Package
#    RunCommandDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Perl script to create run a command on Puppet
#
# Date
#    07/05/2012
#
# Engineer
#    Mario Carmona
#
# Copyright (c) 2012 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------
package RunCommandDriver;


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use Cwd;
use Carp;
use strict;
use Data::Dumper;
use utf8;
use Encode;
use warnings;
use diagnostics;
use open IO => ':encoding(utf8)';
use File::Basename;
use ElectricCommander;
use ElectricCommander::PropDB;
use ElectricCommander::PropMod;

$|=1;

# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------
 
###########################################################################
=head2 main
 
  Title    : main
  Usage    : main();
  Function : Runs a command into Puppet
  Returns  : none
  Args     : named arguments: none
=cut
###########################################################################

sub main {
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    
    # -------------------------------------------------------------------------
    # Parameters
    # -------------------------------------------------------------------------
    $::g_puppet_path = ($ec->getProperty( "puppet_path" ))->findvalue('//value')->string_value;
    $::g_puppet_command = ($ec->getProperty( "puppet_command" ))->findvalue('//value')->string_value;

    
    my @cmd;
    my %props;
    
    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "Run Command procedure \n\n";
    
	#Parameters are checked to see which should be included
    if($::g_puppet_path && $::g_puppet_path ne '' && $::g_puppet_command && $::g_puppet_command ne '')
    {
        	#Variable that stores the command to be executed
		$::g_command = $::g_puppet_path . " " .$::g_puppet_command;
	
		print "Command to be executed: \n$::g_command \n\n";
        
		#Executes the command into puppet
		system("$::g_command");
        # Set outcome
        if ($? != 0){ $ec->setProperty("outcome","error"); }
    }
}
  
main();
