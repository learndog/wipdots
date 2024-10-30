# Basic Usage Tips

For the default .vimrc config, \<Leader\> is \<space\>, and it opens vim-whichkey

Open file for editing
* fzf... :Files (non dot files in directory) or :GFiles (git files)
* In netrw... \<Leader\>o for file explorer
* In nvimtree (nvim only)... \<Leader\>e for file explorer

Editing Tips
* Esc Insert Mode... jj
* Cmd line from normal mode... ;
* Cycle line begin, nonspace begin, nonspace end, line end... ;;
* Copy text... On GCP JupyterLab Terminals use Shift select before Ctrl-C
* Jmp past closing quote or bracket... jl
* Jump to first character after left paren before cursor... jh
* Fix - Move text block... \<Leader\>ARROW or Ctrl-ARROW (switch window keymap conflict & left/right broken)
* Join two lines, from first line in normal mode... J
* TODO - Don't autoclose at position 1. Move cursor inside quotes (or just use jh/jl?)

Moving Text (Visual line selections only)
* Indent/Outdent... < and < after selecting lines (use . to repeat)
* Move and keep selection... \<Leader\>ARROW

Search
* / to search text in curr buffer (n or N for next or prev)
* :BLines or \<Leader\>fb to fzf lines in the curr buffer (dbl click to go there)
* Toggle highlighting... \<Leader\>h: Toggle highlighting
* TODO: rg fzf search in curr dir and in curr git repos 
* Bash - Find text in curr dir recursively... grep -rn -- "my_case_sensitive_target"
*            Case insensitive... grep -irn -- "my_case_insensitive_target"

Buffers
* Switch buffer... \<Leader\>\<Leader\> or \<Leader\>bb (\<Leader\>b if fzf not available)
* Delete buffer... :bd

Windows
* Switch windows... \<Leader\>ARROW or Ctrl-ARROW
* Close, Split, etc... \<Leader\>w
* Maximizer Toggle... \<Leader\>m

Folds
* Toggle folding... \<Leader\>z
* Set fold level... :Z0 (collapse all) thru :Z9 (expand 9 levels)
* Built in fold commands
```
zf in Visual mode: Create a fold for the selected text.
zd: Delete the fold at the cursor.
zE: Delete all folds in the current window.
zo: Open a fold at the cursor (unfold).
zc: Close a fold at the cursor.
```

Commenting
* \<Leader\>/ will comment or uncomment line or visual lines
* \<Leader\>// will comment line or visual lines even if already commented

Vim
* Sessions... \<Leader\>vss and \<Leader\>vsr to save or restore vim sessions
* $MYVIMRC... \<Leader\>vce and \<Leader\>vcr for config edit or reload
* Redraw window... \<Leader\>wr (does :redraw!)
* After accidental Ctrl-z, return with $ fg

Key Mappings
* fzf keymaps... :Maps or \<Leader\>fml literal or \<Leader\>fmf fuzzy
* Current normal mode keymap(s) for K... :map K
* TODO - Add the builtin Keymap Commands...

Python LSP - CoC stuff
* \<Leader\>l prefix
* \<Leader\>r is shortcut for rename symbol
* \<Leader\>lo or \<Leader\>ll for lsp symbol outline with fzf (up arrow or start typing)
* \<Leader\>ld jump to defn
* \<Leader\>li incoming calls to highlighted fn (when done, click on Incoming Calls title and ESC)
* \<Leader\>lI outgoing calls from highlighted fn  (when done, click on Outgoing Calls title and ESC)
* \<Leader\>lf format
* \<Leader\>la fzf list of problems (F4/F5/F6/F7 for first/prev/next/last)
* \<Leader\>ly organize imports
* \<Leader\>lc code actions for curser location
* \<Leader\>ls code actions for source code
* Shift-K for LSP hover to see fn defn

Cut and Paste                                                                                                                  
* Copy paste from sys clipboard variations...                                                                          
        select: visual mode or select with mouse                                                                       
        copy:   Ctrl-c | Ctrl+Insert | Shift+Insert    
        copy:   SHIFT select your test, then copy with Ctrl-C (GCP JupyterLab terminal)
        copy:   SHIFT select your text, then copy with CTRL+SHIFT+C (from WSL/CA to Windows)                           
        cut: Shift+Del                                                                                                 
        paste:  Ctrl-v | Shift RightClick | middle mouse button                                                        
* Vim copy/replace: copy and then visual select the destination text to be replaced, then p                                   
                                                                                                                       
        Note: If you paste from system clipboard into vim and get ^M at end of line,                                         
              try instead to enter INSERT mode first, and use Ctrl-v to paste. (Probably a Windows->Linux thing.)            

Git                                                                                                                    
    # If fugitive is avail, fzf current buffer git history... :BCommits   or project git history... :Commits
    # :Blame - Git blame using a bash git command (:bd to remove the results window)
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
