" #### SECTION: Open new buffer with a keymap cheat sheet
function! InsertText(text_string)
   " Split the string by lines into a list
   let l:string_list = split(a:text_string, '\n')
   " Create a new buffer
   vnew
   setlocal buftype=nofile
   " Insert the text
   call append(0, l:string_list)
   " execute 'write! ~/.vim/keymap_cheat.txt' " Optionally save the cheat sheet as well.
endfunction
let text_string = " File Operations:\n
         \ autocmd FileType netrw nmap <silent> <buffer> <Esc> :bd<cr>: Close file explorer with Esc\n
         \ <Leader>of: Open current directory\n
         \ <Leader>oe: Open file explorer\n
         \ <Leader>dg: Diff with git\n
         \ <Leader>ds: Diff with saved file\n
         \ \n 
         \ BUFFERS:\n
         \ nnoremap <Leader><space> :Buffer<CR>: Buffer operations\n
         \ nnoremap <Leader>b :Buffer<CR>: Buffer operations\n
         \ <Leader>b: List buffers and prompt for buffer number\n
         \ <Leader>bb: List buffers and prompt (type quickly)\n
         \ <Leader>bn: Go to the next buffer\n
         \ <Leader>bp: Go to the previous buffer\n
         \ <Leader>bf: Go to the first buffer\n
         \ <Leader>bl: Go to the last buffer\n
         \ <Leader>wc: Close the current buffer\n
         \ <Leader>wo: Close all other buffers\n
         \ \n 
         \ WINDOWS\n
         \ Resizing Windows\n
         \ <M-LEFT>:  Decrease vertical size by 10 units.\n
         \ <M-RIGHT>: Increase vertical size by 10 units.\n
         \ <M-UP>:    Increase horizontal size by 5 units.\n
         \ <M-DOWN>:  Decrease horizontal size by 5 units.\n
         \ Moving Between Windows\n
         \ <C-w><LEFT>:  Move to the window on the left.\n
         \ <C-w><DOWN>:  Move to the window below.\n
         \ <C-w><UP>:    Move to the window above.\n
         \ <C-w><RIGHT>: Move to the window on the right.\n
         \ <C-w>h: Move to the window on the left (alternative).\n
         \ <C-w>j: Move to the window below (alternative).\n
         \ <C-w>k: Move to the window above (alternative).\n
         \ <C-w>l: Move to the window on the right (alternative).\n
         \ <C-w><C-w>: Move to the next window.\n
         \ Splitting Windows\n
         \ <C-w>hh: Vertical split at top left (alternative).\n
         \ <C-w>jj:  Vertical split below right (alternative).\n
         \ <C-w>kk: Horizontal split below right (alternative).\n
         \ <C-w>ll: Horizontal split at top left (alternative).\n
         \ <Leader>wh: Vertical split at top left (alternative with leader).\n
         \ <Leader>wj: Vertical split below right (alternative with leader).\n
         \ <Leader>wk: Horizontal split below right (alternative with leader).\n
         \ <Leader>wl: Horizontal split at top left (alternative with leader).\n
         \ Window Management\n
         \ <Leader>wc: Close the current window.\n
         \ <Leader>wo: Keep only the active window open.\n
         \ <Leader>lcp: Close the preview window (e.g., after hover).-l><C-l>: Vertical split below right.\n
         \ \n 
         \ TERMINAL WINDOWS\n
         \ Open Terminal to right: :vert term\n
         \ Open Terminal above:    :term\n
         \ \n 
         \ EDITING:\n
         \ jj: Escape insert mode\n
         \ jl: Escape insert mode and append after end of line\n
         \ <C-O> will escape to normal mode only for ONE command\n
         \ <Leader>h: Toggle highlighting\n
         \ inoremap jl <ESC>%%a: Escape insert mode and append after current line\n
         \ <Leader>m: Toggle Maximizer\n
         \ <Leader>lcp: Close preview window after Hover\n
         \ \n 
         \ FOLDS:\n
         \ <Leader>z: Toggle all folds\n
         \ zM close all folds, zm fold more (decrease fold level)
         \ zc/zC close curr fold(/recursively)\n
         \ zo/zO open curr fold(/recursively)\n
         \ za/zA toggle curr fold(/recursively)\n
         \ zf/zF create manual fold(/recursively)\n
         \ 
         \ \n 
         \ COMMENTING:\n
         \ <Leader>/: Comment or uncomment line/selection\n
         \ <Leader>//: Comment line/selection\n
         \ \n 
         \ NAVIGATION:\n
         \ <C-h>: Move to the previous word (akin to pressing 'B').\n
         \ <C-j>: Scroll forward one full screen (akin to pressing <C-f>).\n
         \ <C-k>: Scroll backward one full screen (akin to pressing <C-b>).\n
         \ <C-l>: Move to the next WORD (akin to pressing 'W').\n
         \ <C-LEFT>: Move to the previous word (akin to pressing 'B').\n
         \ <C-DOWN>: Scroll forward one full screen (akin to pressing <C-f>).\n
         \ <C-UP>: Scroll backward one full screen (akin to pressing <C-b>).\n
         \ <C-RIGHT>: Move to the next WORD (akin to pressing 'W').\n
         \ <silent>0: Cycle position in line\n
         \ <Leader>ge: Go to a specific position\n
         \ <S-UP>: Scroll up a full screen\n
         \ <S-DOWN>: Scroll down a full screen\n
         \ zt, zz, zb move screen so current line is at the top, middle, bottom of the screen
         \ zh, zl scroll screen to the right, to the left\n 
         \ <Leader>n, <F8>: Call CycleLineNumbers\n
         \ \n 
         \ COC ACTIONS:\n
         \ <F4>: CocPrev\n
         \ <F5>: CocNext\n
         \ <F6>: CocFirst\n
         \ <F7>: CocLast\n
         \ <leader>ld: Jump to definition\n
         \ <leader>lr: References\n
         \ <leader>ln: Rename\n
         \ <leader>la: Code Action\n
         \ <leader>lk: Hover information\n
         \ \n 
         \ FUZZY SEARCH:\n
         \ <C-p>: Files\n
         \ <C-s>: Buffer Lines\n
         \ \n 
         \ KEY BINDINGS:\n
         \ <Leader>fm: Call LiteralFindKeyMappings\n
         \ let g:mapleader = ' ': Set the leader key to space\n
         \ let g:maplocalleader = ' ': Set the local leader key\n
         \ \n 
         \ AUTOCOMPLETE AND BRACKETS HANDLING:\n
         \ Various inoremap mappings to handle bracket pairs and quoting\n
         \ \n 
         \ MISCELLANEOUS:\n
         \ <Leader>wr: Redraw screen\n
         \ autocmd BufEnter * silent! vnoremap <silent> <C-_> :<C-u>call VisualCommentUncomment()<CR>: Visual comment/uncomment\n
         \ nnoremap <S-UP> <C-b><C-u>:normal! zz<CR>: Scroll up\n
         \ nnoremap <S-DOWN> <C-f><C-d>:normal! zz<CR>: Scroll down\n
         \ inoremap <S-UP> <C-o><C-b><C-o><C-u><C-o>:normal! zz<CR>: Scroll up in insert mode\n
         \ inoremap <S-DOWN> <C-o><C-f><C-o><C-d><C-o>:normal! zz<CR>: Scroll down in insert mode\n
         \ \n 
         \ VIM-PLUG SETTINGS:\n
         \ PlugInstall: Install all plugins\n
         \ PlugUpdate: Update all plugins\n
         \ PlugClean: Remove unused plugins\n
         \ PlugDiff: Show plugin differences\n
         \ PlugSnapshot: Snapshot the current state of plugins\n
         \ \n 
         \ COMMANDS DEFINED IN .VIMRC FILE\n
         \ CocAction: Perform COC actions.\n
         \ LiteralFindKeyMappings: Find key mappings literally.\n
         \ CycleLineNumbers: Cycle line numbers.\n
         \ MaximizerToggle: Toggle window maximizing.\n
         \ GoToPosition: Go to a specific position.\n
         \ ToggleAllFolds: Toggle all code folds.\n
         \ VisualCommentUncomment: Comment/uncomment visually selected text.\n
         \ ConditionalCommentUncomment: Comment/uncomment conditionally.\n
         \ ToggleZero: Toggle zero.\n
         \ ToggleHighlighting: Toggle highlighting.\n
         \ DiffGIT: Diff current buffer vs git file\n
         \ DiffSaved: Diff unchanged changers in current buffer with last saved file\n
         \ Vb: Visual Block mode (Select then Shift-i to add text to all rows)\n
         \ \n 
         \ ADDITIONAL NOTES:\n
         \ Run :help <command> or :h <command> to get more details on a specific Vim command\n
         \ Search .vimrc for command! to see all vimrc defined commands\n
         \ Search .vimrc for plugin to see plugins\n
         \ Search .vimrc for map to see all the key bindings (or use <Leader>fm)\n
         \ All keymaps are in :map :nmap :imap :vmap (use -u NONE for default VIM bindings only)\n
         \ Plugins will also create additional commands and key bindings\n
         \ Check an actual key value from insert mode with <C-v><C-/>.\n
         \ Note that <C-/> must be mapped as <C-_> due to a common terminal emulator oddity.\n
         \ For mac, try iiterm2 -> Prefs -> Keys + -> Send Text with 'vim' special chars. Enter ,cc\n
         \ DO NOT map <C-W>, it is often mapped to close current OS window by the OS\n
         \ \n
         \ VIM USAGE\n
         \ Search /\n
         \ SearchReplace :%s/oldtext/newtext/cgi where %,c,g,i for whole file, confirm, global, insensitive case\n
         \ \n 
         \ \n 
         \ \n 
         \ "

