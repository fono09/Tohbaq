
package Tohbaq::Model;
use parent Teng;

package Tohbaq::Model::Schema;
use Teng::Schema::Declare;
table {

	name 'user';
	pk 'id';
	columns qw( id master access_token access_token_secret );

}

1;
