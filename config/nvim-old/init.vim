call plug#begin()
    " colorschemes
    " Plug 'RRethy/nvim-base16'
    Plug 'navarasu/onedark.nvim'
    Plug 'ARM9/arm-syntax-vim'
        au BufNewFile,BufRead *.s,*.S,*.asm set filetype=arm

    " tpope miscellaneous goodies
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
        let g:surround_indent = 0
    Plug 'tpope/vim-commentary'

    " vim-git integration
    Plug 'tpope/vim-fugitive'
    Plug 'shumphrey/fugitive-gitlab.vim'
        let g:fugitive_gitlab_domains = ['https://gitlab.psiquantum.com']

    " CamelCase and under_score word motions
    Plug 'chaoren/vim-wordmotion'
        let g:wordmotion_prefix = ','

    " Separate arguments on multiple lines (opposite of J)
    Plug 'AckslD/nvim-trevJ.lua'

    " fast matchparen
    Plug 'andymass/vim-matchup'
        let g:matchup_override_vimtex = 1

    " LaTeX
    Plug 'lervag/vimtex'
        let g:tex_flavor = 'latex'
        let g:vimtex_view_method = 'skim'
        let g:vimtex_quickfix_open_on_warning = 0
        let g:vimtex_subfile_start_local = 1
        let g:vimtex_indent_bib_enabled = 0
        let g:tex_no_error = 1  "don't highlight syntax 'errors'

    " Treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Indent plugins
    " Plug 'Vimjas/vim-python-pep8-indent'
    Plug 'yioneko/nvim-yati'

    " Autocompletions
    Plug 'windwp/nvim-autopairs'

    " vim in browser
    " Plug 'glacambre/firenvim', {'do': { _ -> firenvim#install(0) }}

    " Sphynx integration (docstrings)
    Plug 'stsewd/sphinx.nvim', { 'do': ':UpdateRemotePlugins' }

    " Linter parser
    Plug 'mfussenegger/nvim-lint'

    " fuzzy search with fzf
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
call plug#end()

"
" ---------- OPTIONS --------
"

lua <<EOF
require('nvim-treesitter.configs').setup {
    highlight = { enable = true, disable = { "latex", } },
    yati = { enable = true },
    matchup = { enable = true, disable = { "latex", },
                enable_quotes = true },
}
require('nvim-autopairs').setup {}
require('onedark').setup {
    transparent = true,
    code_style = {keywords = "italic"}
}
require('onedark').load()
require('trevj').setup {}
require('lint').linters_by_ft = {
    python = {'ruff',}
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
EOF


set scrolloff=3 " show context around cursor
set mouse=a " enable mouse
set mousescroll=ver:1,hor:1 " scroll in 1 line/col increments
set number " put line numbers
set cursorline " higlight current line
set noshowcmd " disable feedback for keys

" Search: do not highlight, smart case
" set nohlsearch
set ignorecase
set smartcase

" Indentation to 4 spaces
set expandtab
set shiftwidth=4
set tabstop=4

" new splits below and right instead of above and left
set splitbelow
set splitright
set noequalalways  " splits do not resize automatically

" 'display line' navigation
set linebreak
set breakindent
noremap <silent> k gk
noremap <silent> j gj


" ------ MAPPINGS ------
"

let mapleader = "\<Space>"
let maplocalleader = "'"

" Ctrl+a and Ctrl+x (+1 and -1 on numbers) are dangerous...
map <C-a> <Nop>
map <C-x> <Nop>

" more convenient save and quit 
command W w
command X x
command Q q
map <leader>q :qa<CR>

" closes the window and the buffer
command Qb bdelete

" Copy/Paste system clipboard
vnoremap <leader>y "+y
noremap <leader>p "+p

" Folding
nnoremap <leader><Space> za

" Terminal
map <leader>t :sp term://$SHELL<CR>A
autocmd TermOpen * setlocal nonumber norelativenumber

" clear last highlighted search
map <silent> <leader>h :let @/ = ""<CR>

" run black on the current python file
autocmd FileType python nmap <leader>b :!black %<CR>

" insert ipdb breakpoint on newline
autocmd FileType python nnoremap <leader>ip oimport ipdb; ipdb.set_trace()<ESC>

" reverse J with trevJ
noremap <leader>j :lua require('trevj').format_at_cursor()<CR>

"
" ------ AUTOMATION --------
"

" Clear lines after EOF (i.e. scroll them away)
function! ClearLines()
    let empty_lines = winheight(0) - winline() - line("$") + line(".")
    if empty_lines > 0
        exe "normal! ".empty_lines."\<C-Y>"
    endif
endfunction

" Continue from where you left (except on git commit)
augroup jump_to_last_visited
    autocmd!
    autocmd BufReadPost *
     \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
     \ |   exe "normal! g`\""
     \ |   silent! exe "normal! zv"
     \ |   silent! exe "normal! zz"
     \ |   silent! call ClearLines()
     \ | endif
augroup END

" latex/vimtex preferences/workarounds
augroup latex
    autocmd!
    autocmd FileType tex,latex
        \   set textwidth=90
        \ | setlocal spell spelllang=en_us
augroup END
