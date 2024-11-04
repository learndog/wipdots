# Basic Usage Tips

    * The following information is focused on Python (just like the whole vim config)
    * For the default .vimrc config, Leader is space, and it opens vim-which-key (which-key on nvim)
    * WARNING: In GCP JupyterLab in a Vertex AI VM, Ctrl-W by default will close the browser tab!!!!
    * WHY USE THIS?
       - Works in browser based terminal consoles (like GCP console or VertexAI JupyterLab terminals)
       - Prevent lost file edits - Network disruptions in GCP JupyterLab cause lost changes on the std editor
       - Vim everywhere - use in any terminal emulator - one editor builds muscle memory and reduces congnitive load
       - Vim endures - eg VSCode may look different in the future, and serve MS purposes instead of yours
       - Plugin Security - optionally review and freeze for full control of what you are running
       - Customize everything - make the editor work for you
       - Some downsides... utilitarian UI, learning curve, keystrokes and behavior can be inconsistent or unintuitive,
                           no proprietary lsp (eg MS pylance)

Open file in vim for editing
* vim file1 file2 file3 etc for multiple files (in vim use... :edit file)
* view file to open as read only (in vim use... :view file)
* :Files (non dot files in directory) or :GFiles (git files) for opening with fzf file lists
* Leader-e for file explorer prefix
* Leader-ee to toggle nvimtree window
* In netrw... 
  * Single mouse click to select folder or item
  * :help netrw-quickcom
  * :help netrw-quickmap
  * :help netrw-browse-cmds
* In nvimtree (nvim only)...
  * Ctrl-] to make current folder the root of the tree
  * Dbl click header or type "-" to chg root dir
  * Dbl click or Enter to open file or open/close folder

Navigation
* Std vim navigation
*   gg for top, G for bottom
*   Arrows or hjkl to move around
*   Shift-ARROW to page up or down (but not for UI widgets)
*   H/M/L to move to top, middle or bottom of screen
*   Ctrl-o and Ctrl-i to jump to prev or next location in jummp list
*   In command autocomplete, use Tab and Shift-Tab
*   Exit pop up splits with ESC or q or :bd
* Insert mode ;; will cycle begin and end of line
* Esc Insert Mode... jj or ESC
* Insert or Normal... ;; will cycle line begin, nonspace begin, nonspace end, line end
* Normal mode ; is command line
* Jmp past closing quote or bracket... jl
* Jump to first character after left paren before cursor... jh
* Shift cursor up or down along with text... Ctrl-e or Ctrl-y
* Move current line to top, middle, bottom of screen... zt, zz, zb
* Reverse nav by word... w is fwd by word, W is bkwd by word; b is back word, B is fwd word
* zh and zl move along screen viewport right and left along a line (has been supercharged to 25 cols per move)

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
* Non-yank Del key... it will not change the yank buffer when you delete with the Del key (not the std Vim behavior)

More Editing
* u in normal mode to undo, Ctrl-r to redo
* Vim clipboard...    Shift-V to select lines, v to select characters
*                     y to copy, d to cut, p to paste (yy and dd for current line)
* System clipboard... Copy text on GCP JupyterLab Terminals with Shift and mouse select, then Ctrl-c
*                     Paste system clipboard with Ctrl-p
* J from the first line in normal mode will join the next line at the end of it
* Leader-ARROW to move visual line selections around (will switch windows if no selection)
* Insert text into multiple lines before cursor column
    Enter visual block mode with :Vb
    Arrows to highlight lines to act on
    Shift-i to type the text to insert
    ESC to act on all the lines

Commenting
* Leader-/ will comment or uncomment current line or visual lines
* Leader-// will comment current line or visual lines even if already commented

Moving Text (Visual line selections only)
* Move and keep selection... Leader-ARROW
* Indent/Outdent... < and > after selecting lines (use . to repeat)

Search
* / to search text in curr buffer (n or N for next or prev; \ as escape character)
* :%s/search/replace/gc - search and replace with confirmation
     where % is all lines in the file; g is global... all occurances in the line; c for confirm
  or :LINENBRs/old/new/gc
  or :STARTLINENBR,ENDLINENBRs/old/new/gc where line numbers can be
        1 - first line
        $ - last line
        . - current line
        +2 - the line two below the current line
        Note: Ranges must be from smaller line nbr to larger line nbr or will get error
        Note: Line nbr ranges are inclusive
        eg :23s/old/new/gc will replace only on line 23
        eg :10,20s/old/new/gc will replace from line 10-20
        eg :.,+2s/old/new/gc will replace from current line to the line 2 below the current line
  Note: Problematic characters that need escaping... /,&,\,*,.
        Can escape with \
        Can use a different old/new delimiter character like #, eg :%s#/home#/root#g
