if exists('g:alpaca_template') && has('ruby')
  finish
endif
let g:alpaca_template = 1

let s:save_cpo = &cpo
set cpo&vim

let s:plugin_root_dir = expand('<sfile>:p:h:h')
let g:alpaca_template#lib_directory = s:plugin_root_dir . '/lib'
let g:alpaca_template#template_paths = get(g:, 'alpaca_template#template_paths', [])

if get(g:, 'alpaca_template#enable_runtime_template', 1)
  call add(g:alpaca_template#template_paths, s:plugin_root_dir . '/templates')
endif

command!
      \ -complete=customlist,alpaca_template#complete_template_names
      \ -nargs=+ AlpacaTemplate
      \ call alpaca_template#load(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
