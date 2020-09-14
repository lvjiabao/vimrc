"先安装vundle
function PrintKeyMap()
    echo "F1 vim在线帮助文档        F2 vim快捷键                        F3  打开NERD目录                F4  打开Taglist"
    echo "F5                        F6                                  F7                              F8 "
    echo "F9                        F10 打开Tag列表                     F11                             F12 重新启动cscope"
    echo "\i 打开可视化色块         \ffa 打开Ack搜索                    \c 转到函数定义或声明处         \s 在小窗口显示"
    echo "\+数字 切换到第几个标签   \+ 转到下一个标签页                 \- 转到上一个标签页"
endfunction

function CSTAG_cpp()
    let dir = getcwd()
    let g:tagsdeleted=0
    let g:csfilesdeleted=0
    let g:csoutdeleted=0
    if filereadable("tags")
        if(!has('win32'))
            let tagsdeleted=delete("./"."tags")
        else
            let tagsdeleted=delete(dir."\\"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(!has('win32'))
            let csfilesdeleted=delete("./"."cscope.files")
        else
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(!has('win32'))
            let csoutdeleted=delete("./"."cscope.out")
        else
            let csoutdeleted=delete(dir."\\"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(!has('win32'))
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' >> cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

function ResetCscope()
    if(executable('cscope') && has("cscope") )
        silent! execute "cs kill -1"
        if filereadable("cscope.out")
            silent! execute "normal :"
            silent! execute "cs add cscope.out"
        endif
    endif
    if filereadable("cscope.files")
        if(!has('win32')) 
            silent! execute "!cp -f ./cscope.files ~/.cscope.files"
        endif
    endif
endfunction

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set bs=indent,eol,start		" allow backspacing over everything in insert mode
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

let &guicursor = &guicursor . ",a:blinkon0"
set nu
set 		backspace=2     						"设置退格键可用
set 		nocompatible							"关闭兼容模式
set 		number									"显示行号
syntax 		enable									"语法高亮
syntax 		on							
set			cindent
set			autoindent
set showcmd             " 命令行显示输入的命令

set			ruler									"总是在vim窗口右下角显示当前光标行列信息
set 		nowrap 									"不自动换行
set 		sw=4 									"将shiftwidth设为4
set 		ts=4 									"将tabstop设为4
set 		shiftwidth=4 
set 		softtabstop=4 
set 		tabstop=4 								"让一个tab等于4个空格
set 		smartindent   							"set smart indent
set 		smarttab      							"use tabs at the start of a line, spaces elsewhere
set 		expandtab
set			sm										"显示括号配对情况
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%] "显示文件名：总行数，总的字符数

autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行
set laststatus=2                " 总是显示状态栏
set cursorline                  " 高亮显示当前行/列
set cursorcolumn
set completeopt=preview,menu    " 代码补全
set ignorecase                  " 搜索忽略大小写
set hlsearch                    " 搜索逐字符高亮
set incsearch

colorscheme desert
"colorscheme delek
"colorscheme solarized
set background=dark


set guifont=Bitstream_Vera_Sans_Mono:h12:cANSI 		"记住空格用下划线代替哦

set fileencodings=utf-8,cp936,gb2312,gbk,gb18030
set encoding=utf-8
set fenc=utf-8
set ambiwidth=double    "设置字符宽度,使得符号 可以显示
set nobackup            "不备份
set noswapfile          " 禁止生成交换文件
set clipboard+=unnamed  " 共享剪贴板
language message zh_CN.utf-8
:filetype on

map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
map <F4> :Tlist<CR>
map <F10> :TagbarToggle<CR>        " 设置显示／隐藏标签列表子窗口的快捷键。速记：tag list 
"map <F11> :call ResetCscope()<CR>
map <F12> :call CSTAG_cpp()<CR>	"调用初始函数

"taglist 设置
let	Tlist_Show_One_File=1						"只显示当前文件的tags
let	Tlist_WinWidth=25							"设置taglist的宽度
let	Tlist_Exit_OnlyWindow=1						"taglist窗口是最后一个窗口,则推出vim
let	Tlist_Use_Right_Window=0					"在vim窗口右侧显示taglist窗口

"nredTree 设置
" 打开 NERDTree 并选中当前文件
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let NERDTreeWinPos='right'
let NERDTreeWinSize=25

filetype plugin on 

"vim-indent-guides 可视化色宽
let g:indent_guides_enable_on_vim_startup=0 " 随 vim 自启动
let g:indent_guides_start_level=3 " 从第二层开始可视化显示缩进
let g:indent_guides_guide_size=1 " 色块宽度
nmap <leader>i <Plug>IndentGuidesToggle    
"快捷键 i 开/关缩进可视化

"a.vim 类的定义和实现之间的切换
"*.cpp 和 *.h 间切换
nmap <leader>c :A<CR>         
"子窗口中显示 *.cpp 或 *.h
nmap <leader>s :AS<CR>       

"tagbar标签管理
"设置 tagbar 子窗口的位置出现在主编辑区的左边 
let tagbar_left=1 
" 设置标签子窗口的宽度 
let tagbar_width=25 
" tagbar 子窗口中不显示冗余帮助信息 
let g:tagbar_compact=1
" 设置 ctags 对哪些代码元素生成标签
let g:tagbar_type_cpp = {
    \ 'kinds' : [
        \ 'd:macros:1',
        \ 'g:enums',
        \ 't:typedefs:0:0',
        \ 'e:enumerators:0:0',
        \ 'n:namespaces',
        \ 'c:classes',
        \ 's:structs',
        \ 'u:unions',
        \ 'f:functions',
        \ 'm:members:0:0',
        \ 'v:global:0:0',
        \ 'x:external:0:0',
        \ 'l:local:0:0'],
              \ 'sro'        : '::',
              \ 'kind2scope' : {
                  \ 'g' : 'enum',
                  \ 'n' : 'namespace',
                  \ 'c' : 'class',
                  \ 's' : 'struct',
                  \ 'u' : 'union'
              \ },
              \ 'scope2kind' : {
                  \ 'enum'      : 'g',
                  \ 'namespace' : 'n',
                  \ 'class'     : 'c',
                  \ 'struct'    : 's',
                  \ 'union'     : 'u'
              \ }
            \ }

"airline
    let g:airline_powerline_fonts = 1
    let g:airline_theme = 'bubblegum'
    "打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#buffer_nr_show = 0
    let g:airline#extensions#tabline#show_buffers = 1

    " 关闭状态显示空白符号计数
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#whitespace#symbol = '!'

    " enable/disable displaying tab number in tabs mode.
    let g:airline#extensions#tabline#show_tab_nr = 1

    " configure how numbers are displayed in tab mode.
    "let g:airline#extensions#tabline#tab_nr_type = 0 " # of splits (default)
    let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
    "let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number

    " rename label for buffers (default: 'buffers') (c)
    let g:airline#extensions#tabline#buffers_label = 'b'

    " rename label for tabs (default: 'tabs') (c) >
    let g:airline#extensions#tabline#tabs_label = 't'
    let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
    let g:airline#extensions#quickfix#location_text = 'Location'
    let g:airline#extensions#bufferline#enabled = 1
    let g:airline#extensions#bufferline#overwrite_variables = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9
    nmap <leader>- <Plug>AirlineSelectPrevTab
    nmap <leader>+ <Plug>AirlineSelectNextTab

    let airline#extensions#tabline#middle_click_preserves_windows = 1
    let airline#extensions#tabline#disable_refresh = 0
    if !exists('g:airline_symbols')
       let g:airline_symbols = {}
    endif

    let g:airline_left_sep = '>'
    let g:airline_left_alt_sep = ' '
    let g:airline_right_sep = ' '
    let g:airline_right_alt_sep = ' '
    let g:airline_symbols.branch = ' '
    let g:airline_symbols.readonly = ' '
    let g:airline_symbols.linenr = ' '


"ack 代码搜索
"进行搜索，同时不自动打开第一个匹配的文件"
map <leader>ffa :Ack!<Space> 
"调用ag进行搜索
if executable('ag')
"配置ag搜索参数
    let g:ack_prg = "ag --vimgrep --smart-case"
endif
"高亮搜索关键词
let g:ackhighlight = 1
"修改快速预览窗口高度为15
let g:ack_qhandler = "botright copen 10"
"在QuickFix窗口使用快捷键以后，自动关闭QuickFix窗口
let g:ack_autoclose = 1
"使用ack的空白搜索，即不添加任何参数时对光标下的单词进行搜索，默认值为1，表示开启，置0以后使用空白搜索将返回错误信息
let g:ack_use_cword_for_empty_search = 1
"部分功能受限，但对于大项目搜索速度较慢时可以尝试开启
"let g:ack_use_dispatch = 1
"配置ack搜索参数 默认参数是 ” -s -H –nocolor –nogroup –column”
let g:ack_default_options = " -s -H --nocolor --nogroup --column --smart-case"

"ag 快速批量搜索代码，搜索文件, 模糊匹配, 正则表达式 配合ctrlp使用的
" file finder mapping
let g:ctrlp_map = ',p'
" hidden some types files
let g:ctrlp_show_hidden = 1
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.so,*.swp,*.zip,*.pyc,*.png,*.jpg,*.gif,*.tag,*.out,*.file " Windows
let g:ctrlp_working_path_mode = 0
" ignore these files and folders on file finder
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn)$',
  \ 'file': '\.pyc$\|\.pyo$|^tags$|^cscope.files$|^cscope.in.out$|^cscope.po.out$|^cscope.out$|^ncscope.out$',
  \ }
