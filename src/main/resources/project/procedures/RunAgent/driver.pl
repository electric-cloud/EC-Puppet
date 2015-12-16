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
    my $daemonize =
      ( $ec->getProperty("daemonize") )->findvalue('//value')->string_value;
    my $no_daemonize =
      ( $ec->getProperty("no_daemonize") )->findvalue('//value')->string_value;
    my $certname =
      ( $ec->getProperty("certname") )->findvalue('//value')->string_value;
    my $waitforcert =
      ( $ec->getProperty("waitforcert") )->findvalue('//value')->string_value;
    my $disable_message =
      ( $ec->getProperty("disable") )->findvalue('//value')->string_value;
    my $logdest =
      ( $ec->getProperty("logdest") )->findvalue('//value')->string_value;
    my $masterport =
      ( $ec->getProperty("masterport") )->findvalue('//value')->string_value;
    my $detailed_exitcodes =
      ( $ec->getProperty("detailed_exitcodes") )->findvalue('//value')
      ->string_value;
    my $enable =
      ( $ec->getProperty("enable") )->findvalue('//value')->string_value;
    my $fingerprint =
      ( $ec->getProperty("fingerprint") )->findvalue('//value')->string_value;
    my $no_client =
      ( $ec->getProperty("no_client") )->findvalue('//value')->string_value;
    my $noop = ( $ec->getProperty("noop") )->findvalue('//value')->string_value;
    my $test = ( $ec->getProperty("test") )->findvalue('//value')->string_value;
    my $onetime =
      ( $ec->getProperty("onetime") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;
    my $digest =
      ( $ec->getProperty("digest") )->findvalue('//value')->string_value;
    my $debug =
      ( $ec->getProperty("debug") )->findvalue('//value')->string_value;
    my $help = ( $ec->getProperty("help") )->findvalue('//value')->string_value;
    my $verbose =
      ( $ec->getProperty("verbose") )->findvalue('//value')->string_value;
    my $version =
      ( $ec->getProperty("version") )->findvalue('//value')->string_value;

    $ec->abortOnError(1);

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    print "EC-Puppet: ";
    print "RunAgent procedure \n\n";

    #Parameters are checked to see which should be included
    my $command = $puppet_path . " agent";

    #Variable that stores the command to be executed
    if ( $daemonize && $daemonize ne '' ) {
        $command = $command . " --daemonize";
    }
    if ( $no_daemonize && $no_daemonize ne '' ) {
        $command = $command . " --no-daemonize";
    }
    if ( $certname && $certname ne '' ) {
        $command = $command . " --certname " . $certname;
    }
    if ( $waitforcert && $waitforcert ne '' ) {
        $command = $command . " --waitforcert " . $waitforcert;
    }
    if ( $disable_message && $disable_message ne '' ) {
        $command = $command . " --disable " . $disable_message;
    }
    if ( $logdest && $logdest ne '' ) {
        $command = $command . " --logdest " . $logdest;
    }
    if ( $masterport && $masterport ne '' ) {
        $command = $command . " --masterport " . $masterport;
    }
    if ( $detailed_exitcodes && $detailed_exitcodes ne '' ) {
        $command = $command . " --detailed-exitcodes";
    }
    if ( $enable && $enable ne '' ) {
        $command = $command . " --enable";
    }
    if ( $fingerprint && $fingerprint ne '' ) {
        $command = $command . " --fingerprint";
    }
    if ( $no_client && $no_client ne '' ) {
        $command = $command . " --no-client";
    }
    if ( $noop && $noop ne '' ) {
        $command = $command . " --noop";
    }
    if ( $test && $test ne '' ) {
        $command = $command . " --test";
    }
    if ( $onetime && $onetime ) {
        $command = $command . " --onetime";
    }
    if ( $digest && $digest ne '' ) {
        $command = $command . " --digest " . $digest;
    }
    if ( $debug && $debug ne '' ) {
        $command = $command . " --debug";
    }
    if ( $help && $help ne '' ) {
        $command = $command . " --help";
    }
    if ( $verbose && $verbose ne '' ) {
        $command = $command . " --verbose";
    }
    if ( $version && &version ne '' ) {
        $command = $command . " --version";
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
