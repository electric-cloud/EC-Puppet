#
#  Copyright 2015 Electric Cloud, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
package PuppetParser;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use Cwd;
use strict;
use utf8;
use Encode;
use warnings;
use diagnostics;
use open IO => ':encoding(utf8)';
use File::Basename;
use ElectricCommander;
use ElectricCommander::PropMod qw(/myProject/libs);
use PuppetHelper;

$|=1;

$[/myProject/preamble]

# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------
 
###########################################################################
=head2 main
 
  Title    : main
  Usage    : main();
  Function : Runs a manifest into Puppet
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
    my $puppet_path = ( $ec->getProperty("puppet_path") )->findvalue('//value')->string_value;
    my $file_path = ( $ec->getProperty("file_path") )->findvalue('//value')->string_value;
    my $debug = ($ec->getProperty( "debug" ))->findvalue('//value')->string_value;    
    my $verbose_mode = ($ec->getProperty( "verbose_mode" ))->findvalue('//value')->string_value;
    my $format = ($ec->getProperty( "format" ))->findvalue('//value')->string_value;
    my $additional_options = ($ec->getProperty( "additional_options" ))->findvalue('//value')->string_value;
    
    $ec->abortOnError(1);

	#Variable that stores the command to be executed
    my $command = $puppet_path . " parser validate ";

    my @cmd;
    my %props;
    
    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "Puppet parser procedure \n\n";
    
	#Parameters are checked to see which should be included

    if($file_path && $file_path ne '')
    {
        $command = $command .  " " .$file_path;
    }

    if($debug && $debug ne '')
    {
        $command = $command .  " --debug";
    }
    
    if($verbose_mode && $verbose_mode ne '')
    {
        $command = $command . " --verbose";
    }
    
    if($format && $format ne '')
    {
        $command = $command . " --render-as " . $format;
    }

    if($additional_options && $additional_options ne '')
    {
        $command = $command . " " . $additional_options;
    }

    print "Command to be executed: \n$command \n\n";

    #Executes the command into puppet
    system("$command");

    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;

    # Set outcome
    setOutcomeFromExitCode($ec, $exitCode);
        
}
  
main();
