EC-Puppet
============

The CloudBees CD Puppet integration

####Prerequisite installation:####
    0.Install puppet agent and puppet master on two independent machines.
    1.Install CloudBees CD Agent on both of them.
      --Failure /lib/ld-linux.so.2: bad ELF interpreter: No such file or directory
        sudo apt-get install lib32bz2-1.0

#####Example(Tested on Ubuntu 14.04):####
0. sudo apt-get install puppet(For puppet agent)
1. sudo apt-get install puppetmaster(For puppet master)

## Compile And Upload ##
0. Install git
   sudo apt-get install git
1. Get this plugin
   git clone https://github.com/electric-cloud/EC-Puppet.git
2. Run gradlew to compile the plugin without running test
   ./gradlew build -x test(Inside EC-Puppet directory)
3. Upload the plugin to EC server

####Required files:####
    1. Create a file called ecplugin.properties inside EC-Puppet directory with the below mentioned contents.
    2. Edit Configurations.json file.

####Contents of ecplugin.properties:####
    COMMANDER_SERVER=<COMMANDER_SERVER>
    COMMANDER_USER=<COMMANDER_USER>
    COMMANDER_PASSWORD=<COMMANDER_PASSWORD>
    PUPPET_AGENT_IP=<PUPPET_AGENT_IP>
    PUPPET_MASTER_IP=<PUPPET_MASTER_IP>

####Contents of Configurations.json:####
    1. Configurations.json is a configurable file.
    2. Refer to the sample Configurations.json file. It has to be updated with the user environment specific arguments.
    3. In this nested JSON file, outer tag is procedure name and inner tags are the arguments for the procedures.

####Run the tests:#####
`./gradlew test`

## Licensing ##
EC-Puppet is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/electric-cloud/EC-Puppet/blob/master/LICENSE) for the full license text.
