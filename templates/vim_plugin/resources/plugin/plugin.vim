if exists('g:<%= variables['plugin_name'] %>')
  finish
endif
let g:<%= variables['plugin_name'] %> = 1

let s:save_cpo = &cpo
set cpo&vim



let &cpo = s:save_cpo
unlet s:save_cpo