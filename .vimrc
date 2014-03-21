set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

filetype plugin indent on

" ここのgithubのページを貼付ける
" :NeoBundleInstallで追加
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'
NeoBundle 'osyo-manga/vim-over' " 文字置き換え時のかっこいいやつ <C-o>
NeoBundle 'thinca/vim-splash'   " vi 単独で開くとスプラッシュ画面を表示する
NeoBundle 'tpope/vim-fugitive'  " vimでgitひらくやつ
NeoBundle 'gregsexton/gitv'     " vimでgitひらくやつ

filetype indent on
syntax on

" vim splash
let g:splash#path = $HOME . '/.vim/vimsplash.txt'

" すごく好きないい感じのカラースチーム desert!
colorscheme desert

set hidden
set switchbuf=useopen

" ヤンクするとクリップボードにコピーする
set clipboard=unnamed,autoselect

" デフォルトエンコーディング
set encoding=utf-8
set fileencodings=utf-8

set tabstop=2
set shiftwidth=2
set expandtab "ソフトタブを有効にする
set autoindent  "autoindentを有効にする

" 新ウィンドを右に開く
set splitright
" 新ウィンドを下に開く
set splitbelow

" 行・列を強調表示 これ激アツ ぱない
set cursorcolumn
highlight CursorColumn ctermbg=Blue
set cursorline
highlight CursorLine ctermbg=Blue

" 保存時に空白とtabを置き換え カーソル位置が動くので動かないように
function! s:remove_dust()
    let cursor = getpos(".")
    " 保存時に行末の空白を除去する
    %s/\s\+$//ge
    " 保存時にtabを2スペースに変換する
    %s/\t/  /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

" Shift-Tabでタブを新規タブを開く by 藤井さん
nnoremap <S-t> :Texplore<CR>
" タブの移動
nnoremap <S-a> gT
nnoremap <S-s> gt

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
" by 村山さん
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" vim-over 文字置き換えの際に文字をハイライト
nnoremap <silent> <C-o> :OverCommandLine<CR>%s/

" Rails系 binding.pry インサートモードでCtrl-bでbinding.pry出力
" by 藤井さん
function! InsertDebugger()
    if &filetype == 'coffee' || &filetype == 'javascript'
      let debugger = "debugger"
    elseif &filetype == 'ruby'
      let debugger = "binding.pry"
    elseif &filetype == 'eruby'
      let debugger = "<% binding.pry %>"
    elseif &filetype == 'haml'
      let debugger = "- binding.pry"
    else
      let debugger = "binding.pry"
    endif

    return debugger
endfunction
inoremap <expr> <C-b> InsertDebugger()

" paste時に、set pasteしてくれる
if &term =~ "xterm"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>
endif

" 全角spaceを表示させる
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif
