my $MIN_PUPPET_VERSION_SUPPORTED = '3.5.0';
check_puppet_version();

sub check_puppet_version {
    return 1 if $ENV{EC_MOCK};
    my $ec_temp = ElectricCommander->new();
    $ec_temp->abortOnError(0);
    my $puppet_path =
        ( $ec_temp->getProperty("puppet_path") )->findvalue('//value')->string_value;
    if ($puppet_path && -e $puppet_path) {
        my $cmd = $puppet_path . ' --version';
        my $res = `$cmd`;
        unless ($res ge $MIN_PUPPET_VERSION_SUPPORTED) {
            print "Minimum puppet version supported is: $MIN_PUPPET_VERSION_SUPPORTED, you have: $res\n";
            exit 1;
        }
    }
    return 1;
}

