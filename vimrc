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
NeoBundle 'rhysd/vim-crystal'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'Shougo/vimshell'
NeoBundle 'andrewradev/splitjoin.vim'
"NeoBundle 'dense-analysis/ale'
NeoBundle 'lmeijvogel/vim-yaml-helper'
NeoBundle 'elixir-editors/vim-elixir'
" NeoBundle 'neoclide/coc.nvim', 'release', { 'build': { 'others': 'git checkout release' } }
NeoBundle 'neovim/nvim-lspconfig'
NeoBundle 'hrsh7th/nvim-compe'
NeoBundle 'ray-x/lsp_signature.nvim'
NeoBundle 'windwp/nvim-autopairs'
NeoBundle 'will133/vim-dirdiff'

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
au FileType c,cpp,objc,objcpp,java,rust call rainbow#load()

" ruby,html,css shift and tabstop to 2
au FileType ruby,html,css,scss,html.eruby,scss.eruby,javascript,yaml,crystal,coffee,json,typescript setlocal shiftwidth=2 tabstop=2 expandtab
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/config/vimsnippets"]
nnoremap <silent> <F8> :NERDTreeToggle<CR>

" autocmd! CursorMoved *.yml YamlDisplayFullPath " Uses vim-yaml-helper

"" Ale linting
"let g:ale_ruby_rubocop_executable = 'bundle'
"let b:ale_linters = {'ruby' : ['rubocop'], 'python': ['pylint']}
"let g:ale_virtualenv_dir_names = ['.env', '.venv', '.virtualenv', 'env', 've-py3', 've', 'virtualenv', 'venv']

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
packadd! matchit

" coc.nvim extra config
"let g:coc_global_extensions = ['coc-solargraph']
"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c
"
"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"if has("patch-8.1.1564")
"  " Recently vim can merge signcolumn and number column into one
"  set signcolumn=number
"else
"  set signcolumn=yes
"endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"
"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=300
"
"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
"
"nmap <silent> gd <Plug>(coc-definition)
"
"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

" Install extensions: coc-solargraph, coc-ultisnips, coc-python, coc-yaml
" end of coc.nvim config

lua << EOLUA
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  require "lsp_signature".on_attach()
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "solargraph" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
	on_attach = on_attach,
	flags = {
	  debounce_text_changes = 150,
	}
  }
end
EOLUA

lua << EOLUA
-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOLUA
set completeopt=menuone,noselect

lua << EOLUA
require('nvim-autopairs').setup()
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true -- it will auto insert `(` after select function or method item
})
EOLUA
