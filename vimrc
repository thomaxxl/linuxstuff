set tabstop=4
set shiftwidth=4
set expandtab
set mouse=r
set ai
set si
command -nargs=0 -bar Update if &modified
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <C-S> :<C-u>Update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>
nnoremap <C-X> <esc>:x<CR>
inoremap <C-X> <esc>:x<CR>
vnoremap <C-X> <esc>:x<CR>


noremap <C-Q> <esc>:q!<CR>

nnoremap <C-F> <esc>/
inoremap <C-F> <esc>/
vnoremap <C-F> <esc>/

nnoremap <Home> <esc>gg
inoremap <Home> <esc>gg
vnoremap <Home> <esc>gg

inoremap <C-A> <esc>:1<CR>v<CR>G$<CR><esc>
nnoremap <C-A> <esc>:1<CR>v<CR>G$<CR><esc>
vnoremap <C-A> <esc>:1<CR>v<CR>G$<CR><esc>

vnoremap <C-C> <esc>y<CR>

nmap <S-Up> v
nmap <S-Down> v
" these are mapped in visual mode
vmap <S-Up> k
vmap <S-Down> j

nnoremap <C-Left> <esc>gg
vnoremap <C-Left> <esc>gg
inoremap <C-Left> <esc>gg

set ls=1

highlight Cursor   guifg=white  guibg=black
highlight iCursor  guifg=white  guibg=black

function! ShowTitle(mode)
    let &titlestring = hostname() . "[vim" . expand("%:t") . ")]"
    if &term == "screen"
        let &titlestring = hostname() . "[im" . expand("%:t") . ")]"
        set t_ts=^[k
        set t_fs=^[\
    endif
    if &term == "screen" || &term == "xterm"
        let &titlestring = hostname() . "[vi" . expand("%:t") . ")]"
        set title
    endif
endfunction


function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=magenta
  elseif a:mode == 'r'
    hi statusline guibg=blue
  else
    hi statusline guibg=red
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=green

"au InsertEnter * ShowTitle(v:insertmode)
"
"
"performance boost
set lazyredraw
set ttyfast

set history=200     " command history
set incsearch       " search
"set number         " Line numbering
set cmdheight=1    " heaight of the command bar

" keep block selected when indenting
vnoremap > ><CR>gv
vnoremap < <<CR>gv

nnoremap <F1> :tabprevious<CR>
nnoremap <F2> :tabnext<CR>
nnoremap <C-t> :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

" Working with Tabs
inoremap <C-O> <esc>:tabedit<space>
vnoremap <C-O> <esc>:tabedit<space>
nnoremap <C-O> <esc>:tabedit<space>

inoremap [OC <esc>:tabedit<space>
vnoremap [OC <esc>:tabedit<space>
nnoremap [OC <esc>:tabedit<space>

" set list
" set listchars=tab:..,trail:.,nbsp:.
"statusline setup
nmap <S-Up> V
nmap <S-Down> V
" these are mapped in visual mode
vmap <S-Up> k

nnoremap sp :set paste<CR>
nnoremap <C-V> :set paste<CR>i<CR><S-Insert>
inoremap <C-V> <esc>:set paste<CR>i<CR><S-Insert>A
" :color desert
set background=dark

au InsertEnter * setlocal cursorline!
au InsertLeave * setlocal cursorline

"au InsertLeave * color peachpuff
"
":hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
":hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
":nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

setlocal cursorline

set mouse=a

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


set nosmartindent
