# Basic Usage Tips

For the default .vimrc config, \<Leader\> is \<space\>, and it opens vim-whichkey

Open file for editing
* fzf... :Files (non dot files in directory) or :GFiles (git files)
* \<Leader\>o for file explorer

Editing Tips
* Esc Insert Mode... jj
* Cmd line from normal mode... ;
* Cycle line begin, nonspace begin, nonspace end, line end... ;;
* Copy text... On GCP JupyterLab Terminals use Shift select before Ctrl-C
* Jmp past closing quote or bracket... jl
* Jump to first character after left paren before cursor... jh
* Test - Redraw window... \<Leader\>wr (does :redraw!)
* Fix - Move text block... \<Leader\>ARROW or Ctrl-ARROW (switch window keymap conflict & left/right broken)
* Join two lines, from first line in normal mode... J
* TODO - Don't autoclose at position 1. Move cursor inside quotes (or just use jh/jl?)

Search
* / to search text in curr buffer (n or N for next or prev)
* :BLines or \<Leader\>fb to fzf lines in the curr buffer (dbl click to go there)
* Toggle highlighting... \<Leader\>h: Toggle highlighting
* TODO: rg fzf search in curr dir and in curr git repos 
* Bash - Find text in curr dir recursively... grep -rn -- "my_case_sensitive_target"
*            Case insensitive... grep -irn -- "my_case_insensitive_target"

Buffers
* Switch buffer... \<Leader\>\<Leader\> or \<Leader\>bb
* Delete buffer... :bd

Windows
* Switch windows... \<Leader\>ARROW or Ctrl-ARROW
* Close, Split, etc... \<Leader\>w
* Maximizer Toggle... \<Leader\>m

Commenting
* \<Leader\>/ will comment or uncomment line or visual lines
* \<Leader\>// will comment line or visual lines even if already commented

Vim
* Sessions... \<Leader\>vss and \<Leader\>vsr to save or restore vim sessions
* $MYVIMRC... \<Leader\>vce and \<Leader\>vcr for config edit or reload
* Keymaps... \<Leader\>fml literal or \<Leader\>fmf fuzzy
* Show current keymap for the normal mode K... :map K
* TODO - Add the builtin Keymap Commands...

Python LSP - CoC stuff
* \<Leader\>l prefix
* \<Leader\>r is shortcut for rename symbol
* \<Leader\>lo or \<Leader\>ll for lsp symbol outline with fzf (up arrow or start typing)
* \<Leader\>ld jump to defn
* \<Leader\>li incoming calls to highlighted fn 
* \<Leader\>lI outgoing calls from highlighted fn 
* \<Leader\>lf format
* \<Leader\>ly organize imports
* Shift-K for LSP hover to see fn defn
* CoC problem(?) list...
```
F4 :CocFirst
F5 :CocPrev
F6 :CocNext
F7 :CocLast
```

Cut and Paste                                                                                                                  
* Copy paste from sys clipboard variations...                                                                          
        select: visual mode or select with mouse                                                                       
        copy:   Ctrl-c | Ctrl+Insert | Shift+Insert                                                                    
        copy:   SHIFT select your text, then copy with CTRL+SHIFT+C (from WSL/CA to Windows)                           
        cut: Shift+Del                                                                                                 
        paste:  Ctrl-v | Shift RightClick | middle mouse button                                                        
        replace: copy and then visual select the destination text to replace, then p                                   
                                                                                                                       
        If you paste from system clipboard into vim and get ^M at end of line,                                         
        try instead to enter INSERT mode first, and use Ctrl-v to paste. (Probably a Windows->Linux thing.)            


Git                                                                                                                    
    # To see changes in a vim buffer not yet saved, use <Leader>ds                                                     
    # To see changes in a local saved, unstaged file vs previous commit, use $ git diff                                
    # To see changes in a local saved, staged file vs previous commit, use $ git diff --staged                         
    # To compare two local branches (or remote) use git fetch, and git diff branch1 branch2                            
    # To compare committed changes in a local branch vs remote branch changes between branches use                     
      git, fetch and git diff my_local_branch origin/my_local_branch                                                   
    # To compare two commits use git diff commit1 commit2                                                              
      Use HEAD for last commit. HEAD^ or HEAD~1 for the previous commit.                                               
      HEAD~2, HEAD~3, etc before that.                                                                                 
      HEAD^2 refers to the 2nd parent of the current commit.                                                           
             It is NOT the grandparent of the current commit, and it is only valid for merge commits.                  