function! alpaca_template#ruby#initialize()
endfunction

ruby << EOS
plugin_directory = VIM.evaluate('g:alpaca_template#lib_directory')
$LOAD_PATH.unshift << plugin_directory
require 'alpaca_template'
EOS
