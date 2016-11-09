# AlertHole (alert\_hole) - receive alerts from external vendors/parties and write them to logfiles. 

The purpose of this Perl Mojolicious application is to handle alerts from external sources who is monitoring your applications.

AlertHole only accepts GET requests and checks the caller for a valid pre-agreed UserAgent ID. All non-matching request are denied with a pre-set HTTP 4xx code.

This application is not meant to run as root. Setup a local::lib installation for a dedicated AlertHole user.

# Installation

As root:  
```
useradd -s /bin/bash -d /opt/alerthole -m -c "AlertHole user" alerthole
su - alerthole
```
As the alerthole user:  
```
wget -O- https://cpanmin.us | perl - -l $HOME/perl5 App::cpanminus local::lib && echo 'eval `perl -I $HOME/perl5/lib/perl5 -Mlocal::lib`' >> $HOME/.bash_profile && echo 'export MANPATH=$HOME/perl5/man:$MANPATH' >> $HOME/.bash_profile
. .bash_profile
cpanm Data::Dumper Compress::Raw::Zlib Digest::MD5 Digest::SHA IO::Compress::Gzip Mojolicious
git clone https://github.com/RasmusEdgar/alert_hole.git
```
Test the application (still as the alerthole user):  
```
cd alert_hole
cp alert_hole.conf.example alert_hole.conf
morbo -l http://*:4778 script/alert_hole
```
Check your browser http://\<url/localhost\>:4778

See the nginx conf example and systemd example in the conf dir.

Place alert\_hole.env in /etc/sysconfig/  
Place alert\_hole.service in /usr/lib/systemd/system/  
Run as root:  
```
systemctl daemon-reload
```

## Add a new external vendor to AlertHole

1. In alert\_hole/alert\_hole.conf add user agent string under the ua\_strings nested hash. See alert\_hole.conf.example.
1. Instruct external vendor to call \<url\>/alert/\<msg\> with their preferred method. 

Curl example:  
```
curl --user-agent "TheeTah8quezie0dielieyeSai6zoot9ainootheicahyeuj1iesahdohyoo2Eib" -f https://<url>/alert/test%20test%20test
```  
\<msg\> will be written to logs/alert\_hole-\<vendor\>.log and can be monitored by some internal monitoring application or forwarded to ELK..

## alert\_hole service - hot deployment

If changes have been made to the code, reload hypnotoad as the AlertHole user with:

```
hypnotoad script/alert_hole
```

As root the service may be bumped with systemd:

```
systemctl start alert_hole
```

## Future plans

None at the moment. Pull requests are welcome.
