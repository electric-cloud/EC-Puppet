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
    my $file_path =
      ( $ec->getProperty("file_path") )->findvalue('//value')->string_value;
    my $config_file =
      ( $ec->getProperty("config_file") )->findvalue('//value')->string_value;
    my $checks_file =
      ( $ec->getProperty("checks_file") )->findvalue('//value')->string_value;
    my $error_level =
      ( $ec->getProperty("error_level") )->findvalue('//value')->string_value;
    my $format =
      ( $ec->getProperty("format") )->findvalue('//value')->string_value;
    my $with_context =
      ( $ec->getProperty("with_context") )->findvalue('//value')->string_value;
    my $with_filename =
      ( $ec->getProperty("with_filename") )->findvalue('//value')->string_value;
    my $fail_on_warnings =
      ( $ec->getProperty("fail_on_warnings") )->findvalue('//value')
      ->string_value;
    my $show_ignored =
      ( $ec->getProperty("show_ignored") )->findvalue('//value')->string_value;
    my $relative =
      ( $ec->getProperty("relative") )->findvalue('//value')->string_value;
    my $fix = ( $ec->getProperty("fix") )->findvalue('//value')->string_value;
    my $only_checks =
      ( $ec->getProperty("only_checks") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;

    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = " puppet-lint ";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "Puppet lint procedure \n\n";

    #Parameters are checked to see which should be included
    if ( $file_path && $file_path ne '' ) {
        $command = $command . " " . $file_path;
    }

    if ( $config_file && $config_file ne '' ) {
        $command = $command . " --config " . $config_file;
    }

    if ( $checks_file && $checks_file ne '' ) {
        $command = $command . " --load " . $checks_file;
    }

    if ( $error_level && $error_level ne '' ) {
        $command = $command . " --error-level " . $error_level;
    }

    if ( $format && $format ne '' ) {
        $command = $command . " --log-format " . $format;
    }

    if ( $with_context && $with_context ne '' ) {
        $command = $command . " --with-context ";
    }

    if ( $with_filename && $with_filename ne '' ) {
        $command = $command . " --with-filename ";
    }

    if ( $fail_on_warnings && $fail_on_warnings ne '' ) {
        $command = $command . " --fail-on-warnings ";
    }

    if ( $show_ignored && $show_ignored ne '' ) {
        $command = $command . " --show-ignored ";
    }

    if ( $relative && $relative ne '' ) {
        $command = $command . " --relative ";
    }

    if ( $fix && $fix ne '' ) {
        $command = $command . " --fix ";
    }

    if ( $only_checks && $only_checks ne '' ) {
        $command = $command . " --only-checks " . $only_checks;
    }

    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    print "Command to be executed: \n$command \n\n";

    #Executes the command into puppet
    system("$command");

    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;

    # Set outcome
    setOutcomeFromExitCode( $ec, $exitCode );

}

main();
