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
    my $master_host =
      ( $ec->getProperty("server") )->findvalue('//value')->string_value;
    my $cert_name =
      ( $ec->getProperty("cert_name") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')->string_value;
    my $debug =
      ( $ec->getProperty("debug") )->findvalue('//value')->string_value;
    my $master_port = "";
    $ec->abortOnError(1);

    my $exitCode = runPuppetAgent($puppet_path, $cert_name, $master_host, $master_port, "1", "", $debug, $additional_options);
    if ( $exitCode == 0 or  $exitCode == 2) {
        my $exitCode = runPuppetAgent($puppet_path, $cert_name, $master_host, $master_port, "", "1", $debug, $additional_options);
    }

    # Set outcome
    setOutcomeFromExitCode( $ec, $exitCode );

}

main();
