#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'CPANMonitor';
all_from 'lib/CPANMonitor.pm';

requires 'Catalyst::Runtime' => '5.90011';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats


requires 'StackTrace';

requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::SanitizeUrl';

requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Session::State::Cookie';

requires 'Catalyst::Plugin::StatusMessage';
requires 'Catalyst::Plugin::SmartURI';

requires 'Log::AutoDump';
requires 'CatalystX::Controller::Auth';
requires 'Catalyst::View::XML::Feed';
requires 'Email::MIME::Kit';
requires 'Email::MIME::Kit::Renderer::TT';

test_requires 'Test::More' => '0.88';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;