* Toggle highlighting... Leader-h: Toggle highlighting
* :BLines or Leader-fb to fzf lines in the curr buffer (dbl click to go there)
* Find text in curr dir recursively in bash... grep -rn -- "my_case_sensitive_target"
*       Case insensitive... grep -irn -- "my_case_insensitive_target"

Buffers
* Switch buffer... Leader-Leader or Leader-bb (or Leader-b if fzf not available)
* Delete buffer... :bd

Windows
* Window operations use Leader-w prefix
* Switch windows... Leader-ARROW
* Close, Split, etc... Leader-w
    Close window... :q   (closing a window will keep the buffer)
    Horiz split command... :split or :sp
    Vert split command...  :vsplit or :vsp
* Maximizer Toggle... Leader-m
* Resize with META-ARROW (Alt key usually) but it may not work. 
    Try dragging the divider line with a mouse.
* Switch splits
    From Vertical to Horiz split... Leader-wK  (also CtrlW-K)
    From Horiz to Vertical split... Leader-wH  (also CtrlW-H)

Folds
* Toggle folding... Leader-z
* Set fold level... :Z0 (collapse all) thru :Z9 (expand 9 levels)
* Built in fold commands
    ```
    zf in Visual mode: Create a fold for the selected text
    zd: Delete the fold at the cursor
    zE: Delete all folds in the current window
    zo: Open a fold at the cursor - unfold it
    zv: Open folds for this line
    zc: Close a fold at the cursor
    za: Toggle a fold at the cursor
    zM: Close all folds
    zR: Open all folds
    zm: Fold more
    zr: Fold less
    zx: Update folds
    ```

