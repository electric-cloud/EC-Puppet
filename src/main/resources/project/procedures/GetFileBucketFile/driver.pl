=head1 NAME

EC-Puppet, REST extention

The file_bucket_file endpoint manages the contents of files in the file bucket. All access to files is managed with the md5 checksum of the file contents, represented as :md5. Where used, :filename means the full absolute path of the file on the client system. This is usually optional and used as an error check to make sure correct file is retrieved. The environment is required in all requests but ignored, as the file bucket does not distinguish between environments.

=head1 DESCRIPTION

Retrieve the contents of a file.

GET /puppet/v3/file_bucket_file/:md5/:original_path?environment=:environment


Copyright 2017 Electric Cloud, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut


# use strict;
use ElectricCommander;
use ElectricCommander::PropMod qw(/myProject/libs);
# use ElectricCommander::PropMod qw(/myProject/modules);

use strict;
use warnings;
use Net::SSL;
use LWP::UserAgent;
# use HTTP::Request::Common qw(GET);

use JSON;

$|++;

sub getProperty {
    my ($ec, $name, $mandatory, $default) = @_;
    my $ret = $ec->getProperty($name)->findvalue('//value')->string_value;
    
    if(!$ret && $mandatory) {
        die "Missing mandatory parameter '$name'.";
    }
    
    return $ret || $default;
}

# get an EC object
my $ec = ElectricCommander->new();
$ec->abortOnError(0);

# Reading the list of the FP
my $puppet_master_url        	= getProperty($ec, "puppet_master_url", 1);
# my $nodename       			 	= getProperty($ec, "nodename", 1);
my $environment                 = getProperty($ec, "environment", 1);
my $md5       					= getProperty($ec, "md5", 1);
my $original_path       		= getProperty($ec, "original_path", 1);
my $destination_path			= getProperty($ec, "destination_path", 1);

# For secure connection variant
my $ca_certificate_path       	= getProperty($ec, "ca_certificate_path", 1);
my $node_certificate_path       = getProperty($ec, "node_certificate_path", 1);
my $private_key_path       		= getProperty($ec, "private_key_path", 1);


print "EC-Puppet:GetBucketFile() - Find\n\n";
print scalar localtime, "\n\n";

# List formal parameters
print "Puppet Master URL: '", $puppet_master_url, "'\n";
# print "Puppet Node: '", $nodename, "'\n";
print "Puppet Environment: '", $environment, "'\n";
print "File MD5: '", $md5, "'\n";
print "Original file path: '", $original_path, "'\n";
print "Destination file path: '", $destination_path, "'\n";

if ($node_certificate_path ne '') {
	print "Path to CA certificate: '", $ca_certificate_path, "'\n";
	print "Path to node certificate: '", $node_certificate_path, "'\n";
	print "Path to private key: '", $private_key_path, "'\n";
}

print "\n\n";

# insecure variant
$ENV{HTTPS_VERSION} = 3;
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

my $ua = LWP::UserAgent->new();

my $url = 'https://' . $puppet_master_url . '/puppet/v3/file_bucket_file/' . $md5 . '/' . $original_path .
		'?environment=' . $environment;

my @ns_headers = (
  'Accept' => 'application/octet-stream',
);

my $res = $ua->get($url, @ns_headers);

# The request to the Puppet server
if ($res->is_success) {
	# payload

	print "Saving file $destination_path\n";

	open FL, '>', $destination_path or die $!;
	print FL $res->content; 
	close FL;

	print "Done\n";

} else {
	# or protocol error
    print $res->status_line . "\n";

    # Error handling
    my $summary = "Connection error, " . $res->status_line;

    $ec->setProperty('/myJobStep/outcome', 'error');
    $ec->setProperty("summary", "$summary\n");
}

print "\n\nDone\n";