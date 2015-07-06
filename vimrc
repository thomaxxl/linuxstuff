set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
set hlsearch
set ci
set ai
set si

command -nargs=0 -bar Update if &modified
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
nnoremap <silent> <C-s> :w<cr>a

nnoremap <silent> <C-X> :<C-u>Update<CR>
vnoremap <silent> <C-X>         <C-C>:update<CR>
inoremap <silent> <C-X>         <C-O>:update<CR>
nnoremap <C-X> <esc>:x<CR>
inoremap <C-X> <esc>:x<CR>
vnoremap <C-X> <esc>:x<CR>
nnoremap <C-F> <esc>/
inoremap <C-F> <esc>/
vnoremap <C-F> <esc>/