Macros
    ```
    qa          " Start recording into register 'a' (Can use any single letter or digit)
    <commands>  " Perform the commands you want to record
    q           " Stop recording keystrokes
    
    @a          " Run the macro at the current position
    @@          " Run the last run macro again at the current position
    ````

Diffs    
* Open a split with two files, and on each one issue the command :diffthis to see the differences side by side
    OR from bash $ vimdiff file1 file2
    Commands...
    ```
        ]c or [c - move to next or prev difference
        do - :diffget - 'obtain' the changes from other window (visually on left, so "o" key)
        dp - :diffput - put the curr version into a new window (visually on right, so "p" key)
        :diffupdate - rescan the files for new changes
        :diffoff - turn off diff mode
    ```

Git                                                                                                                    
* :BCommits - current buffer git history fzf
* :Commits  - project git history fzf
* :Blame    - git blame using a bash git command (:bd to remove the results window)
* Leader-ds - See changes in a vim buffer, not yet saved
* $ git diff          - See changes in a local saved, unstaged file vs previous commit
* $ git diff --staged - See changes in a local saved, staged file vs previous commit
* $ git fetch and git diff branch1 branch2 - Compare two local branches (or remotes)
* $ git fetch and git diff my_branch origin/my_branch - Compare committed changes in local branch vs remote branch                     
* $ git diff commit1 commit2 - Compare two commits 
    > Use HEAD for last commit
    > HEAD~1 for the previous commit, HEAD^ is the prev parent
    > HEAD~2, HEAD~3, etc for earlier commits                                                                                 
    > HEAD^2, HEAD^3, etc for earlier parents (only valid for merge commits)                                                           
* Use vimdiff for git merge conflicts
  * see https://gist.github.com/karenyyng/f19ff75c60f18b4b8149/e6ae1d38fb83e05c4378d8e19b014fd8975abb39
  * see https://stackoverflow.com/questions/3713765/viewing-all-git-diffs-with-vimdiff  
  * $ git config merge.tool vimdiff # Set default merge tool
  * Optionally leave out the merge reesult... $ git config merge.conflictstyle diff3 # vimdiff4 is the default
  * Optionally don't prompt before launching the merge resolution tool... $ git config mergetool.prompt false
  * Merge tool will come up in vimdiff with this layout...
    +--------------------------------+
    | LOCAL  |     BASE     | REMOTE |
    +--------------------------------+
    |             MERGED             |
    +--------------------------------+
    where
        LOCAL - the head for the file(s) from the current branch on the machine that you are using
        REMOTE - the head for files(s) from a remote location that you are trying to merge into your LOCAL branch
        BASE - the common ancestor(s) of LOCAL and BASE
        MERGED - the tag / HEAD object after the merge - this is saved as a new commit
  * Manually edit the MERGED split, or use vim shortcuts to pull bits as desired...
    ```
        ]c or [c - move to next or prev difference (unfortunately all chgs from BASE, not just the conflicts)
        :diffg RE  # get from REMOTE
        :diffg BA  # get from BASE
        :diffg LO  # get from LOCAL
    ```
  * Then save all changes (:wqa, which will send you to the next conflicted file) 
        LOCAL, BASE and REMOTE are temporary files, so don't worry about saving them accidentally
  * Also remember to git add and git merge --continue (which will internally check for conflict resolution and do a merge commit)
        or instead of continue, you can do git commit -m "merged from branch ABC"

Vim
* Sessions... Leader-vss and Leader-vsr to save or restore vim sessions
* $MYVIMRC... Leader-vce and Leader-vcr for config edit or reload
* Colorschemes... Leader-vt
* Redraw window... Leader-wr (does :redraw!)
* After accidental Ctrl-z, return with $ fg
* Leader-vw... Find all vim swap files in curr dir recursively

See Key Mappings and Commands
* Show help file for builtin commands with keymaps... Leader-fmh or :help index
* Verbose list of keymaps... :verbose_map
* Search builtin normal mode commands... Leader-fmb or :NormalModeKeybinds
* Search custom keymaps... :Maps or Leader-fml literal or Leader-fmf fuzzy
* List custom keymaps... :map (and by mode... :nmap :vmap :imap), Can filter for K, eg... :nmap K

Python LSP - CoC stuff
* Leader-l prefix
* Shift-K for LSP hover to see fn defn
* Ctrl-Space(vim) or Ctrl-@(nvim..maybe) to trigger autocomplete (if not already available)
* Leader-ln to rename symbol
* gd or Leader-ld jump to defn
* gr for fzf references (incoming calls) BONUS...Select item, then Tab for menu of actions
* gi or Leader-li show coctree with incoming calls to highlighted fn (when done, click on Incoming Calls title and ESC)
* go or Leader-lI show coctree with outgoing calls from highlighted fn  (when done, click on Outgoing Calls title and ESC)
* Leader-lf format
* Leader-ly organize imports
* Leader-lo or Leader-ll for lsp symbol outline with fzf (up arrow or start typing)
* Leader-la fzf list of problems (F4/F5/F6/F7 for first/prev/next/last)
* Leader-lc code actions for curser location
* Leader-ls goto symbol
* Leader-lof or :call CocShowFilteredSymbols('Function') List and goto symbol location
  dbl click to close and must switch windows back to source to see location unless it must scroll the window
* :CocList diagnostics for a list of linter problems. Dbl click on item to go there
  or use [g and ]g for next and prev 

Terminal
* Terminal commands are prefix Leader-t
* :term for split above, ie horiz split (i is req'd in nvim to type commands)
* :vsplit term for vertical split
* :tab term for terminal in a new tab
* nvim open term in same buffer... :enew | term (plus type i)
* :bd to delete the terminal buffer
* In nvim... Ctrl-W q to close the term window (but keep the buffer)
* In nvim... Ctrl-W " to paste into the terminal from Vim

Python terminal debugger
*    builtin...     pdb. Always available with python.
*    enhanced...    pdb++ at https://github.com/pdbpp/pdbpp
                    adds syntax highlighting, completion and convenience functions
*    for iPython... ipdb (https://ipython.readthedocs.io/en/stable/interactive/reference.html#using-the-python-debugger-pdb)
                    Use... pip install ipdb
                    See https://www.skillshats.com/blogs/debugging-made-easy-with-ipdb-the-python-debugger/
                    See https://medium.com/@lindata/a-beginners-guide-to-debugging-with-ipdb-set-trace-3d44f079f871
                    is part of iPython and works with Jupyter notebooks
*    with TUI...    pudb at https://github.com/inducer/pudb
                    See https://documen.tician.de/pudb/starting.html
                    And smry usage at https://www.kimsereylam.com/python/2020/01/17/debug-python-with-pudb.html
                    Easy for beginners
     Note: There are several ways to handle the import and breakpoints in a simpler fashion.
     Eg for pudb...
     1. Set env var PYTHONBREAKPOINT and then use breakpoint() in the script
        In bash... export PYTHONBREAKPOINT=pudb.set_trace
        and in the python script put... import pudb; pu.db
        and set breakpoints in the script as... breakpoint()  # This will trigger pudb based on the PYTHONBREAKPOINT environment
        and run as...  python my_script.py
     2. Run the script as... python -m pudb.run my_script.py
        to start pudb and run my_script.py without requiring you to modify the script to include import pudb; pu.db.
     3. Or do the import from command line when running the script as... 
        python -c "import pudb; pu.db; exec(open('my_script.py').read())"

Troubleshooting LSP
* :CocInfo             for detailed info about active language servers and any errors
* :CocList services    to see language servers currently running for the file type 
* :CocList extensions  for detailed information on loaded extensions
* :CocCommand workspace.showOutput (choose what to output, but don't save the resulting buffer) 


