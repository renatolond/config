scriptencoding utf-8
set encoding=utf-8

" syntax highlight
syntax on

" 4 spaces for indenting
set shiftwidth=4

" 4 stops (visual tab)
set tabstop=4

" 2 stops each tab press
set softtabstop=2

" Spaces instead of tabs
"set expandtab

" Always set auto indenting on
set autoindent smartindent cindent

" highlight search, incremental search, ignore case smartly (if there's one
" upper case, takes case in consideration in the search)
set hlsearch incsearch ignorecase smartcase

" Show ruler
set ru

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

" changes the tab behaviour in :tabedit to be more similar to bash autocomplete
set wildmode=longest,list,full
set wildmenu

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

" F2 shortcut to toggle paste mode
nmap <F2> :set paste!<CR>

" Shows tabs as »··· by default
" F3 shortcut to turn it off with line numbers to allow copy/paste
nmap <F3> :set nu!<CR>:call ToggleListChars()<CR>
set list listchars=tab:»·
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
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'morhetz/gruvbox'
NeoBundle 'oblitum/rainbow'
NeoBundle 'bling/vim-airline'
NeoBundle 'SirVer/ultisnips' " Add snippets engine
NeoBundle 'honza/vim-snippets' " Add snippets for the engine
NeoBundle 'mhinz/vim-startify'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'xolox/vim-misc'
"NeoBundle 'xolox/vim-easytags'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'rhysd/vim-crystal'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'andrewradev/splitjoin.vim'

let g:airline_powerline_fonts = 1

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" Requires vim-fugitive to work:
command Gslap Gblame -w

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" if terminal is 256-color, enable 256 color in vim
if $TERM == 'xterm-256color' || $TERM == 'screen-256color' || $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

colorscheme gruvbox
set background=dark

" vim-startify begin

" When opening a file or bookmark, seek and change to the root directory of the
" VCS (if there is one).
let g:startify_change_to_vcs_root = 1

let g:startify_bookmarks = [
	\ { 'src': '~/sources' },
	\ { 'ivglib': '~/sources/internetgameslibrary' },
	\ { 'cfg': '~/config' },
	\]

let g:startify_custom_header = [
	\ ' :::         ...   :::.    :::.:::::::-.',
	\ ' ;;;      .;;;;;;;.`;;;;,  `;;; ;;,   `'';,',
	\ ' [[[     ,[[     \[[,[[[[[. ''[[ `[[     [[',
	\ ' $$''     $$$,     $$$$$$ "Y$c$$  $$,    $$',
	\ 'o88oo,.__"888,_ _,88P888    Y88  888_,o8P''',
	\ '""""YUMMM  "YMMMMMP" MMM     YM  MMMMP"`',
	\ ]


" vim-startify end

" highlight EOL whitespace
highlight ExtraWhitespace ctermbg=9 guibg=#ff0000 "rgb=95,0,0
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

"autocmd BufNewFile,BufRead *.html.erb set filetype=html.eruby
autocmd BufRead,BufNewFile *.scss.erb setlocal filetype=scss.eruby

" enable rainbow parenthesis in c, cpp, objc, objcpp and java
au FileType c,cpp,objc,objcpp,java call rainbow#load()

" ruby,html,css shift and tabstop to 2
au FileType ruby,html,css,scss,html.eruby,scss.eruby,javascript,yaml,crystal,coffee,json,typescript setlocal shiftwidth=2 tabstop=2 expandtab
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/config/vimsnippets"]
nnoremap <silent> <F8> :NERDTreeToggle<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>

"let g:easytags_async=1
"let g:easytags_auto_highlight=0
"let g:easytags_syntax_keyword = 'always'

" select when using the mouse
set selectmode=mouse

" Mouse scroll/select
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
set tabpagemax=50

" Extended matching of begin/end in languages
packadd! matchit