nnoremap <F2> :call InsertText(text_string)<CR>gg





" ----------------------------------------------------------------------------
" VIM CONFIGURATION USAGE INFORMATION (Including basic vim usage info)
" ----------------------------------------------------------------------------

" #### MISC BASICS
" UndoRedo:
"    u and Ctrl-r (for branches, see vimhelp.org/usr_32.txt.html#32.3)
" Cut/Yank/Paste:
"    visual select then d / y / p (or just dd or yy to select full line, P for Paste before)
"    Y or yy will select to end of line
" Copy/PasteFromSystemClipboard: Seems to vary by platfor. Try...
"    select: visual mode or select with mouse
"    copy:   Ctrl-c | Ctrl+Insert | Shift+Insert
"    cut: Shift+Del
"    paste:  Ctrl-v | Shift RightClick | middle mouse button
"    replace: copy and then visual select the destination text to replace, then p
"    Tip: If you paste from system clipboard into vim and get ^M at end of line,
"         try instead to enter INSERT mode first, and use Ctrl-v to paste. (Probably a Windows->Linux thing.)
" Registers: For CopyPaste and storing macros
"    TODO:
" FileExplorer:
"    :Explore or vim . for built in netrw
"    :help netrw-quickmap (also see gist.github.com/t-mart/610795fcf7998559ea80)
"    vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
" LineNumbers:
"    Toggle with...  set number! set relativenumber! (set nu! and set nu and set nonumber and set norelativenumber)
" RedrawScreen:
"    Ctrl-L (or :redraw)
" RefreshBufferFromFile:
"    :e (or :edit or :edit!)

