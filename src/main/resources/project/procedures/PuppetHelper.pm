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
package PuppetHelper;
# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use warnings;
use ElectricCommander;
use Exporter 'import';
our @EXPORT = qw(setOutcomeFromExitCode runPuppetAgent);

$|=1;

###########################################################################
=head2 setOutcomeFromExitCode

  Title    : setOutcomeFromExitCode
  Usage    : setOutcomeFromExitCode($exitCode);
  Function : Set outcome based on exit code
  Returns  :
  Args     : named arguments: ElectricCommander object, exitCode
=cut
###########################################################################

sub setOutcomeFromExitCode {

  my ($ec, $exitCode) = @_;
  print "puppet returned exit code: $exitCode\n";

  # More details here
  # https://docs.puppetlabs.com/references/3.7.0/man/apply.html
  if ( $exitCode == 0 ) {
    # print "Success: No changes applied\n";
  } elsif ($exitCode == 2){
    print "Success: Changes applied\n";
  } else {
    # Exit codes 4 and 6 are well defined so we could report a specific error for them.
	# However there appear to be other valid exit codes (1, for manifest parsing errors)
	# We can look at puppet source if this becomes an issue, for now just set the outcome
	# as error.
    $ec->setProperty("outcome","error");
  }


}

sub runPuppetAgent {

   my ($puppet_path, $cert_name, $master_host, $master_port, $enable, $test, $debug, $additional_options) = @_;

    my $ec = ElectricCommander->new();
    $ec->abortOnError(1);

    my @cmd;
    my %props;

    #Parameters are checked to see which should be included
    my $command = $puppet_path . " agent";

    #Variable that stores the command to be executed
    if ( $cert_name ne '' ) {
        $command = $command . " --certname " . $cert_name;
    }
    if ( $master_host ne '' ) {
        $command = $command . " --server " . $master_host;
    }
    if ( $master_port ne '' ) {
        $command = $command . " --masterport " . $master_port;
    }
    if ( $enable eq '1' ) {
        $command = $command . " --enable";
    }
    if ( $test eq '1' ) {
        $command = $command . " --test";
    }
    if ( $debug eq '1' ) {
        $command = $command . " --debug";
    }
    if ( $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }
    print "Command to be executed: \n$command \n\n";

    #Executes the command into puppet
    system("$command");

    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;

    return $exitCode;

}


1;