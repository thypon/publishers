# typed: strict

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `raabro` gem.
# Please instead update this file by running `bin/tapioca gem raabro`.

module Raabro
  extend ::Raabro::ModuleMethods

  class << self
    def included(target); end
    def pp(tree, depth = T.unsafe(nil), opts = T.unsafe(nil)); end
  end
end

class Raabro::Input
  def initialize(string, offset = T.unsafe(nil), options = T.unsafe(nil)); end

  def at(i); end
  def match(str_or_regex); end
  def offset; end
  def offset=(_arg0); end
  def options; end
  def string; end
  def string=(_arg0); end
  def tring(l = T.unsafe(nil)); end
end

module Raabro::ModuleMethods
  def _match(name, input, parter, regex_or_string); end
  def _narrow(parser); end
  def _parse(parser, input); end
  def _quantify(parser); end
  def all(name, input, parser); end
  def alt(name, input, *parsers); end
  def altg(name, input, *parsers); end
  def eseq(name, input, startpa, eltpa, seppa = T.unsafe(nil), endpa = T.unsafe(nil)); end
  def jseq(name, input, startpa, eltpa, seppa = T.unsafe(nil), endpa = T.unsafe(nil)); end
  def last; end
  def last=(_arg0); end
  def make_includable; end
  def method_added(name); end
  def nott(name, input, parser); end
  def parse(input, opts = T.unsafe(nil)); end
  def ren(name, input, parser); end
  def rename(name, input, parser); end
  def rep(name, input, parser, min, max = T.unsafe(nil)); end
  def reparse_for_error(input, opts, t); end
  def rewrite(tree); end
  def rewrite_(tree); end
  def rex(name, input, regex_or_string); end
  def seq(name, input, *parsers); end
  def str(name, input, string); end
end

class Raabro::Tree
  def initialize(name, parter, input); end

  def c0; end
  def c1; end
  def c2; end
  def c3; end
  def c4; end
  def children; end
  def children=(_arg0); end
  def clast; end
  def empty?; end
  def even_children; end
  def extract_error; end
  def gather(name = T.unsafe(nil), acc = T.unsafe(nil)); end
  def input; end
  def input=(_arg0); end
  def length; end
  def length=(_arg0); end
  def line_and_column(offset); end
  def lookup(name = T.unsafe(nil)); end
  def lookup_all_error; end
  def lookup_error(stack = T.unsafe(nil)); end
  def name; end
  def name=(_arg0); end
  def nonstring(l = T.unsafe(nil)); end
  def odd_children; end
  def offset; end
  def offset=(_arg0); end
  def parter; end
  def parter=(_arg0); end
  def prune!; end
  def result; end
  def result=(_arg0); end
  def strim; end
  def strind; end
  def string; end
  def stringd; end
  def stringpd; end
  def strinp; end
  def strinpd; end
  def subgather(name = T.unsafe(nil), acc = T.unsafe(nil)); end
  def sublookup(name = T.unsafe(nil)); end
  def successful_children; end
  def symbod; end
  def symbol; end
  def symbold; end
  def to_a(opts = T.unsafe(nil)); end
  def to_s(depth = T.unsafe(nil), io = T.unsafe(nil)); end
  def visual(line, column); end
end

Raabro::VERSION = T.let(T.unsafe(nil), String)