" #### FIND / REPLACE
" FindInLine: f  For example use ft to find the next 't' on the line. Also works for brackets.
" Find: To override the default case sensitivity, use /findThis\c for case INsensitive or /findThis\C case sensitive
" FindReplace: Search with /mysearchterm<CR> then cgn and type myreplaceterm<ESC> then n/N find agn and . to repeat.
" SubstututeInCurrLine: :s/old/new/g (Curr line is the default range, g means replace all in the range instead of once)
" SubstututeInDocument:
"       :%s/old/new will search and replace ONE occurrence of old by new in the document.
"       :%s/old/new/g (iasdfasdfasdfasdffs) will search and replace all occurrences of old by new in the document.
"       :%s/old/new/gc appended with a "c" requires each change to be confirmed
"       Use :%s|old|new (or any other char) if / is in the search pattern
"       For case sensistivity pppend i(no) or I(yes)

" #### BUFFERS
" Buffers:
"     :Buffers to fuzzy find a buffer name (use up down arrows to choose a different buffer)
"     :new for new buffer in a split window (set splitbelow or set splitright)
"     :enew to edit a new unamed buffer (will fail if changes were made to existing buffer)
"     :open myfilename to open a new buffer with a file (will fail if chgs made to existing buffer)
"     Cycle with :bnext (:bn) and :bprev (:bp)
"     Pick buffer with :b or :b nbr|substr (use tab if more than one filename substring match), :ls to list buffers

" #### FOLDS
" :Zn to set folds to level n
" <Leader>z to toggle folds (Open all, close all)

" #### FILES
" FileFzf: Use :Files
" RipgrepFzf: :Rg [PATTERN] or :RG [PATTERN] (:RG will relaunch as you type)
" GitFileFzf: Use :GFiles   (  See Git status with :GFiles?  )
" MoreFzf: See github.com/junegunn/fzf.vim

" #### MOTION
" GotoLine: Move to line 123 with :123 or use :20+10 to move to line 30 (line 20+10)
" Jumps: :jumps for a list, Ctrl-o / Ctrl-i back and fwd jump, `` or '' bkwd/fwd
" MoveCursor: Shift-Up/DownArrow should page up/down. cf C-D, C-U, C-B, C-F
" ScollButKeepPosition: <C-alt-u> and <C-alt-d>
" MoveLine: :m+1 or :m-2 to move selected lines down or up one (:m+2 for two down, :m-3 for two up) or :m {linenbr}
" MoveLinesUpDown: See config above and vim.fandom.com/wiki/Moving_lines_up_or_down
" PageMotion: Ctrl-b/f to move back/fwd a page, Ctrl-u/d to move half screen up/down
" ScrollButLockCursor: To scroll up/down and keep cursor on same text, use <C-e> or <C-y>
" MoveInScreen: H M L to move cursor to top middle bottom of screen
" CenterInScreen: zt, zz, zb moves current line to top, middle, bottom of screen
" NavigatePreviousLocations: List with :jumps or cap :Jumps for fzf
"    `` or Ctrl+o navigate to the previous location in the jump list (think o as old)
"    '' or Ctrl+i navigate to the next location in the jump list (i and o are usually next to each other)
"    g; go to the previous change location
"    g, go to the newer change location
"    gi place the cursor at the same position where it was left last time in the Insert mode
"    Use :jumps to view the jump list. See :h jump-motions for more details.

" #### WINDOWS
" JumpWindow: Ctrl-w and up/down/right/left or <C-w><C-w> to cycle. WARN: OS may use <C-W> as close window
" ResizeSplit: Ctrl-w +/-/>/<
" SplitWindow: Ctrl-w v (vertical split) or Ctrl-w s (horizontal split)
" CloseWindow: Use :close
" OpenTerminal: Use :term then move it: <C-H/J/K/L>

" #### MANIPULATING TEXT
" Indent: >> or << (normal) and < or > or 2> or 2< (visual mode) - based on shiftwidth
" Increment: Ctrl-a or Ctrl-x to increment or decrement first nbr under cursor or to the right
" Autoindent: =<space> or =<arrow> to autoindent (normal or visual)
" Changes: gi - last cursor pos in insert mode, g; g, for previous or newer chg loc
" WholeWordSearch: * or Shift Click is fwd from cursor position, # is bkwd
" PartialWordSearch: g*, g# fwd and backward from cursor positiona
" UpperOrLowerCase: gU or gu (eg gue, gu$, guiw)
" DeleteAnd: s/S del char/line and insert, C del to eol and insert, R for replace mode

" #### VIM MODES
" Replace Mode: Use R to type over characters. <ESC> to exit replace mode
" Binary mode: Open a file in binary mode with -b option flag
"                 which sets textwidth and wrapmargin to 0 and turns off modeline and expantab.
"              Use :%!xxd command for editable hex dump (offset, hex bytes, ascii)
"              Then :%!xxd-r to reverse it. (Don't forget to :')
"              Note that offset is for first byte of each line. Modifications on Ascii will be IGNORED!!!!!
"

" #### LSP - COC
" <Leader>o Outline with fuzzy find

" #### BRACKETS
" FindBracketsInLine: f  For example use f( to find the next ( on the line. Not just for brackets.
"                     F  Same, but find previous bracket.
"                     % will select the matching bracket (or opening bracket if cursor is inside)
" SelectInside: vi( or vi[ or vi" etc for selecting the content inside the brackets
" ChangeInside: ci( to delete inside brackets and insert mode
" ClearHighlighting:   Use :noh
" Good Linux Terminal Utils: lazygit and github.com/ibraheemdev/modern-unix)
" FromInsideParens:
"
"

" SECTION: Mapping limitations
" ctrl/alt/shift-key ;+-,.' cannot be mapped and ctrl upper/lower cant be distinguished
" Do not map on top of important mappings. Also preserve combos needed for tmux
" See :map for all vim key mappings (to see defaults, launch with -u NONE)
"     :nmap :vmap :imap for mode specific mappings


" #### KEY BINDING INFORMATION
" VIM Default Key Bindings
" :help normal-index in Vim (or insert-index, visual-index, ex-edit-index)
" for a comprehensive list of default key bindings before plugins or .vimrc files.
"
" Additional key bindings from plugins or configuration
" :map   has all, :nmap :vmap :imap for normal, visual, insert mode mappings only
"
" <Leader>fm  for fuzzy search for key bindings (can set in .vimrc to use fuzzy or literal search patterns)
"
" <Leader>    for <leader> bindings only
"
" :verbose map <Leader>;   will show all leader mappings

" #### VIM DEBUGGING
" :messages to see all error messages
" TBD