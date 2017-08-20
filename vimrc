execute pathogen#infect()
syntax on
set nu
set expandtab
set shiftwidth=2
set softtabstop=2
filetype plugin indent on
au BufNewFile,BufRead *.json set ft=json
au BufNewFile,BufRead *.md set ft=markdown
set wildmode=longest,list,full
set wildmenu
match ErrorMsg '\%>110v.\+'
set ruler
color desert
set pastetoggle=<F2>
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
map q: :q
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Cycle between line numbers, relative numbers, no numbers
if exists('+relativenumber')
  "CTRL-N is traditionally mapped to move the cursor down;
  "I never use it that way, and there are already four other
  "ways to do that
  nnoremap <expr> <C-N> CycleLNum()
  xnoremap <expr> <C-N> CycleLNum()
  onoremap <expr> <C-N> CycleLNum()

  " function to cycle between normal, relative, and no line numbering
  function! CycleLNum()
    if &l:rnu
      setlocal nonu nornu
    elseif &l:nu
      setlocal nu rnu
    else
      setlocal nu
    endif
    " sometimes (like in op-pending mode) the redraw doesn't happen
    " automatically
    redraw
    " do nothing, even in op-pending mode
    return ""
  endfunc
endif

" Explains what has happened when Vim notices that the file you are editing
" was changed by another program

if has('eval') && has('autocmd')
  augroup FCSHandler
    au FileChangedShell * call FCSHandler(expand("<afile>:p"))
  augroup END

  function! FCSHandler(name)
    let msg = 'File "'.a:name.'"'
    let v:fcs_choice = ''
    if v:fcs_reason == 'deleted'
      let msg .= " no longer available - 'modified' set"
      call setbufvar(expand(a:name), '&modified', '1')
    elseif v:fcs_reason == 'time'
      let msg .= ' timestamp changed'
    elseif v:fcs_reason == 'mode'
      let msg .= ' permissions changed'
    elseif v:fcs_reason == 'changed'
      let msg .= ' contents changed'
      let v:fcs_choice = 'ask'
    elseif v:fcs_reason == 'conflict'
      let msg .= ' CONFLICT --'
      let msg .= ' is modified, but'
      let msg .= ' was changed outside Vim'
      let v:fcs_choice = 'ask'
      echohl Error
    else  " unknown values (future Vim versions?)
      let msg .= ' FileChangedShell reason='
      let msg .= v:fcs_reason
      let v:fcs_choice = 'ask'
    endif
    redraw!
    echomsg msg
    echohl None
  endfunction
endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g_syntastic_check_on_wq = 0
