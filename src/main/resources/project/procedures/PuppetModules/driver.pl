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
package PuppetModules;

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
    my $puppet_path =
      ( $ec->getProperty("puppet_path") )->findvalue('//value')->string_value;
    my $action =
      ( $ec->getProperty("action") )->findvalue('//value')->string_value;
    my $module_name =
      ( $ec->getProperty("module_name") )->findvalue('//value')->string_value;
    my $force =
      ( $ec->getProperty("force") )->findvalue('//value')->string_value;
    my $debug =
      ( $ec->getProperty("debug") )->findvalue('//value')->string_value;
    my $ignore_dependencies =
      ( $ec->getProperty("ignore_dependencies") )->findvalue('//value')
      ->string_value;
    my $module_path =
      ( $ec->getProperty("module_path") )->findvalue('//value')->string_value;
    my $environment =
      ( $ec->getProperty("environment") )->findvalue('//value')->string_value;
    my $render_as =
      ( $ec->getProperty("render_as") )->findvalue('//value')->string_value;
    my $ignore_changes =
      ( $ec->getProperty("ignore_changes") )->findvalue('//value')
      ->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;

    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = $puppet_path . " module";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "Perform puppet module operations \n\n";

    #Parameters are checked to see which should be included
    if ( $action && $action ne '' ) {
        $command = $command . " " . $action;
    }

    if ( $module_path && $module_path ne '' ) {
        $command = $command . " --target-dir " . $module_path;
    }

    if ( $module_name && $module_name ne '' ) {
        $command = $command . " " . $module_name;
    }

    if ( $debug && $debug ne '' ) {
        $command = $command . " --debug";
    }

    if ( $force && $force ne '' ) {
        $command = $command . " --force";
    }

    if ( $ignore_dependencies && $ignore_dependencies ne '' ) {
        $command = $command . " --ignore-dependencies";
    }

    if ( $ignore_changes && $ignore_changes ne '' ) {
        $command = $command . " --ignore-changes";
    }

    if ( $render_as && $render_as ne '' ) {
        $command = $command . " --render-as " . $render_as;
    }

    if ( $environment && $environment ne '' ) {
        $command = $command . " --environment " . $environment;
    }

    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    print "Command to be executed: \n$command \n\n";

    # Executes the command into puppet
    system("$command");

    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;

    # Set outcome
    setOutcomeFromExitCode( $ec, $exitCode );
}
main();
