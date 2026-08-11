# Possible future feature: last-session restore

Status: **Deferred / not implemented.** This document preserves the analysis and the
ready-to-run implementation sketch so the feature can be added cleanly later, without
re-doing the design work. The current session feature is implemented in
`omarchy/vim/init.vim` section `13. Sessions` and documented in `README.md`.

## What was requested (and why it was deferred)

The idea: an easy, one-keystroke way to get back the **most recently used** session,
separate from the alphabetical `:SessionRestore` picker.

Proposed surface:

- `:SessionRestoreLast` command and a `<Leader>sL` normal-mode mapping (note the
  uppercase `L`; `<Leader>sl` is already the session **list** command).

It was **deferred** because the clean implementation needs a small marker file
(`~/.vim/sessions/.last`) plus an extra command and mapping, and the user wanted to
keep this change minimal and free of a temp file. This document lets a later pass add
it without re-deriving the design.

## Meaning of "used" vs "saved"

- **Most recently saved** = newest file mtime. This is ambiguous and easy to invalidate
  (`touch`, copies, renames, timestamps), and it does not capture "a session I opened
  but did not re-save."
- **Most recently used** = the last session you either *saved* or *restored*. The
  desired semantic. It requires recording a "use" event.

`mksession` has no concept of a "current session," so there is no built-in pointer to
read; a marker file is the natural way to capture it.

## Chosen approach (for the future implementation)

Keep the existing alphabetical picker. Add a dedicated marker-based last-used slot:

1. A marker file `~/.vim/sessions/.last` (hidden, **no** `.vim` extension so it is never
   globbed as a session by `s:SessionFiles()`).
2. Write the session **path** to it from both use paths:
   - `s:SessionSave()` after a successful `mksession!`, and
   - `s:SessionSource()` after a successful `source` (this covers `:SessionRestore name`
     and the picker/scratch sink paths, since they all go through `s:SessionSource`).
3. `:SessionRestoreLast` / `<Leader>sL` reads the marker and `:source`s it; if absent,
   echo `No last session saved or restored yet.`

Do **not** add an automatic startup restore hook (see "Explicitly excluded" below).

## Why a per-`VimEnter` auto-restore hook is not recommended

The backlog idea also floated auto-restoring on startup. It was rejected:

- It changes behavior on every launch and can reopen unrelated windows/fold state/`cwd`,
  conflicting with this config's stated low-risk, predictable-startup goal.
- It can fight an explicit launch intent, e.g. `vim somefile.c`.
- A stale or throwaway session (newest mtime) can win over the one you actually want.
- It needs a `VimEnter` autocommand plus extra guards (dir exists, empty, source failure),
  i.e. more surface than the whole current feature.

The dedicated, explicit `:SessionRestoreLast` command is the safe compromise: one key,
no automatic behavior.

## Implementation sketch (drop-in for the future pass)

Add after the existing `if g:omarchy_use_sessions` block in `init.vim`:

```vim
function! s:SessionLastMarker() abort
  return s:SessionDir() . '/.last'
endfunction

function! s:SessionSave(...) abort
  " ... existing body, but after the successful mksession! add:
  " call writefile([l:path], s:SessionLastMarker())
endfunction

function! s:SessionSource(path) abort
  " ... existing body, but after the successful source add:
  " call writefile([a:path], s:SessionLastMarker())
endfunction

function! s:SessionRestoreLast() abort
  let l:marker = s:SessionLastMarker()
  if filereadable(l:marker)
    let l:path = readfile(l:marker)[0]
    if filereadable(l:path)
      call s:SessionSource(l:path)
      return
    endif
  endif
  echo 'No last session saved or restored yet.'
endfunction

" Inside the `if g:omarchy_use_sessions` block:
command! SessionRestoreLast call <SID>SessionRestoreLast()
" MAP: <Leader>sL | Restore the most recently used session
nnoremap <silent> <Leader>sL :SessionRestoreLast<CR>
```

## Testing for the future pass

- Save a session, then `:SessionRestoreLast` reopens it.
- Restore a *different* existing session via the picker/name, then `:SessionRestoreLast`
  returns to it (proves the marker updates on restore, not just save).
- `~/.vim/sessions/.last` is not listed by `:SessionList` / `:SessionRestore` / `:SessionDelete`.
- Restart Vim (no prior marker) and confirm the friendly "no last session" message.

## Scope summary

| Item | Status |
| --- | --- |
| `13. Sessions` (save / restore / list / delete / status) | Implemented |
| Alphabetical `SessionFiles()` ordering | Implemented |
| `g:omarchy_session_dir`, `g:omarchy_use_sessions` flags | Implemented |
| `:SessionRestoreLast` + `:SessionRestoreLast`-style marker file | Deferred (this doc) |
| Auto-restore-last on startup hook | Explicitly excluded (not recommended) |
