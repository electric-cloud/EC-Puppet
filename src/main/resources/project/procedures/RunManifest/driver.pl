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
package RunManifestDriver;

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

$| = 1;

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
    $::g_puppet_path =
      ( $ec->getProperty("puppet_path") )->findvalue('//value')->string_value;
    $::g_manifest_type =
      ( $ec->getProperty("manifest_type") )->findvalue('//value')->string_value;
    $::g_manifest =
      ( $ec->getProperty("manifest") )->findvalue('//value')->string_value;
    $::g_debug =
      ( $ec->getProperty("debug") )->findvalue('//value')->string_value;
    $::g_verbose_mode =
      ( $ec->getProperty("verbose_mode") )->findvalue('//value')->string_value;
    $::g_noop =
      ( $ec->getProperty("noop") )->findvalue('//value')->string_value;
    $::g_additional_commands =
      ( $ec->getProperty("additional_commands") )->findvalue('//value')
      ->string_value;

    #Variable that stores the command to be executed
    $::g_command = $::g_puppet_path . " apply";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "Run Manifest procedure \n\n";

    #Parameters are checked to see which should be included
    if ( $::g_debug && $::g_debug ne '' ) {
        $::g_command = $::g_command . " --debug";
    }

    if ( $::g_verbose_mode && $::g_verbose_mode ne '' ) {
        $::g_command = $::g_command . " --verbose";
    }

    if ( $::g_noop && $::g_noop ne '' ) {
        $::g_command = $::g_command . " --noop";
    }

    if ( $::g_additional_commands && $::g_additional_commands ne '' ) {
        $::g_command = $::g_command . " " . $::g_additional_commands;
    }

    if ( $::g_manifest_type eq "file" ) {
        $::g_command = $::g_command . " " . $::g_manifest;

        print "Command to be executed: \n$::g_command \n\n";

        # Executes the command into puppet
        system("$::g_command");

        # To get exit code of process shift right by 8
        my $exitCode = $? >> 8;

        # Set outcome
        setOutcomeFromExitCode( $ec, $exitCode );
    }
    else {
#A time stamp is created in order to give a unique identifier at the file that is created
        my $timeStampData = time();
        my $file_name     = 'puppet_manifest_' . $timeStampData . '.pp';

#A new file is created and the content specified in the parameter $::g_manifest is written into the file

        open( MYFILE, ">>$file_name" );
        print MYFILE "$::g_manifest";
        close(MYFILE);

        $::g_command .= " " . $file_name;
        print "Command to be executed: \n$::g_command \n\n";

        print "Text Area Value: \n$::g_manifest \n\n";

        #Executes the command into puppet
        system("$::g_command");

        # To get exit code of process shift right by 8
        my $exitCode = $? >> 8;

        # Set outcome
        setOutcomeFromExitCode( $ec, $exitCode );

        #In case the generated file must be removed this line must be enabled
        #system("rm $file_name");
    }
}

main();
