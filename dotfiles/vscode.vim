" VSCode Neovim init.vim configuration

" Basic settings
set ignorecase          " Ignore case in search patterns
set smartcase           " Override ignorecase if search contains uppercase
set clipboard=unnamedplus " Use system clipboard

" Keymaps
vnoremap J :m '>+1<CR>gv=gv " Move selected lines down with Alt+J
vnoremap K :m '<-2<CR>gv=gv " Move selected lines up with Alt+K
vnoremap p "_dP " Paste without overriding the yank register
vnoremap < <gv
vnoremap > >gv

" VSCode specific keymaps
" Use <leader> key as space
let mapleader = " "
nnoremap <leader>e :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
nnoremap <leader>sg :call VSCodeNotify('workbench.action.quickTextSearch')<CR>
nnoremap <leader>, :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>p :call VSCodeNotify('workbench.action.showCommands')<CR>
nnoremap L :call VSCodeNotify('workbench.action.nextEditor')<CR>
nnoremap H :call VSCodeNotify('workbench.action.previousEditor')<CR>