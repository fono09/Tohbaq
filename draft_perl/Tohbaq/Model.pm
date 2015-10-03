
package Tohbaq::Model;
use parent Teng;
use CGI;
use CGI::Session;
use Tohbaq::View;

our $cgi = new CGI;
our $view = Tohbaq::View->new;

sub param {

	my $self = shift;
	my $param = shift;

	return $cgi->param($param);

}

sub set_cookie {

	my $self = shift;
	my $name = shift;
	my $value = shift;

	
	print 'Set-Cookie: '. $cgi->cookie(
		-name => $name,
		-value => $value,
	) . "\n";

}

sub cookie {

	my $self = shift;
	my $param = shift;
	
	return $cgi->cookie($param);


}
sub set_session {

	my $self = shift;
	my $user_id = shift;
	my $screen_name = shift;
	
	my $session = CGI::Session->new(undef, undef, { Directory => './session' });
	$session->expire('+12h');
	$session->param('id',$user_id);
	$session->param('screen_name',$screen_name);

	$self->set_cookie('CGISESSID',$session->id);

}

sub session {

	my $self = shift;
	my $redirect = shift;

	my $sid = $self->cookie('CGISESSID');
	my $session = CGI::Session->new(undef, $sid, { Directory => './session' });
	
	my $id = $session->param('id');
	my $screen_name = $session->param('screen_name');

	if($redirect == 1  && (!defined($id) || !defined($screen_name))){

		$session->close;
		$session->delete;
		$view->redirect("./Tohbaq.cgi");

	}

	return ($session->param('id'),$session->param('screen_name'));

}


package Tohbaq::Model::Schema;
use Teng::Schema::Declare;
table {

	name 'user';
	pk 'id';
	columns qw( id screen_name master access_token access_token_secret );

};
1;
