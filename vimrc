" syntax highlight
syntax enable

" 4 spaces for indenting
set shiftwidth=4

" 4 stops
set tabstop=4

" Spaces instead of tabs
"set expandtab

" Always set auto indenting on
set autoindent smartindent cindent

set hlsearch incsearch ignorecase smartcase

set ru
syn on

" not compatible with vi
set nocp

" Line Numbers
set nu
set ww=<,>,b,s,[,]

" Status bar
set statusline=%1*%F%m%r%h%w%=%(%c%V\ %l/%L\ %P%)
set laststatus=2
" this enables "visual" wrapping
set wrap

" this turns off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0 wrapmargin=0

set wildmode=longest,list,full
set wildmenu
set softtabstop=2

" #######################
" # PRETTY TAB NUMBERS! #
set tabline=%!MyTabLine()
function MyTabLine()
  let s = '' " complete tabline goes here
  " loop through each tab page
  for t in range(tabpagenr('$'))
    " select the highlighting for the buffer names
    if t + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " empty space
    let s .= ' '
    " set the tab page number (for mouse clicks)
    let s .= '%' . (t + 1) . 'T'
    " set page number string
    let s .= t + 1 . ' '
    " get buffer names and statuses
    let n = ''  "temp string for buffer names while we loop and check buftype
    let m = 0 " &modified counter
    let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
    " loop through each buffer in a tab
    for b in tabpagebuflist(t + 1)
      " buffer types: quickfix gets a [Q], help gets [H]{base fname}
      " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
      if getbufvar( b, "&buftype" ) == 'help'
        let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
      elseif getbufvar( b, "&buftype" ) == 'quickfix'
        let n .= '[Q]'
      else
        let n .= pathshorten(bufname(b))
        "let n .= bufname(b)
      endif
      " check and ++ tab's &modified count
      if getbufvar( b, "&modified" )
        let m += 1
      endif
      " no final ' ' added...formatting looks better done later
      if bc > 1
        let n .= ' '
      endif
      let bc -= 1
    endfor
    " add modified label [n+] where n pages in tab are modified
    if m > 0
      "let s .= '[' . m . '+]'
      let s.= '+ '
    endif
    " add buffer names
    if n == ''
      let s .= '[No Name]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space to buffer list
    "let s .= '%#TabLineSel#' . ' '
    let s .= ' '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif
  return s
endfunction
" END PRETTY TAB NUMBERS!
" #######################

set list listchars=tab:»·

nmap <F2> :set paste!<CR>
nmap <F3> :set nu!<CR>:call ToggleListChars()<CR>

fun! ToggleListChars()
	if !exists("g:my_list_chars")
		let g:my_list_chars = 2
	endif

	if g:my_list_chars == 1
		let g:my_list_chars = 2
		set list listchars=tab:»·
	else
		let g:my_list_chars = 1
		set list listchars=tab:\ \ "whitespace here intentional
	endif
endfunction

iabbrev phpprintr echo "<pre>";<CR>print_r();<CR>echo "</pre>";<CR>die();<CR>
iabbrev phpvardump echo "<pre>";<CR>var_dump();<CR>echo "</pre>";<CR>die();<CR>
ab phpbacktrace $e = new Exception;<CR>var_dump($e->getTraceAsString());<CR>die()<CR>

"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'morhetz/gruvbox'
NeoBundle 'oblitum/rainbow'
NeoBundle 'bling/vim-airline'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------
if $TERM == 'xterm-256color' || $TERM == 'screen-256color' || $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

colorscheme gruvbox
set background=dark

" highlight EOL whitespace
highlight ExtraWhitespace ctermbg=9 guibg=#ff0000 "rgb=95,0,0
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

au FileType c,cpp,objc,objcpp,java call rainbow#load()

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" select when using the mouse
set selectmode=mouse


" Mouse scroll/select
set mouse=a
set ttymouse=xterm2
