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
    label       => "Puppet - ManageCertificatesAndRequests",
    procedure   => "ManageCertificatesAndRequests",
    description => "Manage certificates and requests. Standalone certificate authority. Capable of generating certificates, but mostly     used for signing certificate requests from puppet clients.Because the puppet master service defaults to not signing client certificate          requests, this script is available for signing outstanding requests. It can be used to list outstanding requests and then either sign them      individually or sign all of them.",
    category    => "Resource Management"
);

my %PuppetParser = (
    label       => "Puppet - parser",
    procedure   => "PuppetParser",
    description => "validates Puppet DSL syntax without compiling a catalog or
syncing any resources.",
    category    => "Resource Management"
);

my %PuppetModules = (
    label       => "Puppet - modules",
    procedure   => "PuppetModules",
    description => "Find, install, and manage modules from the Puppet Forge,a repository of user-contributed Puppet code.Also generate empty modules, and prepare locally developed modules for release on the Forge.",
    category    => "Resource Management"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - RunManifest");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - Run Manifest");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - RunCommand");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - Run Command");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - ManageCertificatesAndRequests");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - ManageCertificatesAndRequests");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - PuppetParser");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - PuppetParser");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - PuppetModules");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - PuppetModules");

@::createStepPickerSteps = (\%RunManifest, \%RunCommand, \%ManageCertificatesAndRequests , \%PuppetParser , \%PuppetModules );

