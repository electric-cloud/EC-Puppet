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

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - RunManifest");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - Run Manifest");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Puppet - RunCommand");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Puppet - Run Command");

@::createStepPickerSteps = (\%RunManifest, \%RunCommand);

