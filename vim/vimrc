" load plugins the Cool© way
execute pathogen#infect()

" Show line numbers
set number
set showcmd
" Always display the status line, even if only one window is displayed
set laststatus=2

" Show whitespace
set listchars=tab:>-,trail:@,nbsp:~
set list
set cursorline
set hlsearch
" horizontal menu for cli autocompletion
set wildmenu
" user friendly search
set incsearch

filetype plugin on

syntax enable
set tabstop=8
set shiftwidth=8
set smarttab
set noexpandtab
filetype indent on
set autoindent
set smartindent
set cino=(0

" Map key to toggle opt
function MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

" Display-altering option toggles
MapToggle <F1> hlsearch
MapToggle <F2> wrap
MapToggle <F3> list

" Behavior-altering option toggles
MapToggle <F10> scrollbind
MapToggle <F11> ignorecase
MapToggle <F12> paste
"set pastetoggle=<F12>

"set t_Co=256
"let g:gruvbox_contrast_dark = "hard"
set background=dark
colorscheme distinguished

" Enable use of the mouse for all modes
" vital if you live in the 21st century
set mouse=a

" powerline stuff
"if !has("nvim")
"    python from powerline.vim import setup as powerline_setup
"    python powerline_setup()
"    python del powerline_setup
"    set rtp+={repository_root}/powerline/bindings/vim
"endif

"set rtp=$HOME/src/powerline-2.5/powerline/bindings/vim

set tags=./tags;,tags;

" CtrlP stuff
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
noremap <c-b> :CtrlP $BXI_SRC_DIR/*
noremap <c-t> :FZF $BXI_SRC_DIR/*

" Syntastic stuff
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

noremap <F8> :lopen<cr>
noremap <F9> :lclose<cr>
