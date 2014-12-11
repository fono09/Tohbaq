package Tohbaq::View;
use Moose;
use CGI;
use CGI::Session;

my $cgi = CGI->new;

sub header {

	my $self = shift;
	print "Content-type: text/html\n\n";
	print <<'EOF';
<!--#set var="data" value="Tohbaq<>統合爆撃ツールを使う<>FONO,Tohbaq" -->
<!--#include virtual="/main.files/header.cgi" -->
EOF

}

sub footer {

	my $self = shift;
	print <<'EOF';
<!--#include virtual="/main.files/tools.cgi" -->
EOF

}

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

sub redirect {

	my $self = shift;
	my $url = shift;

	$cgi->redirect(-url => $url);

}
sub top {

	$self = shift;

	$self->header;
	print <<'EOF';
使いたい方はこちらへどうぞ→<a href="./Tohbaq.cgi?mode=login">ログイン</a>
<hr>
このツールは、複数アカウントの並列処理に対応した統合爆撃ツールです。
つまり間髪入れず雨霰のようにツイートを振りまくことができます。
後は何も言わなくてもわかると思いますので特にコメントしません。
<em>尚、このツールを使用したことにより被ったいかなる損失に関しても
作者は補償しかねますので、予めご了承ください。</em>
<hr>
それでも使いたい人はどうぞ→<a href="./Tohbaq.cgi?mode=login">ログイン</a>
EOF
	$self->footer;

}

sub menu {

	$self = shift;
	$user_id = shift;
	$screen_name = shift;

	$self->header;

	
	print "ようこそ、$screen_name さん。今日も爆撃ですか。\n";
	print <<'EOF';
EOF
}

sub error {

	$self = shift;
	$message = shift;

	$self->header;
	print <<'EOF';
エラが発生しました。内容は以下のとおりとなります。申し訳ございませんが、初めからやり直す事を推奨します。それでもだめならば、Twitterにて@fono09へご連絡をお願いします。
<hr>
EOF
	print $message;
	$self->footer;

}