" 使用ag提高效率
if (executable('ag'))
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor
    " Use ag in CtrlP for listing files.
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " Ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

"vim-cpp-enhanced-highlight c++高亮增强
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_concepts_highlight = 1

"YouCompleteMe
    set completeopt=longest,menu
    "离开插入模式后自动关闭预览窗口
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
    "回车即选中当前项
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
    "从第2个键入字符就开始罗列匹配项
    let g:ycm_min_num_of_chars_for_completion=1	
    let g:ycm_autoclose_preview_window_after_completion=1
    "在注释输入中也能补全
    let g:ycm_complete_in_comments = 1
    "在字符串输入中也能补全
    let g:ycm_complete_in_strings = 1
    "注释和字符串中的文字也会被收入补全
    let g:ycm_collect_identifiers_from_comments_and_strings = 0
    "此处是全局配置文件路径
    let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
    "关闭每次导入配置文件前的询问
    let g:ycm_confirm_extra_conf = 0
    "将诊断错误信息写道locationlist
    let g:syntastic_always_populate_loc_list = 1
    "开启语法关键字补全
    let g:ycm_seed_identifiers_with_syntax = 1 
    "开启基于tag的补全，可以在这之后添加需要的标签路径
    let g:ycm_collect_identifiers_from_tags_files = 0
    " 禁止缓存匹配项,每次都重新生成匹配项
    let g:ycm_cache_omnifunc=0
    let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
    " 修改对C函数的补全快捷键，默认是CTRL + space
    let g:ycm_key_invoke_completion = "\<C-x>\<C-h>"
    "打开/关闭编译错误列表
    "nnoremap <leader>eo :lopen<CR>	"open locationlist
    "nnoremap <leader>ec :lclose<CR>	"close locationlist
    "跳转到申明或定义
    nnoremap <leader>ee :YcmCompleter GoToDefinitionElseDeclaration<CR>
    "跳转到定义
    nnoremap <leader>ef :YcmCompleter GoToDefinition<CR>
    "跳转到声明
    nnoremap <leader>el :YcmCompleter GoToDeclaration<CR>

    " 设置在下面几种格式的文件上屏蔽ycm
    let g:ycm_filetype_blacklist = {
          \ 'tagbar' : 1,
          \ 'qf' : 1,
          \ 'notes' : 1,
          \ 'markdown' : 1,
          \ 'unite' : 1,
          \ 'text' : 1,
          \ 'vimwiki' : 1,
          \ 'pandoc' : 1,
          \ 'infolog' : 1,
          \ 'mail' : 1,
          \ 'nerdtree' : 1,
          \}
    let g:ycm_error_symbol = 'EE'
    let g:ycm_warning_symbol = 'WW'
    " ycm的语法检查结果显示 默认为1 开启 设置为0关闭
    let g:ycm_show_diagnostics_ui = 0


"插件管理
"vundle start
set nocompatible " be iMproved, required
filetype off                  " required
"如果没有Vundle先克隆  https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle
" 将Vundle插件的目录添加到gvim的运行时变量中
set rtp+=~/.vim/bundle/Vundle
call vundle#begin()
"call vundle#begin()
"let Vundle manage Vundle, required
"Plugin 'scrooloose/syntastic'
"Plugin 'Lokaltog/vim-powerline'

Plugin 'gmarik/Vundle'
Plugin 'morhetz/gruvbox'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'taglist.vim'
Plugin 'majutsushi/tagbar'
Plugin 'easymotion/vim-easymotion'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'vim-scripts/a.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
"my bundle plugin
call vundle#end()
filetype plugin indent on
"vundle end


