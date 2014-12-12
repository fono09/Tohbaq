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

sub redirect {

	my $self = shift;
	my $url = shift;

	$cgi->redirect(-url => $url);

}
sub top {

	my $self = shift;

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

	my $self = shift;
	my $user_id = shift;
	my $screen_name = shift;

	$self->header;

	
	print "ようこそ、$screen_name さん。今日も爆撃ですか。\n";
	print <<'EOF';
EOF
}

sub error {

	my $self = shift;
	my $message = shift;

	$self->header;
	print <<'EOF';
エラが発生しました。内容は以下のとおりとなります。申し訳ございませんが、初めからやり直す事を推奨します。それでもだめならば、Twitterにて@fono09へご連絡をお願いします。
<hr>
EOF
	print $message;
	$self->footer;

}
