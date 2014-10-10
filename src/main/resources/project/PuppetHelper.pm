# -------------------------------------------------------------------------
# Package
#    PuppetHelper.pl
#
#
# Copyright (c) 2014 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------
package PuppetHelper;


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use warnings;
use ElectricCommander;
use Exporter 'import';
our @EXPORT = qw(setOutcomeFromExitCode);

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
    print "Success: No changes applied\n";
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

1;