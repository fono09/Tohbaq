#!/usr/bin/perl

use strict;
use warnings;

use KiokuDB;
#ORMをｽﾙﾉﾃﾞｽ

use CGI;
use CGI::Session;
#セッションとかフォーム入力とかとても簡単にする

use Net::Twitter;
# 各種認証とREST_API

use utf8;
use Encode;
#utf-8対応

use XML::Simple;
#設定ファイル用

our $kdb = KiokuDB->connect('dbi:SQLite:dbname=Tohbaq.db');
#KiokuDB使います

binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");
binmode(STDERR,":utf8");
#お決まりのutf-8対応

our $argument = $ENV{'QUIERY_STRING'};

my $cgi = new CGI;




{
	package User;
	use Moose;

	has id => ( is => 'ro', isa => 'Int'); 
	has access_token => ( is => 'ro', isa => 'Str');
	has access_token_secret => ( is => 'ro', isa =>'Str');

}

{

	package MasterUser;
	use Moose;
	use base qw/User/;

	has slave => ( is => 'rw', isa => 'ArrayRef[User]');

}
