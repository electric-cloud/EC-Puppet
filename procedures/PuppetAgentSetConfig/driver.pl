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

$| = 1;

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
    my $puppet_path =
      ( $ec->getProperty("puppet_path") )->findvalue('//value')->string_value;
    my $cert_name =
      ( $ec->getProperty("cert_name") )->findvalue('//value')->string_value;
    my $server =
      ( $ec->getProperty("server") )->findvalue('//value')->string_value;
    my $environment =
      ( $ec->getProperty("environment") )->findvalue('//value')->string_value;
	my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')->string_value;  
  
	$ec->abortOnError(1);

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "PuppetConfigSet procedure \n\n";

    #Parameters are checked to see which should be included
    my $command = $puppet_path . " config set";
	
	#Variable that stores the command to be executed
    if ( $cert_name && $cert_name ne '' ) {
        $command = $command . " certname " .$cert_name ." --section agent";
		print "Command to be executed: \n$command \n\n";
		system("$command");
    }
	elsif ( $server && $server ne '' ) {
        $command = $command . " server " .$server ." --section agent";
		print "Command to be executed: \n$command \n\n";
		system("$command");
    }
	elsif ( $environment && $environment ne '' ) {
        $command = $command . " environment " .$environment ." --section agent";
		print "Command to be executed: \n$command \n\n";
		system("$command");
    }
	#elsif ( $additional_options && $additional_options ne '' ) {
        # $command = $command . " --environment" .$additional_options ." --section agent";
		# print "Command to be executed: \n$command \n\n";
		# system("$command");    }

    #Executes the command into puppet
   ## system("$command");

    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;

    # Set outcome
    setOutcomeFromExitCode( $ec, $exitCode );

}

main();
