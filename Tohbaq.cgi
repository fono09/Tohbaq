#!/usr/bin/perl

use strict;
use warnings;

use Tohbaq::Model;
use Tohbaq::View;

use CGI;
use CGI::Session;
use Net::Twitter;
use Encode;
use XML::Simple;
use utf8;


my $cgi = CGI->new;

my $xml_ref = XMLin('./settings.xml');
my $nt = Net::Twitter->new(
	traits => [qw/ API::RESTv1_1/],
	consumer_key => $xml_ref->{consumer_key},
	consumer_secret => $xml_ref->{consumer_secret},
	ssl => 1,
);
my $model = Tohbaq::Model->new( { connect_info => [ 'dbi:SQLite:dbname=Tohbaq.db' ], AutoCommit => 1, sqlite_unicode=>1 } );
my $view = Tohbaq::View->new;

my $mode = $model->param('mode');
my $add_slave = $model->param('add_slave');

if(!defined $mode){

	$model->session(1);
	$view->top;

}elsif($mode eq 'login'){
	

	my $callback = 'http://fono.jp/twiapps/Tohbaq/Tohbaq.cgi?mode=callback';
	$callback .= '&add_slave=true' if defined($add_slave);

	my $url = $nt->get_authorization_url(
		callback => $callback,
	);

	$model->set_cookie('request_token',$nt->request_token);
	$model->set_cookie('request_token_secret',$nt->request_token_secret);

	print $view->redirect($url);

}elsif($mode = 'callback'){

	my $oauth_token = $model->param('oauth_token');
	my $oauth_verifier = $model->param('oauth_verifier');

	$nt->request_token($model->cookie('request_token'));
	$nt->request_token_secret($model->cookie('request_token_secret'));

	my ($access_token, $access_token_secret, $id, $screen_name) = $nt->request_access_token(verifier => $oauth_verifier);

	my $user = $model->single('user',{ id => $id });

	if(defined($user) && defined($user->master)){

		$view->error("このアカウントは既に「子アカウント」としての登録があります");
		
		
	}elsif(!defined($user) && defined($add_slave)){

		my ($master_id,$master_screen_name) = $model->session;
		my $master = $model->single('user',{ id => $master_id });

		$model->insert('user',
		{
			id => $id,
			screen_name => $screen_name,
			master => $master->id,
			access_token => $access_token,
			access_token_secret => $access_token_secret,
		});

		$id = $master->id;
		$screen_name = $master_screen_name;

	}elsif(!defined($user)){

		$model->insert('user',
		{
			id => $id,
			screen_name => $screen_name,
			access_token => $access_token,
			access_token_secret => $access_token_secret,

		});

	}
	
	my @slave = $model->search('user', { master => $id }, { order_by => 'master' });
	my @slave_list = map { \($_->id,$_->screen_name) } @slave;

	$model->set_session($id,$screen_name);
	$view->menu($id,$screen_name,@slave_list);

}
