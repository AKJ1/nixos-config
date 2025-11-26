:unmap <C-n>
:unmap <C-v>
:unmap <C-c>
:unmap <C-x>
:unmap <C-w>


:nmap <space> <Leader>
:imap jk <Esc>
:set scrolloff=5

:set surround
:set incsearch

:nnoremap s <Nop>
:nnoremap S <Nop>

:nnoremap \e :e ~\.vimrc<CR>
:nnoremap \r :source ~\.vimrc<CR>