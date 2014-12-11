#!/usr/bin/perl

use strict;
use warnings;

use Tohbaq::Model;
use CGI;
use CGI::Session;
use Net::Twitter;
use Encode;
use XML::Simple;
use utf8;
binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");
binmode(STDERR,":utf8");


my $cgi = CGI->new;

my $xml_ref = XMLin('./settings.xml');
my $nt = Net::Twitter->new(
	traits => [qw( API::RESTv1_1 OAuth )],
	consumer_key => $xml_ref->{consumer_key},
	consumer_secret => $xml_ref->{consumer_secret},
	ssl => 1,
);
my $db = Tohbaq::Model->new( { connect_info => [ 'dbi:SQLite:Tohbaq.db' ] } );
my $view = Tohbaq::View->new;

my $mode = $cgi->param('mode');
if(!defined $mode){

	$view->top;

}elsif($mode eq 'login'){

	my $url = $nt->get_authorization_url(
		callback => 'http://fono.jp/twiapps/Tohbaq/Tohbaq.cgi?mode=callback',
	);

	my @cookies;	
	push(@cookies,$cgi->cookie(
		-name => 'request_token',
		-value => $nt->request_token,
	));
	push(@cookies,$cgi->cookie(
		-name => 'request_token_secret',
		-value => $nt->request_token_secret,
	));

	map { $view->set_cookie($_) } @cookies;
	print $view->redirect($url);

}elsif($mode = 'callback'){

	my $oauth_token = $cgi->param('oauth_token');
	my $oauth_verifier = $cgi->param('oauth_verifier');

	$nt->request_token($cgi->cookie('request_token'));
	$nt->request_token_secret($cgi->cookie('request_token_secret'));

	my ($access_token, $access_token_secret, $user_id, $screen_name) = $nt->request_access_token(verifier => $oauth_verifier);

	my $user = $db->single('user',{ id => $user_id });

	if(defined($user) && defined($user->master)){

		$view->error("このアカウントは既に「子アカウント」としての登録があります");
		
	}elsif(defined($user) && !defined($user->master)){
	
		$view->set_session($user_id,$screen_name);
		$view->menu($user_id,$screen_name);

	}elsif(!defined($user)){

		$db->insert('user',
		{
			id => 1,
			access_token => $access_token;
			access_token_secret => $access_token_secret;

		});

		$view->menu($user_id,$screen_name);

	}

}elsif($mode = 'add_login'){

	$view->get_session;
	


	
}
