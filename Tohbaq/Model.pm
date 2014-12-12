
package Tohbaq::Model;
use parent Teng;

sub set_cookie {

	my $self = shift;
	my $cookie = shift;

	print 'Set-Cookie: '. $cookie . "\n";

}

sub set_session {

	my $self = shift;
	my $user_id = shift;
	
	my $session = CGI::Session->new(undef, undef, { Directory => './session' });
	$session->expire('+12h');
	$session->param('id',$user_id);

	$self->set_cookie($cgi->cookie(-name => 'CGISESSID', -value => $session->id));

}

sub get_session {

	my $self = shift;

	my $sid = $cgi->cookie('CGISESSID');
	my $session = CGI::Session->new(undef, $sid, { Directory => './session' });
	
	if(!$session->id){

		$self->redirect("./Tohbaq.cgi");

	}elsif($session->id && !$session->param('id')){

		$session->close;
		$session->delete;
		$self->redirect("./Tohbaq.cgi");

	}

	return $session->param('id');

}


package Tohbaq::Model::Schema;
use Teng::Schema::Declare;
table {

	name 'user';
	pk 'id';
	columns qw( id master access_token access_token_secret );

};
1;
