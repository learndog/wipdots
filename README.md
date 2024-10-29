# wipdots
Periodic wip snapshots for temp usage

# Usage Tips

For the default config, \<Leader\> is \<space\>, and it opens vim-whichkey

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

Search
* / to search text in curr buffer (n or N for next or prev)
* :BLines or \<Leader\>fb to fzf lines in the curr buffer (dbl click to go there)
* Toggle highlighting... \<Leader\>h: Toggle highlighting
* TODO: rg fzf search in curr dir and in curr git repos 
* Find text in curr dir recursively from bash... grep -rn -- "my_case_sensitive_target_search_string" (-i for case insensitive)

Buffers
* Switch buffer... \<Leader\>\<Leader\> or \<Leader\>bb
*                  or \<Leader\>b for non fzf buffer selections
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
* TODO - Builtin Keymap Commands... 

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
