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
  augroup AlpacaTemplateConfiguration
    execute 'autocmd BufWriteCmd <buffer> call s:load_template("'. a:path . '", "' . tempfile . '", "' . a:option['target_directory'] . '") | echomsg "Created template" | quit'
  augroup END
endfunction"}}}

function! s:load_template(path, configuration_file, target_directory)
  call alpaca_template#ruby#initialize()

  ruby << EOS
  template_path = VIM.evaluate('a:path')
  configuration_path = VIM.evaluate('a:configuration_file')
  target_directory = VIM.evaluate('a:target_directory')

  file_parser = if File.exists?(configuration_path)
      configuration = AlpacaTemplate::Configuration.new(configuration_path).parse!
      AlpacaTemplate::Template.new(template_path, configuration)
    else
      AlpacaTemplate::Template.new(template_path)
  end

  file_parser.expand_template_to(target_directory)
EOS
endfunction
