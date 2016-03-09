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

my %ConfigureAgent = (
    label       => "Puppet- Configure Agent",
    procedure   => "ConfigureAgent",
    description => "Used by the dynamic environment feature to configure the Puppet agent on the provisioned resource. Retrieves the client configuration from the Puppet Master and applies it to the resource based on the environment specified.",
    category    => "Resource Management"
);

my %RunManifest = (
    label       => "Puppet - Run Manifest",
    procedure   => "RunManifest",
    description => "Run a manifest file into Puppet",
    category    => "Resource Management"
);

my %RunCommand = (
    label       => "Puppet - Run Command",
    procedure   => "RunCommand",
    description => "Run a command into Puppet",
    category    => "Resource Management"
);

my %ManageCertificatesAndRequests = (
    label     => "Puppet - Manage Certificates And Requests",
    procedure => "ManageCertificatesAndRequests",
    description =>
"Manage certificates and requests. Standalone certificate authority. Capable of generating certificates, but mostly     used for signing certificate requests from puppet clients.Because the puppet master service defaults to not signing client certificate          requests, this script is available for signing outstanding requests. It can be used to list outstanding requests and then either sign them      individually or sign all of them.",
    category => "Resource Management"
);
my %DeleteAgent = (
    label     => "Puppet - Delete Agent",
    procedure => "DeleteAgent",
    description =>"Deleting Agent.",
    category => "Resource Management"
);
my %PuppetParser = (
    label       => "Puppet - Parser",
    procedure   => "PuppetParser",
    description => "validates Puppet DSL syntax without compiling a catalog or
syncing any resources.",
    category => "Resource Management"
);

my %PuppetModules = (
    label     => "Puppet - Modules",
    procedure => "PuppetModules",
    description =>
"Find, install, and manage modules from the Puppet Forge,a repository of user-contributed Puppet code.Also generate empty modules, and prepare locally developed modules for release on the Forge.",
    category => "Resource Management"
);

my %PuppetLint = (
    label       => "Puppet - Lint",
    procedure   => "PuppetLint",
    description => "Puppet linting",
    category    => "Resource Management"
);

my %PuppetUnitTest = (
    label       => "Puppet - Unit Test",
    procedure   => "PuppetUnitTest",
    description => "Puppet Unit Testing with rspec",
    category    => "Resource Management"
);

my %RunAgent = (
    label       => "Puppet- Run Agent",
    procedure   => "RunAgent",
    description => "Puppet run agent",
    category    => "Resource Management"
);

my %PuppetVersion = (
    label       => "Puppet - Version",
    procedure   => "PuppetVersion",
    description => "Puppet version",
    category    => "Resource Management"
);
my %UpdateAgentConfiguration = (
    label       => "Puppet - UpdateAgentConfiguration",
    procedure   => "UpdateAgentConfiguration",
    description => "Puppet configuration set up for Agent",
    category    => "Resource Management"
);

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - RunManifest");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - Run Manifest");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - RunCommand");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - Run Command");

$batch->deleteProperty(
"/server/ec_customEditors/pickerStep/EC-Puppet - ManageCertificatesAndRequests"
);
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - ManageCertificatesAndRequests"
);
$batch->deleteProperty(
"/server/ec_customEditors/pickerStep/EC-Puppet - DeleteAgent"
);
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - DeleteAgent"
);
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - PuppetParser");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - PuppetParser");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - PuppetModules");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - PuppetModules");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - PuppetLint");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - PuppetLint");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - PuppetUnitTest");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - PuppetUnitTest");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - PuppetVersion");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - PuppetVersion");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - RunAgent");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - RunAgent");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - ConfigureAgent");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - ConfigureAgent");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Puppet - UpdateAgentConfiguration");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Puppet - UpdateAgentConfiguration");

@::createStepPickerSteps = (
    \%RunManifest,                   \%RunCommand,
    \%ManageCertificatesAndRequests, \%PuppetParser,
    \%PuppetModules,                 \%PuppetLint,
    \%PuppetUnitTest,                \%PuppetVersion,
    \%RunAgent,                      \%ConfigureAgent,
	\%UpdateAgentConfiguration,		 \%DeleteAgent,
);

