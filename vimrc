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

function! s:LuaFileRelative(script)
  let l:callstack = expand("<stack>")
  let l:list = split(l:callstack, '\.\.')
  " list[-1] is SourceLocal function itself
  " list[-2] is the calling script
  let l:script_name = matchstr(l:list[-2], '^\(script \)\=\zs.\+\ze\[\d\+\]$')
  let l:script_path = fnamemodify(l:script_name, ":p:h")
  " l:script_path is the path where the script calling this function resides
  execute printf("luafile %s/%s", l:script_path, a:script)
endfunction

" vim-plug related install
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v1.*'}
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'honza/vim-snippets' " Add snippets for the engine
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree'
Plug 'rhysd/vim-crystal'
Plug 'tpope/vim-abolish'
Plug 'Shougo/vimshell'
Plug 'andrewradev/splitjoin.vim'
Plug 'lmeijvogel/vim-yaml-helper'
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'will133/vim-dirdiff'
Plug 'dag/vim-fish'

" cmp-related plugins, used for displaying the completion floating window
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'

" Treesiter related, for syntax
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'andymass/vim-matchup'

" refactoring-related plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/refactoring.nvim'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

let mapleader="\\"

let g:airline_powerline_fonts = 1

" Required:
filetype plugin indent on

" Requires vim-fugitive to work:
command Gslap Gblame -w

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
au FileType c,cpp,objc,objcpp,java,rust call rainbow#load()

" ruby,html,css shift and tabstop to 2
au FileType ruby,html,css,scss,html.eruby,scss.eruby,javascript,yaml,crystal,coffee,json,typescript,markdown,gotmpl,terraform setlocal shiftwidth=2 tabstop=2 expandtab
nnoremap <silent> <F8> :NERDTreeToggle<CR>

" select when using the mouse
set selectmode=mouse

" Mouse scroll/select
set mouse=a

if !has("nvim")
	if has("mouse_sgr")
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	end
else
  augroup nvimrc_aucmd
    autocmd!
    " https://github.com/neovim/neovim/issues/3463#issuecomment-148757691
    autocmd CursorHold,FocusGained,FocusLost * rshada|wshada
  augroup END
end

set tabpagemax=80

" Extended matching of begin/end in languages
" packadd! matchit

call s:LuaFileRelative("neovim/treesitter.lua")
call s:LuaFileRelative("neovim/lsp.lua")
call s:LuaFileRelative("neovim/cmp.lua")
call s:LuaFileRelative("neovim/luasnip.lua")
call s:LuaFileRelative("neovim/refactoring.lua")

set completeopt=menu,menuone,noselect

autocmd BufNewFile,BufRead *.yaml,*.yml,*.tpl if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif
