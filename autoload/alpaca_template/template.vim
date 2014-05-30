function! alpaca_template#template#initialize(option) "{{{
  let template_name = a:option['template_name']

  for template_directory in g:alpaca_template#template_paths
    let template_path = template_directory . '/' . template_name

    if isdirectory(template_path)
      return s:initialize_template(template_path, a:option)
    endif
  endfor

  echoerr 'Template directory is not found'
endfunction"}}}

function! s:initialize_template(path, option)
  let configuration_file = a:path . '/configuration.yml'

  if filereadable(configuration_file)
    call s:edit_configuration(a:path, a:option)
  endif
endfunction

function! s:edit_configuration(path, option) "{{{
  let configuration_file = a:path . '/configuration.yml'

  " Copy configuration file to tempfile
  let content = readfile(configuration_file)
  if exists('g:loaded_neosnippet')
    let parserd_content = alpaca_template#neosnippet#substitute(join(content, "\n"))
    let content = split(parserd_content, "\n")
  endif
  let tempfile = tempname()
  call writefile(content, tempfile)

  " Edit configuration file
  new `=tempfile`
  setlocal filetype=template_configuration
  setlocal syntax=yaml
  setlocal bufhidden=hide
  setlocal buftype=acwrite
  setlocal nolist
  setlocal nobuflisted
  if has('cursorbind')
    setlocal nocursorbind
  endif
  setlocal noscrollbind
  setlocal noswapfile
  setlocal nospell
  setlocal noreadonly
  setlocal nofoldenable
  setlocal nomodeline
  setlocal foldcolumn=0
  setlocal iskeyword+=-,+,\\,!,~
  setlocal matchpairs-=<:>

  if has('conceal')
    setlocal conceallevel=3
    setlocal concealcursor=n
  endif
  if exists('+cursorcolumn')
    setlocal nocursorcolumn
  endif
  if exists('+colorcolumn')
    setlocal colorcolumn=0
  endif
  if exists('+relativenumber')
    setlocal norelativenumber
  endif

  " Initialize template when configuration is saved.
  let b:alpaca_template_configuration = {
        \ 'template_path' : a:path,
        \ 'target_path' : a:option['target_directory'],
        \ }
  augroup AlpacaTemplateConfiguration
    autocmd BufWriteCmd <buffer> call s:parse_configuration_and_load_template()
  augroup END
endfunction"}}}

function! s:parse_configuration_and_load_template()
  if !exists('b:alpaca_template_configuration')
    return
  endif

  let configuration_content = join(getline(0, '$'), "\n")
  call s:load_template(
        \ b:alpaca_template_configuration['template_path'],
        \ b:alpaca_template_configuration['target_path'],
        \ configuration_content,
        \ )

  echomsg "Created template"
  unlet b:alpaca_template_configuration
  quit
endfunction

function! s:load_template(path, target_directory, ...)
  call alpaca_template#ruby#initialize()
  let has_configuration_content = len(a:000) > 0

  ruby << EOS
  template_path = VIM.evaluate('a:path')
  target_directory = VIM.evaluate('a:target_directory')

  file_parser = if VIM.evaluate('has_configuration_content')
    content = VIM.evaluate('a:1')
    configuration = AlpacaTemplate::Configuration.new.parse!(content)
    AlpacaTemplate::Template.new(template_path, configuration)
  else
    AlpacaTemplate::Template.new(template_path)
  end

  file_parser.expand_template_to(target_directory)
EOS
endfunction
