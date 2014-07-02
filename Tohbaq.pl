#!/usr/bin/perl

use strict;
use warnings;

use Net::Twitter;

use AnyEvent::Twitter::Stream;

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

our $dbh = DBI->connect('DBI:mysql:Tohbaq:localhost:3306','tohbaq','39tanprpr');
#GRANT済みだし外から叩け無いので安心

binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");
binmode(STDERR,":utf8");
$dbh->do("set names utf8");
=pod
お決まりのutf-8対応
=cut

