use v6;
use Text::Muse::Actions;
use Text::Muse::Grammar;
use Test;

ok  Text::Muse::Grammar.parse("#foo bar", :rule('directive')), 'Simple directive';
nok Text::Muse::Grammar.parse("#foo", :rule('directive')), 'Directive must have a value';
ok  Text::Muse::Grammar.parse("#foo bar\n", :rule('directive')), 'Directive consumes a newline';
nok Text::Muse::Grammar.parse("#foo bar\n\n", :rule('directive')), 'Directive consumes no more than one newline';

ok  Text::Muse::Grammar.parse("#foo bar\n", :rule('directives')), 'Metadata section may consist of one directive';
ok  Text::Muse::Grammar.parse("", :rule('directives')), 'Metadata section may have no directives';
ok  Text::Muse::Grammar.parse("#foo bar\n#name value", :rule('directives')), 'Metadata section may consist of two directives';

ok  Text::Muse::Grammar.parse("\n", :rule('blankline')), 'Completely empty blankline';
ok  Text::Muse::Grammar.parse("", :rule('blankline')), 'The last line in a file is also a blank line';
ok  Text::Muse::Grammar.parse("   \n", :rule('blankline')), 'Blankline may contain spaces';

ok  Text::Muse::Grammar.parse("----", :rule('horizontal_rule')), 'Four dashes is a horizontal rule';
ok  Text::Muse::Grammar.parse("----\n", :rule('horizontal_rule')), 'Horizontal rule consumes a newline';
nok Text::Muse::Grammar.parse("----\n\n", :rule('horizontal_rule')), 'Horizontal rule does not consume blanklines';
nok Text::Muse::Grammar.parse("---", :rule('horizontal_rule')), 'Three dashes is not a horizontal rule';
ok  Text::Muse::Grammar.parse("-----", :rule('horizontal_rule')), 'Five (and more) dashes are allowed in a horizontal rule';
ok  Text::Muse::Grammar.parse("---- ", :rule('horizontal_rule')), 'Whitespace is allowed after horizontal rule';
nok Text::Muse::Grammar.parse(" ----", :rule('horizontal_rule')), 'Whitespace is not allowed before horizontal rule';
nok Text::Muse::Grammar.parse("---- -", :rule('horizontal_rule')), 'No dashes are allowed after horizontal rule whitespace';

ok  Text::Muse::Grammar.parse("1", :rule('note_number')), 'Note number can be 1';
nok Text::Muse::Grammar.parse("0", :rule('note_number')), "Note number can't be 0";
ok  Text::Muse::Grammar.parse("20", :rule('note_number')), 'Note number can contain "0"';
nok Text::Muse::Grammar.parse("¹", :rule('note_number')), 'Unicode digits are not allowed in note numbers';

ok  Text::Muse::Grammar.parse("foo", :rule('str')), 'Simple string';
nok Text::Muse::Grammar.parse("foo bar", :rule('str')), "String can't contain whitespace";

ok  Text::Muse::Grammar.parse("*foo*", :rule('emph')), 'Emphasis';
ok  Text::Muse::Grammar.parse("**foo**", :rule('strong')), 'Strong';

ok  Text::Muse::Grammar.parse("foo bar", :rule('inlines')), 'Two strings separated by whitespace';

my $actions = Text::Muse::Actions.new;
my %meta = Text::Muse::Grammar.parse(
q:to/END/
#title Book title
#author Anonymous
END
, :rule('directives'), :actions($actions)).made;
is-deeply {title => 'Book title', author => 'Anonymous'}, %meta, 'Parsing metadata';

done-testing;
