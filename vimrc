set ai
set nu
set hls is ic scs
set ru
set ls=2
set cin
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
syn on
set nocp
set ww=<,>,b,s,[,]
set wildmode=longest,list,full
set wildmenu

" highlight EOL whitespace
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red
