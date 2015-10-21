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
package RunCommandDriver;
# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use utf8;
use Encode;
use warnings;
use open IO => ':encoding(utf8)';
use ElectricCommander;
use ElectricCommander::PropMod qw(/myProject/libs);
use PuppetHelper;

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

        # To get exit code of process shift right by 8
        my $exitCode = $? >> 8;

        # Set outcome
        setOutcomeFromExitCode($ec, $exitCode);

    }
}
  
main();
