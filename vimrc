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
NeoBundle 'rhysd/vim-crystal'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'Shougo/vimshell'
NeoBundle 'andrewradev/splitjoin.vim'
NeoBundle 'lmeijvogel/vim-yaml-helper'
NeoBundle 'williamboman/nvim-lsp-installer'
NeoBundle 'neovim/nvim-lspconfig'
NeoBundle 'hrsh7th/nvim-compe'
NeoBundle 'ray-x/lsp_signature.nvim'
NeoBundle 'windwp/nvim-autopairs'
NeoBundle 'will133/vim-dirdiff'
NeoBundle 'dag/vim-fish'

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
au FileType ruby,html,css,scss,html.eruby,scss.eruby,javascript,yaml,crystal,coffee,json,typescript,markdown setlocal shiftwidth=2 tabstop=2 expandtab
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/config/vimsnippets"]
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
packadd! matchit

lua << EOLUA
local nvim_lsp = require('lspconfig')
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  --Set formatexpr to lua
  vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>F", function()
    vim.lsp.buf.format { async = true }
  end, bufopts)

  require "lsp_signature".on_attach()
end

-- local lsp_installer = require("nvim-lsp-installer")
-- 
-- lsp_installer.on_server_ready(function (server)
--     local opts = {}
--     if (server.name == "grammarly") then
-- 		opts.filetypes = { "markdown", "rst", "html" } -- add the filetypes you want grammarly to start on here
--     end
--     server:setup(opts)
-- end)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "solargraph", "grammarly", "rubocop", "crystalline" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
	on_attach = on_attach,
	flags = {
	  debounce_text_changes = 150,
	}
  }
end

require("nvim-lsp-installer").setup({
    automatic_installation = true
})
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
