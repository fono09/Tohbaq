#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use CGI::Session;
#セッションとかフォーム入力とかとても簡単にする

use Net::Twitter;
# 各種認証とREST_API

use DBI;
=pod
master_idに親垢のidを設定する、master_idがNULLなら親垢
+---------------------+----------+------+-----+---------+----------------+
| Field               | Type     | Null | Key | Default | Extra          |
+---------------------+----------+------+-----+---------+----------------+
| id                  | int(11)  | NO   | PRI | NULL    | auto_increment |
| master_id           | int(11)  | YES  |     | NULL    |                |
| access_token        | tinytext | NO   |     | NULL    |                |
| access_token_secret | tinytext | NO   |     | NULL    |                |
+---------------------+----------+------+-----+---------+----------------+
=cut

use utf8;
use Encode;
#utf-8対応

use XML::Simple;
#設定ファイル用

our $dbh = DBI->connect('DBI:mysql:Tohbaq:localhost:3306','tohbaq','39tanprpr');
#GRANT済みだし外から叩け無いので安心

binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");
binmode(STDERR,":utf8");
$dbh->do("set names utf8");
=pod
お決まりのutf-8対応
=cut

our $argument = $EVN{'QUIERY_STRING'};

my $cgi = new CGI;

my $consumer_key = 
