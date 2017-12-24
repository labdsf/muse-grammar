use v6;
use Muse::Actions;
use Muse::Grammar;
use Test;

my $actions = Muse::Actions.new;

ok  Muse::Grammar.parse("#foo bar", :rule('directive')), 'Simple directive';
nok Muse::Grammar.parse("#foo", :rule('directive')), 'Directive must have a value';
ok  Muse::Grammar.parse("#foo bar\n", :rule('directive')), 'Directive consumes a newline';
nok Muse::Grammar.parse("#foo bar\n\n", :rule('directive')), 'Directive consumes no more than one newline';

ok  Muse::Grammar.parse("#foo bar\n", :rule('directives')), 'Metadata section may consist of one directive';
ok  Muse::Grammar.parse("", :rule('directives')), 'Metadata section may have no directives';
ok  Muse::Grammar.parse("#foo bar\n#name value", :rule('directives')), 'Metadata section may consist of two directives';

my %meta = Muse::Grammar.parse(
q:to/END/
#title Book title
#author Anonymous
END
, :rule('directives'), :actions($actions)).made;
is-deeply {title => 'Book title', author => 'Anonymous'}, %meta, 'Parsing metadata';

ok  Muse::Grammar.parse("\n", :rule('blankline')), 'Completely empty blankline';
ok  Muse::Grammar.parse("", :rule('blankline')), 'The last line in a file is also a blank line';
ok  Muse::Grammar.parse("   \n", :rule('blankline')), 'Blankline may contain spaces';

ok  Muse::Grammar.parse("----", :rule('horizontal_rule')), 'Four dashes is a horizontal rule';
ok  Muse::Grammar.parse("----\n", :rule('horizontal_rule')), 'Horizontal rule consumes a newline';
nok Muse::Grammar.parse("----\n\n", :rule('horizontal_rule')), 'Horizontal rule does not consume blanklines';
nok Muse::Grammar.parse("---", :rule('horizontal_rule')), 'Three dashes is not a horizontal rule';
ok  Muse::Grammar.parse("-----", :rule('horizontal_rule')), 'Five (and more) dashes are allowed in a horizontal rule';
ok  Muse::Grammar.parse("---- ", :rule('horizontal_rule')), 'Whitespace is allowed after horizontal rule';
nok Muse::Grammar.parse(" ----", :rule('horizontal_rule')), 'Whitespace is not allowed before horizontal rule';
nok Muse::Grammar.parse("---- -", :rule('horizontal_rule')), 'No dashes are allowed after horizontal rule whitespace';
is-deeply Muse::Grammar.parse("----", :rule('horizontal_rule'), :actions($actions)).made,
          Muse::Block::HorizontalRule.new(),
          'Parsing horizontal rule as block object';

ok  Muse::Grammar.parse("1", :rule('note_number')), 'Note number can be 1';
nok Muse::Grammar.parse("0", :rule('note_number')), "Note number can't be 0";
ok  Muse::Grammar.parse("20", :rule('note_number')), 'Note number can contain "0"';
nok Muse::Grammar.parse("¹", :rule('note_number')), 'Unicode digits are not allowed in note numbers';

ok  Muse::Grammar.parse("foo", :rule('str')), 'Simple string';
nok Muse::Grammar.parse("foo bar", :rule('str')), "String can't contain whitespace";
is-deeply Muse::Grammar.parse('foo', :rule('str'), :actions($actions)).made,
          Muse::Inline::Str.new(contents => 'foo'), 'Parsing string as inline object';

ok  Muse::Grammar.parse("*foo*", :rule('emph')), 'Emphasis';
ok  Muse::Grammar.parse("**foo**", :rule('strong')), 'Strong';

ok  Muse::Grammar.parse("foo bar", :rule('inlines')), 'Two strings separated by whitespace';

done-testing;
