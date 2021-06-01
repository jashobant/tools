" C Call-Tree Explorer (CCTree) <CCTree.vim>
"
"
" Script Info and Documentation
"=============================================================================
"    Copyright: Copyright (C) August 2008 - 2011, Hari Rangarajan
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               cctree.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damamges
"               resulting from the use of this software.
"
" Name Of File: CCTree.vim
"  Description: C Call-Tree Explorer Vim Plugin
"   Maintainer: Hari Rangarajan <hari.rangarajan@gmail.com>
"          URL: http://vim.sourceforge.net/scripts/script.php?script_id=2368
"  Last Change: June 10, 2012
"      Version: 1.61
"
"=============================================================================
"
"  {{{ Description:
"       Plugin generates dependency-trees for symbols using a cscope database
"  in Vim.
"  }}}
"  {{{ Requirements: 1) Vim 7.xx , 2) Cscope
"
"                Tested on Unix and the following Win32 versions:
"                + Cscope, mlcscope (WIN32)
"                       http://code.google.com/p/cscope-win32/
"                       http://www.bell-labs.com/project/wwexptools/packages.html
"  }}}
"  {{{ Installation:
"               Copy this file to ~/.vim/plugins/
"               or to /vimfiles/plugins/  (on Win32 platforms)
"
"               It might also be possible to load it as a filetype plugin
"               ~/.vim/ftplugin/c/
"
"               Need to set :filetype plugin on
"
"  }}}
"  {{{ Usage:
"           Build cscope database, for example:
"           > cscope -b -i cscope.files
"               [Tip: add -c option to build uncompressed databases for faster
"               load speeds]
"
"           Load database with command ":CCTreeLoadDB"
"           (Please note that it might take a while depending on the
"           database size)
"
"           Append database with command ":CCTreeAppendDB"
"            Allows multiple cscope files to be loaded and cross-referenced
"            Illustration:
"            :CCTreeAppendDB ./cscope.out
"            :CCTreeAppendDB ./dir1/cscope.out
"            :CCTreeAppendDB ./dir2/cscope.out
"
"           A database name, i.e., my_cscope.out, can be specified with
"           the command. If not provided, a prompt will ask for the
"           filename; default is cscope.out.
"
"           To show loaded databases, use command ":CCTreeShowLoadedDBs"
"
"           To unload all databases, use command ":CCTreeUnLoadDB"
"            Note: There is no provision to unload databases individually
"
"           To save the current set of databases loaded in to memory onto disk
"           in native CCTree XRef format, use command ":CCTreeSaveXRefDB"
"
"           To load a saved native CCTree XRef format file, use
"           command ":CCTreeLoadXRefDB"
"
"           To load a saved native CCTree XRef format file, use
"           command ":CCTreeLoadXRefDBFromDisk"
"
"           Notes: No merging database support for CCTree native DB's [at present].
"
"
"            To have multiple CCTree preview windows, use ":CCTreeWindowSaveCopy"
"            Note: Once saved, only the depth of the preview window can be changed
"
"           Default Mappings:
"             Get reverse call tree for symbol  <C-\><
"             Get forward call tree for symbol  <C-\>>
"             Increase depth of tree and update <C-\>=
"             Decrease depth of tree and update <C-\>-
"
"             Open symbol in other window       <CR>
"             Preview symbol in other window    <Ctrl-P>
"
"              Save copy of preview window       <C-\>y
"             Highlight current call-tree flow  <C-l>
"             Compress(Fold) call tree view     zs
"             (This is useful for viewing long
"              call trees which span across
"              multiple pages)
"
"           Custom user-mappings:
"           Users can custom-map the short-cut keys by
"           overriding the following variables in their
"           Vim start-up configuration
"
"            g:CCTreeKeyTraceForwardTree = '<C-\>>'
"            g:CCTreeKeyTraceReverseTree = '<C-\><'
"            g:CCTreeKeyHilightTree = '<C-l>'        " Static highlighting
"            g:CCTreeKeySaveWindow = '<C-\>y'
"            g:CCTreeKeyToggleWindow = '<C-\>w'
"            g:CCTreeKeyCompressTree = 'zs'     " Compress call-tree
"            g:CCTreeKeyDepthPlus = '<C-\>='
"            g:CCTreeKeyDepthMinus = '<C-\>-'
"
"          Command List:
"             CCTreeLoadDB                <dbname>
"             CCTreeAppendDB              <dbname>
"             CCTreeLoadXRefDB            <dbname>
"             CCTreeSaveXRefDB            <dbname>
"             CCTreeLoadXRefDBFromDisk    <dbname>
"
"             CCTreeUnLoadDB
"             CCTreeShowLoadedDBs
"
"             CCTreeTraceForward          <symbolname>
"             CCTreeTraceReverse          <symbolname>
"             CCTreeRecurseDepthPlus
"             CCTreeRecurseDepthMinus
"             CCTreeWindowSaveCopy
"
"          Only in preview window:
"             CCTreeWindowHiCallTree   (same as <C-l> shorcut)
"                   Highlight calling tree for keyword at cursor
"
"          Dynamic configuration:
"             CCTreeOptsEnable <option>    (<tab> for auto-complete)
"             CCTreeOptsDisable <option>   (<tab> for auto-complete)
"             CCTreeOptsToggle <option>   (<tab> for auto-complete)
"             Options:
"                   DynamicTreeHiLights: Control dynamic tree highlighting
"                   UseUnicodeSymbols: Use of UTF-8 special characters for
"                                      tree
"                   UseConceal: Use (+Conceal) feature instead of 'ignore'
"                               syntax highlighting. Allows CCTree window
"                               to be exported in HTML without syntax markup
"                               characters. (Vim 7.3+ only)
"                   EnhancedSymbolProcessing: Cross-reference enums, macros,
"                               global variables, typedefs (Warning: Database
"                               processing speeds will be slow).
"
"
"
"          Settings:
"               Customize behavior by changing the variable settings
"
"               UTF-8 usage:
"                   UTF-8 symbols should work fine on the majority of
"               X11 systems; however, some terminals might cause problems.
"
"               To use symbols for drawing the tree, this option can be enabled.
"                   g:CCTreeUseUTF8Symbols = 1
"               The options interface (CCTreeOptsxxx) can be used to
"               modify options on-the-fly.
"
"               Cscope database file, g:CCTreeCscopeDb = "cscope.out"
"               Maximum call levels,   g:CCTreeRecursiveDepth = 3
"               Maximum visible(unfolded) level, g:CCTreeMinVisibleDepth = 3
"               Orientation of window,  g:CCTreeOrientation = "topleft"
"                (standard vim options for split: [right|left][above|below])
"
"               Use Vertical window, g:CCTreeWindowVertical = 1
"                   Min width for window, g:CCTreeWindowMinWidth = 40
"                   g:CCTreeWindowWidth = -1, auto-select best width to fit
"
"               Horizontal window, g:CCTreeWindowHeight, default is -1
"
"
"               Display format, g:CCTreeDisplayMode, default 1
"
"               Values: 1 -- Ultra-compact (takes minimum screen width)
"                       2 -- Compact       (Takes little more space)
"                       3 -- Wide          (Takes copious amounts of space)
"
"               For vertical splits, 1 and 2 are good, while 3 is good for
"               horizontal displays
"
"               NOTE: To get older behavior, add the following to your vimrc
"               let g:CCTreeDisplayMode = 3
"               let g:CCTreeWindowVertical = 0
"
"               Syntax Coloring:
"                    CCTreeSymbol is the symbol name
"                    CCTreeMarkers include  "|","+--->"
"
"                    CCTreeHiSymbol is the highlighted call tree functions
"                    CCTreeHiMarkers is the same as CCTreeMarkers except
"                           these denote the highlighted call-tree
"
"
"                    CCTreeHiXXXX allows dynamic highlighting of the call-tree.
"                    To observe the effect, move the cursor to the function to
"                    highlight the current call-tree. This option can be
"                    turned off using the setting, g:CCTreeHilightCallTree.
"                    For faster highlighting, the value of 'updatetime' can be
"                    changed.
"
"               Support for large database files:
"                 Vimscript does not have an API for reading files line-by-line. This
"                becomes a problem when parsing large databases. CCTree can overcome
"                the limitation using an external utility (i.e., GNU coreutils: split)
"                or VimScript's perl interpreter interface (:version must indicate +perl)
"
"                The following settings are tailored to suit GNU coreutils split; the default
"                settings should work with no changes on typical linux/unix distros
"                (Monopoly OSes will require installation of unixutils or equivalent)
"
"                External command is setup with the following parameters:
"                g:CCTreeSplitProgCmd = 'PROG_SPLIT SPLIT_OPT SPLIT_SIZE IN_FILE OUT_FILE_PREFIX'
"
"                Break-down of individual parameters:
"                The split utility is assumed to be on the path; otherwise, specify full path
"                            g:CCTreeSplitProg = 'split'
"
"                Option for splitting files (-C or -l)
"                            g:CCTreeSplitProgOption = '-C'
"                 If split program does not support -C, then this parameter must be set to
"                 the number of lines in the split files
"                         g:CCTreeDbFileSplitLines = -1
"                Largest filesize Vimscript can handle; file sizes greater than this will
"                be temporarily split
"                        g:CCTreeDbFileMaxSize  = 40000000 (40 Mbytes)
"
"                Sample system command:
"                Typical:
"                        split -C 40000000 inputFile outputFilePrefix
"
"                 When g:CCTreeDbFileSplitLines is set to 10000 (-C options will be ignored)
"                        split -l 10000 inputFile outputFilePrefix
"
"
"                Using perl interface:
"                        By default, perl usage is disabled. Set
"                        g:CCTreeUsePerl = 1  to enable the perl interface.
"
"                        Perl interface is typically faster than native Vimscript.
"                        This option can be used independent of the file size
"
"                        For more info on setting up perl interface
"                        :help perl-using or :help perl-dynamic
"
"               Writing large Xref Databases:
"                   CCTree can use external utilities to write extremely large files beyond
"               VimScripts capabilities. It requires the use of an external tool that can
"               join text files (i.e., 'cat' in unix). This utility is triggered if the size
"               of the file being written exceeds g:CCTreeDbFileMaxSize (40 Mb or as configured)
"
"               The join utility command is configured by default as follows:
"               let CCTreeJoinProgCmd = 'PROG_JOIN JOIN_OPT IN_FILES > OUT_FILE'
"
"               let  g:CCTreeJoinProg = 'cat'           " PROG_JOIN
"               let  g:CCTreeJoinProgOpts = ""          " JOIN_OPT
"
"
"  }}}
"  {{{ Limitations:
"           Basic Symbol Processing:
"               The accuracy of the call-tree will only be as good as the cscope
"           database generation.
"               NOTE: Different flavors of Cscope have some known
"                 limitations due to the lexical analysis engine. This results
"                 in incorrectly identified function blocks, etc.
"           Enhanced Symbol Processing:
"               (1) Cscope does not mark-up nameless enums correctly; hence,
"               CCTree cannot recognize nameless enum symbols.
"  }}}
"  {{{ History:
"           Version 1.61: June 10, 2012
"                 1. Compability patch for change in tag file format starting
"                 from ccglue version 0.6.0
"           Version 1.60: July 14, 2011
"                 1. Speed-up call-tree depth manipulation using incremental
"                 updates
"           Version 1.55: June 20, 2011
"                 1. Speed-up syntax highlighting by restricting to visible
"                 area (Note: To export to HTML, run TOhtml command on cctree window 
"                 copy to get complete highlighted call-tree) 
"           Version 1.53: June 17, 2011
"                 1. Bug fix related to appending cscope databases
"                 2. Bug fix related to loading xref databases
"           Version 1.51: May 18, 2011
"                 1. Robust error reporting when external (split/cat) utils fail
"           Version 1.50: May 6, 2011
"                 1. Support cross-referencing of global variables, macros,
"                    enums, and typedefs.
"           Version 1.40: April 22, 2011
"                 1. Maintain order of functions called during forward tracing
"           Version 1.39: April 18, 2011
"                 1. Use +Conceal feature for highlighting (only Vim 7.3)
"           Version 1.33: April 5, 2011
"                 1. Load and trace CCTree native XRefDb directly from disk
"                 2. Fix AppendDB command when 'ignorecase' is set
"           Version 1.26: March 28, 2011
"                 1. Fix macro cross-referencing limitation
"                 2. Correct native xref file format
"           Version 1.21: March 21, 2011
"                 1. Support serialization of loaded
"                           cscope databases (for faster loading)
"           Version 1.07: March 09, 2011
"                 1. Fix new keymaps incorrectly applied to buffer
"                 2. CCTreeOptsToggle command for toggling options
"
"           Version 1.04: March 06, 2011
"                 1. Customization for key mappings
"                 2. Dynamic configuration of UI variables
"                 3. Folding long call-trees to show current path dynamically
"
"           Version 1.01: March 04, 2011
"                 1. Make UTF-8 symbols for tree optional
"
"           Version 1.00: March 02, 2011
"                 1. Staging release for upcoming features
"                    - Complete refactoring of code to take
"                           advantage of VimScript's OO features
"                 2. Faster decompression of symbols
"                 3. Display related changes
"                    - Use of unicode symbols for tree
"                 4. Bugfixes related to multi-database loading
"
"            Version 0.90: February 18, 2011
"                  1. Support for large databases using external split utility or perl
"                     interface
"
"           Version 0.85: February 9, 2011
"                 1. Significant increase in database loading and decompression speeds
"
"           Version 0.80: February 4, 2011
"                 1. Reduce memory usage by removing unused xref symbols
"
"           Version 0.75: June 23, 2010
"                     1. Support for saving CCTree preview window; multiple
"                        CCTree windows can now be open
"
"          Version 0.71: May 11, 2010
"                     1. Fix script bug

"           Version 0.70: May 8, 2010
"                     1. Functionality to load multiple cscope databases
"
"           Version 0.65: July 12, 2009
"                     1. Toggle preview window
"
"           Version 0.61: December 24, 2008
"                 1. Fixed bug when processing include files
"                 2. Remove 'set ruler' option
"
"           Version 0.60: November 26, 2008
"                 1. Added support for source-file dependency tree
"
"           Version 0.50: October 17, 2008
"                 1. Optimizations for compact memory foot-print and
"                    improved compressed-database load speeds
"
"           Version 0.41: October 6, 2008
"                  1. Minor fix: Compressed cscope databases will load
"                  incorrectly if encoding is not 8-bit
"
"           Version 0.4: September 28, 2008
"                  1. Rewrite of "tree-display" code
"                  2. New syntax hightlighting
"                  3. Dynamic highlighting for call-trees
"                  4. Support for new window modes (vertical, horizontal)
"                  5. New display format option for compact or wide call-trees
"                  NOTE: defaults for tree-orientation set to vertical
"
"           Version 0.3:
"               September 21, 2008
"                 1. Support compressed cscope databases
"                 2. Display window related bugs fixed
"                 3. More intuitive display and folding capabilities
"
"           Version 0.2:
"               September 12, 2008
"               (Patches from Yegappan Lakshmanan, thanks!)
"                 1. Support for using the plugin in Vi-compatible mode.
"                 2. Filtering out unwanted lines before processing the db.
"                 3. Command-line completion for the commands.
"                 4. Using the cscope db from any directory.
"
"           Version 0.1:
"                August 31,2008
"                 1. Cross-referencing support for only functions and macros
"                    Functions inside macro definitions will be incorrectly
"                    attributed to the top level calling function
"
"   }}}
"   {{{ Thanks:
"
"    Ben Fritz                      (ver 1.53 -- Bug reports on database append/load)
"    Qaiser Durrani                 (ver 1.51 -- Reporting issues with SunOS)
"    Ben Fritz                      (ver 1.39 -- Suggestion/Testing for conceal feature)
"    Ben Fritz                      (ver 1.26 -- Bug report)
"    Frank Chang                    (ver 1.0x -- testing/UI enhancement ideas/bug fixes)
"    Arun Chaganty/Timo Tiefel      (Ver 0.60 -- bug report)
"    Michael Wookey                 (Ver 0.4 -- Testing/bug report/patches)
"    Yegappan Lakshmanan            (Ver 0.2 -- Patches)
"
"    The Vim Community, ofcourse :)
"=============================================================================
"    }}}

" {{{ Init
if !exists('loaded_cctree') && v:version >= 700
  " First time loading the cctree plugin
  let loaded_cctree = 1
else
  "finish
endif

" Line continuation used here
let s:cpo_save = &cpoptions
set cpoptions&vim

" Trick to get the current script ID
map <SID>xx <SID>xx
let s:sid = substitute(maparg('<SID>xx'), '<SNR>\(\d\+_\)xx$', '\1', '')
unmap <SID>xx
"}}}
" {{{ Global variables; Modify in .vimrc to modify default behavior
" {{{General
if !exists('CCTreeCscopeDb')
    let CCTreeCscopeDb = "cscope.out"
endif
" revisit
if !exists('CCTreeDb')
    let CCTreeDb = "cctree.out"
endif
if !exists('CCTreeRecursiveDepth')
    let CCTreeRecursiveDepth = 3
endif
if !exists('CCTreeMinVisibleDepth')
    let CCTreeMinVisibleDepth = 3
endif
if !exists('CCTreeEnhancedSymbolProcessing')
    let CCTreeEnhancedSymbolProcessing = 0
endif
" }}}
" {{{ Custom user-key mappings
if !exists('CCTreeKeyTraceForwardTree')
    let g:CCTreeKeyTraceForwardTree = '<C-\>>'
endif
if !exists('CCTreeKeyTraceReverseTree')
    let g:CCTreeKeyTraceReverseTree = '<C-\><'
endif
if !exists('CCTreeKeyHilightTree')
    let g:CCTreeKeyHilightTree = '<C-l>'        " Static highlighting
endif
if !exists('CCTreeKeySaveWindow ')
    let g:CCTreeKeySaveWindow = '<C-\>y'
endif
if !exists('CCTreeKeyToggleWindow ')
    let g:CCTreeKeyToggleWindow = '<C-\>w'
endif
if !exists('CCTreeKeyCompressTree ')
    let g:CCTreeKeyCompressTree = 'zs'     " Compress call-tree
endif
if !exists('CCTreeKeyDepthPlus')
    let g:CCTreeKeyDepthPlus = '<C-\>='
endif
if !exists('CCTreeKeyDepthMinus')
    let g:CCTreeKeyDepthMinus = '<C-\>-'
endif
" }}}
" {{{ CCTree UI settings
if !exists('CCTreeOrientation')
    let CCTreeOrientation = "topleft"
endif
if !exists('CCTreeWindowVertical')
    let CCTreeWindowVertical = 1
endif
if !exists('CCTreeWindowWidth')
    " -1 is auto select best width
    let CCTreeWindowWidth = -1
endif
if !exists('CCTreeWindowMinWidth')
    let CCTreeWindowMinWidth = 25
endif
if !exists('CCTreeWindowHeight')
    let CCTreeWindowHeight = -1
endif
if !exists('CCTreeDisplayMode')
    let CCTreeDisplayMode = 1
endif
if !exists('CCTreeHilightCallTree')
    let CCTreeHilightCallTree = 1
endif
" }}}
" {{{ Split prog
if !exists('CCTreeSplitProgCmd')
    let CCTreeSplitProgCmd = 'PROG_SPLIT SPLIT_OPT SPLIT_SIZE IN_FILE OUT_FILE_PREFIX'
endif

if !exists('CCTreeSplitProg')
    "PROG_SPLIT
    let CCTreeSplitProg = 'split'
endif

if !exists('CCTreeSplitProgOption')
    "SPLIT_OPT
    let CCTreeSplitProgOption = '-C'
endif

if !exists('CCTreeDbFileSplitLines')
    " if SPLIT_OPT is -l
    " If split program does not support -C, then this parameter must be set to
    " the number of lines in the split files
    let CCTreeDbFileSplitLines = -1
endif

if !exists('CCTreeSplitProgCmd')
    let CCTreeSplitProgCmd = 'PROG_SPLIT SPLIT_OPT SPLIT_SIZE IN_FILE OUT_FILE_PREFIX'
endif

if !exists('CCTreeDbFileMaxSize')
    " if SPLIT_OPT is -C
    let CCTreeDbFileMaxSize = 40000000 "40 Mbytes
endif

" }}}
" {{{ Join/Cat prog
if !exists('CCTreeJoinProgCmd')
    let CCTreeJoinProgCmd = 'PROG_JOIN JOIN_OPT IN_FILES > OUT_FILE'
endif

if !exists('CCTreeJoinProg')
    "PROG_JOIN
    let CCTreeJoinProg = 'cat'
endif

if !exists('CCTreeJoinProgOpts')
    let CCTreeJoinProgOpts = ""
endif
" }}}
" {{{ Misc (perl)
if !exists('CCTreeUsePerl')
    " Disabled by default
    let CCTreeUsePerl = 0
if 0        " Auto-detect perl interface (Experimental code)
    if has('perl)
perl << PERL_EOF
        VIM::DoCommand("let CCTreeUsePerl = 1");
PERL_EOF
    endif
endif
endif

if has('conceal')
    let s:CCTreeUseConceal = 1
else
    let s:CCTreeUseConceal = 0
endif

if !exists('CCTreeUseUTF8Symbols')
    let CCTreeUseUTF8Symbols = 0
endif
" }}}
" }}}
" {{{ Plugin related local variables
let s:pluginname = 'CCTree'
let s:windowtitle = 'CCTree-View'
let s:windowsavetitle = 'CCTree-View-Copy'

let s:DBClasses = { 'cscopeid': 'Cscope', 'cctreexref' : 'CCTree XRef'}
let s:DBStorage = { 'memory': 'Memory', 'disk' : 'Disk'}

" }}}
" {{{ Turn on/off debugs
let s:tag_debug=0

" Use the Decho plugin for debugging
function! DBGecho(...)
    if s:tag_debug
        Decho(a:000)
    endif
endfunction

function! DBGredir(...)
    if s:tag_debug
        Decho(a:000)
    endif
endfunction

function! Pause()
    call input("sasasD", "asdads")
endfunction
" }}}
" {{{ Progress bar (generic, numeric, rolling)
let s:GenericProgressBar= {
                \ 'depth': 0,
                \ 'depthChar': '',
                \ 'currentChar': 0,
                \ 'updateTime': 0,
                \ 'rangeChars': [],
                \ 'formatStr' : '',
                \ 'units' : ''
                \ }

function! s:GenericProgressBar.mCreate(rangechars, depthchar, fmtStr)
    let pbr = deepcopy(s:GenericProgressBar)
    unlet pbr.mCreate

    let pbr.rangeChars = a:rangechars
    let pbr.depthChar = a:depthchar
    let pbr.formatStr = a:fmtStr

    return pbr
endfunction

function! s:GenericProgressBar.mSetDepth(val) dict
    let self.depth = a:val
endfunction

function! s:GenericProgressBar.mUpdate() dict
    let staticchars = repeat(self.depthChar, self.depth)
    let displayStr = substitute(self.formatStr, "\@PROGRESS\@",
                       \ staticchars . self.rangeChars[self.currentChar], "")
    call s:StatusLine.mSetExtraInfo(displayStr)
endfunction

function! s:GenericProgressBar.mDone()
        call s:StatusLine.mSetExtraInfo("")
endfunction

let s:ProgressBarRoll = {
                        \ 'updateTime' : 0,
                        \ 'curTime' : 0
                        \}

function! s:ProgressBarRoll.mCreate(rollchars, depthChar) dict
    let gpbr = s:GenericProgressBar.mCreate(a:rollchars, a:depthChar, "\@PROGRESS\@")
    let pbr = extend(gpbr, deepcopy(s:ProgressBarRoll))
    unlet pbr.mCreate

    let pbr.curTime = localtime()

    return pbr
endfunction

function! s:ProgressBarRoll.mTick(count) dict
    if (localtime() - self.curTime) > self.updateTime
        let self.currentChar += 1
        if self.currentChar == len(self.rangeChars)
            let self.currentChar = 0
        endif
        let self.curTime = localtime()
        call self.mUpdate()
    endif
endfunction

let s:ProgressBarNumeric = {
                \ 'progress1current' : 0,
                \ 'progressmax' : 0,
                \ 'progress1percent' : 0,
                \ 'progresspercent' : 0,
                \}

function! s:ProgressBarNumeric.mCreate(maxcount, unit) dict
        let gpbr = s:GenericProgressBar.mCreate(range(0,200), '',
            \ "Processing \@PROGRESS\@\%, total ". a:maxcount . " " . a:unit)
        let progressbar = extend(gpbr, deepcopy(s:ProgressBarNumeric))
        unlet progressbar.mCreate

        let progressbar.progressmax = a:maxcount
        let progressbar.progress1percent = a:maxcount/100

        let progressbar.units = a:unit

        return progressbar
endfunction


function! s:ProgressBarNumeric.mTick(count) dict
        let self.progress1current += a:count
        if self.progress1percent <= self.progress1current
            let tmp =  (self.progress1current/self.progress1percent)
            let self.progresspercent += tmp
            let self.progress1current -= tmp * self.progress1percent
            let self.currentChar += 1
            call self.mUpdate()
        endif
endfunction

" }}}
" {{{ Status line
let s:StatusLine = {
                    \ 'symlastprogress' : 0,
                    \ 'symprogress' : 0,
                    \ 'cursym' : 0,
                    \ 'savedStatusLine' : '',
                    \ 'statusextra' : '',
                    \ 'local':0
                    \}

function! s:StatusLine.mInit() dict
    let self.savedStatusLine = &l:statusline
    setlocal statusline=%{CCTreeStatusLine()}
endfunction

function! s:StatusLine.mRestore() dict
    let self.currentstatus = ''
    let self.statusextra = ''

    let &l:statusline = s:StatusLine.savedStatusLine
    redrawstatus
endfunction

function! s:StatusLine.mSetInfo(msg) dict
    let s:StatusLine.currentstatus = a:msg
    redrawstatus
endfunction

function! s:StatusLine.mSetExtraInfo(msg) dict
    let s:StatusLine.statusextra = a:msg
    redrawstatus
endfunction

function! CCTreeStatusLine()
    return   s:pluginname. " ".
           \ s:StatusLine.currentstatus . " -- ".
           \ s:StatusLine.statusextra
endfunction
"}}}
" {{{ Shell command interface

let s:ShellCmds = {'shellOutput': ''}

function! s:ShellCmds.mSplit(inFile, outFile)
        let cmdEx = substitute(g:CCTreeSplitProgCmd, "PROG_SPLIT", g:CCTreeSplitProg,"")
        let cmdEx = substitute(cmdEx, "SPLIT_OPT", g:CCTreeSplitProgOption,"")
        if g:CCTreeDbFileSplitLines != -1
                let cmdEx = substitute(cmdEx, "SPLIT_SIZE", g:CCTreeDbFileSplitLines,"")
        else
                let cmdEx = substitute(cmdEx, "SPLIT_SIZE", g:CCTreeDbFileMaxSize,"")
        endif
        let cmdEx = substitute(cmdEx, "IN_FILE", a:inFile,"")
        let cmdEx = substitute(cmdEx, "OUT_FILE_PREFIX", a:outFile,"")

        return cmdEx
endfunction

function! s:ShellCmds.mJoin(inFileList, outFile)
        let cmdEx = substitute(g:CCTreeJoinProgCmd, "PROG_JOIN", g:CCTreeJoinProg,"")
        let cmdEx = substitute(cmdEx, "JOIN_OPT", g:CCTreeJoinProgOpts,"")
        let cmdEx = substitute(cmdEx, "IN_FILES", a:inFileList,"")
        let cmdEx = substitute(cmdEx, "OUT_FILE", a:outFile,"")

        return cmdEx
endfunction

function! s:ShellCmds.mExec(cmd)
    let s:shellOutput= system(a:cmd)
    if s:shellOutput != ''
         " Failed
         return s:CCTreeRC.Error
    endif
    return s:CCTreeRC.Success
endfunction

" }}}

" {{{ Virtual file interface
let s:vFile = {}

function! s:vFile.mCreate(fname, mode)
    if a:mode == 'r'
        return s:vFileR.mCreate(a:fname)
    elseif a:mode == 'w'
        return s:vFileW.mCreate(a:fname)
    endif
    return -1
endfunction

let s:vFileW = {
            \ 'splitfiles' : [],
            \ 'totSplits' : 0,
            \ 'lines' : [],
            \ 'fileSize' : 0
            \}

function! s:vFileW.mCreate(fname)  dict
        let vfile =  deepcopy(s:vFileW)
        unlet vfile.mCreate
        let vfile.link = a:fname

        return vfile
endfunction

function! s:vFileW.mCreateSplit()  dict
    " first split, create name
    if self.totSplits == 0
        let self.tlink =  tempname()
    endif
    let fname = self.tlink .'_'. self.totSplits
    call writefile(self.lines, fname)
    call add(self.splitfiles, fname)
    let self.lines = []
    let self.totSplits += 1
endfunction

function! s:vFileW.mTestForSplit()  dict
    if self.fileSize > g:CCTreeDbFileMaxSize
        call self.mCreateSplit()
    endif
endfunction

function! s:vFileW.mAddFileSize(size)  dict
    let self.fileSize += a:size
endfunction

function! s:vFileW.mWriteList(linelist)  dict
    call extend(self.lines, a:linelist)
    call self.mTestForSplit()
endfunction

function! s:vFileW.mWriteLine(line)  dict
    call add(self.lines, a:line)
    call self.mAddFileSize(len(a:line))
    call self.mTestForSplit()
endfunction

function! s:vFileW.mClose()  dict
    if self.totSplits == 0
        call writefile(self.lines, self.link)
    else
        " force remaining lines into a new split
        call self.mCreateSplit()
        " now join all of them
        let filelist = join(self.splitfiles, " ")
        let cmdEx = s:ShellCmds.mJoin(filelist, self.link)
        if s:ShellCmds.mExec(cmdEx) != s:CCTreeRC.Success
            let msg =  s:shellOutput ."Shell command: ".cmdEx. " failed!".
                        \ " Refer help to setup split/join utils."
            call s:CCTreeUtils.mWarningPrompt(msg)
        endif
    endif
    for afile in self.splitfiles
       call delete(afile)
    endfor
    return 0
endfunction

let s:vFileR = {
            \ 'splitfiles' : [],
            \ 'currentSplitIdx' : 0,
            \ 'totSplits' : 0,
            \ 'lines' : [],
            \ 'valid' : 0,
            \ 'mode' : ""
            \}


function! s:vFileR.mIsLargeFile()  dict
        if (getfsize(self.link) > g:CCTreeDbFileMaxSize)
                return 1
        endif
        return 0
endfunction

function! s:vFileR.mCreate(fname)  dict
        let vfile =  deepcopy(s:vFileR)
        unlet vfile.mCreate
        let vfile.link = a:fname
        let vfile.valid = filereadable(a:fname)
        let vfile.size = getfsize(a:fname)

        return vfile
endfunction

function! s:vFileR.mOpen()  dict
        if self.mode == 'w'
            " no need to do anything
            return 0
        endif

        if self.mIsLargeFile() == 0
                "little trick to keep interface uniform when we don't split
                call add(self.splitfiles, self.link)
                let self.totSplits = 1
        else
                let tmpDb = tempname()
                let cmdEx = s:ShellCmds.mSplit(self.link, tmpDb)

                if s:ShellCmds.mExec(cmdEx) != s:CCTreeRC.Success
                     let msg =  s:shellOutput ."Shell command: ".cmdEx. " failed!".
                             \ " Refer help to setup split/join utils."
                     call s:CCTreeUtils.mWarningPrompt(msg)
                     return -1
                else
                     let self.splitfiles = split(expand(tmpDb."*"), "\n")
                endif
                if empty(self.splitfiles)
                     return -1
                endif
        endif
        let self.totSplits = len(self.splitfiles)
        return 0
endfunction

function! s:vFileR.mRead()  dict
        if (self.currentSplitIdx >= len(self.splitfiles))
                " out of bounds
                return -1
        endif
        let self.lines = readfile(self.splitfiles[self.currentSplitIdx])
        let self.currentSplitIdx += 1
        return 0
endfunction

function! s:vFileR.mRewind()  dict
        let self.currentSplitIdx = 0
        let self.lines = []
endfunction


function! s:vFileR.mClose()  dict
        if self.totSplits == 1
            return
        endif
        for afile in self.splitfiles
           call delete(afile)
        endfor
endfunction
"}}}
" {{{Stop watch
let s:StopWatch = {
                        \ 'text' : "(no reltime feature)",
                          \}

function! s:StopWatch.mCreate()        dict
    let stopWatch = deepcopy(s:StopWatch)
    unlet stopWatch.mCreate

    call stopWatch.mReset()
    return stopWatch
endfunction

function! s:StopWatch.mReset()        dict
    if has('reltime')
        let self.startRTime = reltime()
    else
        let self.startRTime = localtime()
    endif
endfunction

function! s:StopWatch.mSnapElapsed()  dict
    if has('reltime')
        let self.text = reltimestr(reltime(self.startRTime))
    else
        let self.text = localtime() - self.startRTime
    endif
endfunction

function! s:StopWatch.mGetText()   dict
        return self.text
endfunction
"}}}
" {{{ Digraph character compression/decompression routines

let s:CharMaps = {
                    \'savedEncoding' : '',
                    \'mapkind' : ''
                    \}

" The encoding needs to be changed to 8-bit, otherwise we can't swap special
" 8-bit characters; restore after done
function! s:CharMaps.mInitTranslator() dict
        if self.mapkind ==  'Alpha'
            let self.savedEncoding = &encoding
            let &encoding="latin1"
        endif
endfunction

function! s:CharMaps.mDoneTranslator() dict
        if self.mapkind ==  'Alpha'
            let &encoding=self.savedEncoding
        endif
endfunction

function! s:CharMaps.CrossProduct(seq1, seq2) dict
    let cpSeq = []
    for dc1 in range(strlen(a:seq1))
        for dc2 in range(strlen(a:seq2))
           call add(cpSeq, a:seq1[dc1].a:seq2[dc2])
        endfor
    endfor
    return cpSeq
endfunction

let s:TranslateMap = {}

function! s:TranslateMap.mCreate (srcsym, destsym, mapkind, regex) dict
    let dicttable = extend(deepcopy(s:CharMaps), deepcopy(s:TranslateMap))
    unlet dicttable.CrossProduct

    let dicttable.mappings = {}

    " map lower
    let maxsym = min([len(a:srcsym),len (a:destsym)])

    let index = 0
    while (index < maxsym)
        let dicttable.mappings[a:srcsym[index]] =  a:destsym[index]
        let index += 1
    endwhile
    " Need mapping lens, we assume it's constant across the board
    let dicttable.mapsrclen = len(a:srcsym[0])
    let dicttable.regex = a:regex


    if a:mapkind == 'Alpha'
        let dicttable.mTranslate = dicttable.mTranslateAlpha
    elseif a:mapkind == 'Numeric'
        let dicttable.mTranslate = dicttable.mTranslateNumeric
    endif

    let dicttable.mapkind = a:mapkind

    unlet dicttable.mTranslateNumeric
    unlet dicttable.mTranslateAlpha

    return dicttable
endfunction


function! s:TranslateMap.mTranslateNumeric(value) dict
    let index = 0
    let retval = ""

    " remember to deal with multi-byte characters
    while index < len(a:value)
        let char1 = char2nr(a:value[index])
        if has_key(self.mappings, char1)
                let newmap = self.mappings[char1]
        else
                " take only the first character
                let newmap = a:value[index]
        endif
        let retval .= newmap
        let index += 1
    endwhile
    return retval
endfunction

function! s:TranslateMap.mTranslateAlpha(value) dict
    let retval = substitute(a:value, self.regex, '\=self.mappings[submatch(1)]', "g")
    return retval
endfunction

function! s:CCTreeGetXRefDbMaps(maptype, mapkind)
        let dichar1 = "|0123456789"
        let dichar2 = ",0123456789"

        return s:CCTreeCreateGenericMaps(a:maptype, a:mapkind, dichar1, dichar2)
endfunction

function! s:CCTreeGetCscopeMaps(maptype, mapkind)
        let dichar1 = " teisaprnl(of)=c"
        let dichar2 = " tnerpla"

        return s:CCTreeCreateGenericMaps(a:maptype, a:mapkind, dichar1, dichar2)
endfunction


function! s:CCTreeCreateGenericMaps(maptype, mapkind, dichar1, dichar2)
        let s:CharMaps.mapkind = a:mapkind
        call s:CharMaps.mInitTranslator()
        if a:mapkind == 'Numeric'
            let ab = map(range(128,255), 'v:val')
        elseif a:mapkind == 'Alpha'
            let ab = map(range(128,255), 'nr2char(v:val)')
        else
            return {}
        endif
        let ac =  s:CharMaps.CrossProduct(a:dichar1, a:dichar2)
        if a:maptype == 'Compress'
                let maps = s:TranslateMap.mCreate(ac, ab, a:mapkind,
                                \'\(['.a:dichar1.']['.a:dichar2.']\)\C')
        elseif a:maptype == 'Uncompress'
                let maps = s:TranslateMap.mCreate(ab, ac, a:mapkind,
                                \'\([\d128-\d255]\)')
        endif
        call s:CharMaps.mDoneTranslator()
        return maps
endfunction
" }}}
" {{{ Unique list filter object

let s:UniqList = {}

function! s:UniqList.mFilterEntries(lstval) dict
        let valdict = {}
        let reslist = ''
        for aval in a:lstval
            let rval = split(aval, "|")
            let bval = rval[0]
            if !has_key(valdict, bval)
                let valdict[bval] = ''
                let reslist .= (bval . ",")
            endif
        endfor
        " strip out the last comma
        let reslist = reslist[:-2]
        return reslist
endfunction

let s:CCTreeUniqListFilter = deepcopy(s:UniqList)
function! s:CCTreeMakeCommaListUnique(clist)
        let entries = split(a:clist, ",")
        if len(entries) > 0
            return s:CCTreeUniqListFilter.mFilterEntries(entries)
        endif
        return ""
endfunction
" }}}
" {{{ Buffer/Window
func! s:FindOpenBuffer(filename)
    let bnrHigh = bufnr("$")
    "tabpagebuflist(tabpagenr())

    for bufnrs in range(1, bnrHigh)
        if (bufexists(bufnrs) == 1 && bufname(bufnrs) == a:filename && bufloaded(bufnrs) != 0 )
            return bufnrs
        endif
    endfor
    " Could not find the buffer
    return 0
endfunction

func! s:FindOpenWindow(filename)
    let bufnr = s:FindOpenBuffer(a:filename)
    if (bufnr > 0)
       let newWinnr = bufwinnr(bufnr)
       if newWinnr != -1
               exec newWinnr.'wincmd w'
               return 1
       endif
    endif
    " Could not find the buffer
    return 0
endfunction
" }}}
" {{{ Utils library

let s:Utils = {}

" Use this function to determine the correct "g" flag
" for substitution
function! s:Utils.mGetSearchFlag(gvalue)
    let ret = (!a:gvalue)* (&gdefault) + (!&gdefault)*(a:gvalue)
    if ret == 1
        return 'g'
    endif
    return ''
endfunc

" Strlen works for multibyte characters
function! s:Utils.mStrlenEx(val)
    return strlen(substitute(a:val, ".", "x", "g"))
endfunc
" }}}
" {{{ Generic db loader interface
let s:GenericDbLdr = {
        \ 'fDBName' : '',
        \ 'class' : 'Generic',
        \ }

function! s:GenericDbLdr.mCreate(fname) dict
    let gdb = deepcopy(s:GenericDbLdr)
    unlet gdb.mCreate
    let gdb.fDBName = a:fname

    if !filereadable(a:fname)
        return s:CCTreeRC.Error
    endif

    return gdb
endfunction

function! s:GenericDbLdr.mParseDbHeader(gRdr)
    let header = readfile(self.fDBName, "", a:gRdr.headerLines)
    return a:gRdr.mParseDbHeader(header)
endfunction

let s:XRefMemDbLdr = {
                     \ 'class' : s:DBStorage.memory
                     \}

function! s:XRefMemDbLdr.mCreate(fname) dict
    let gdb = s:GenericDbLdr.mCreate(a:fname)
    if type(gdb) != type({})
        return gdb
    endif
    let mdb = extend(gdb, deepcopy(s:XRefMemDbLdr))
    unlet mdb.mCreate

    return mdb
endfunction

if has('perl') && g:CCTreeUsePerl == 1
" Perl function
function! s:XRefMemDbLdr.mLoadFileIntoXRefDb(xRefDb, gRdr)  dict
    let stage = 1
    for afltr in a:gRdr.opts
        let stageidxstr = 'Stage ('.stage.'/'.len(a:gRdr.opts).') '
        call s:StatusLine.mSetInfo(stageidxstr. ': (PERL) Loading database ')
        call a:gRdr.mProcessingStateInit()
        let pBar = s:ProgressBarNumeric.mCreate(getfsize(self.fDBName), "bytes")
        echomsg 'filtering '. afltr
perl << PERL_EOF
    #use strict;
    #use warnings FATAL => 'all';
    #use warnings NONFATAL => 'redefine';

    my $filebytes = 0;
    my $filterpat = VIM::Eval("afltr");

    open (CSCOPEDB, VIM::Eval("self.fDBName")) or die "File trouble!";
    #VIM::DoCommand("echomsg '".$filterpat."'");

    while (<CSCOPEDB>) {
        $filebytes += length($_);
        chomp($_);

        if ($_ !~ $filterpat) {
                next;
        }
        VIM::DoCommand("call pBar.mTick(".$filebytes.")");
        $filebytes = 0;
        VIM::DoCommand("call a:gRdr.mProcessSymbol(a:xRefDb, '".$_."')");
    }
    VIM::DoCommand("call pBar.mDone()");
    close(CSCOPEDB);
PERL_EOF
        call a:gRdr.mProcessingStateDone()
        let stage += 1
    endfor
endfunction
else
" Native Vim function
function! s:XRefMemDbLdr.mLoadFileIntoXRefDb(xRefDb, gRdr) dict
        let vDbFile = s:vFile.mCreate(self.fDBName, "r")
        if vDbFile.valid == 0
            return -1
        endif
        if vDbFile.mIsLargeFile() == 1
                call s:StatusLine.mSetExtraInfo('Database '
                        \.' >'.g:CCTreeDbFileMaxSize .' bytes. Splitting '.
                        \'into smaller chunks... (this may take some time)')
        endif
        try
                if vDbFile.mOpen() == 0
                        call self.mReadFileIntoXRefDb(vDbFile,
                                                \ a:xRefDb,
                                                \ a:gRdr)
                endif
        finally
                call vDbFile.mClose()
        endtry
endfunction
endif

function! s:XRefMemDbLdr.mReadFileIntoXRefDb(vDbFile, xrefdb, gRdr)
    let stage = 0
    for afltr in a:gRdr.opts
        call a:vDbFile.mRewind()
        let stage += 1
        call a:gRdr.mProcessingStateInit()
        while 1 == 1
            if a:vDbFile.mRead() == -1
                break
            endif
            let stageidxstr = 'Stage ('.stage.'/'.len(a:gRdr.opts).') '
            let fileidxstr = '('.a:vDbFile.currentSplitIdx.'/'.a:vDbFile.totSplits.') '
            call s:StatusLine.mSetInfo(stageidxstr. ': Reading database chunk '.fileidxstr)
            " Filter-out lines that doesn't have relevant information
            let plist = a:gRdr.mReadLinesFromFile(a:vDbFile, afltr)
            let pBar = s:ProgressBarNumeric.mCreate(len(plist), "items")
            call s:StatusLine.mSetInfo(stageidxstr.': Analyzing database chunk '.fileidxstr)
            call self.mProcessListIntoXrefDb(plist, a:gRdr, a:xrefdb, pBar)
            call pBar.mDone()
            " clean-up memory
            call garbagecollect()
        endwhile
        call a:gRdr.mProcessingStateDone()
    endfor
endfunction

function! s:XRefMemDbLdr.mProcessListIntoXrefDb(symbols, rdr, xrefdb, pbar)
    for a in a:symbols
        call a:pbar.mTick(1)
        call a:rdr.mProcessSymbol(a:xrefdb, a)
    endfor
endfunction

function! s:GenericDbLdr.mParseDbHeader(gRdr)
    let header = readfile(self.fDBName, "", a:gRdr.headerLines)
    return a:gRdr.mParseDbHeader(header)
endfunction

" }}}
" {{{ Generic Disk DB Ldr
let s:XRefDiskDbLdr = {
        \ 'class' : s:DBStorage.disk
        \ }

function! s:XRefDiskDbLdr.mCreate(fname) dict
    let gdb = s:GenericDbLdr.mCreate(a:fname)
    if type(gdb) != type({})
        return gdb
    endif
    let mdb = extend(gdb, deepcopy(s:XRefDiskDbLdr))
    unlet mdb.mCreate

    return mdb
endfunction

function! s:XRefDiskDbLdr.mLoadFileIntoXRefDb(xRefDb, gRdr) dict
    call a:xRefDb.mSetLink(self.fDBName)
endfunction

"}}}
" {{{ Xref disk DB
let s:XRefDiskDb = {
                        \ 'link':'',
                        \ 'savedTags': '',
                        \ 'class' : s:DBStorage.disk
                        \ }

function! s:XRefDiskDb.mCreate() dict
       let fdb = deepcopy(s:XRefDiskDb)
       unlet fdb.mCreate
       let fdb.maps = s:CCTreeGetXRefDbMaps('Uncompress', 'Numeric')

       return fdb
endfunction

function! s:XRefDiskDb.mSetLink(filedb) dict
       let self.link = a:filedb
        " revisit, do parse header here
endfunction

function! s:XRefDiskDb.mClear() dict
        " do nothing
endfunction

function! s:XRefDiskDb.mInitState() dict
        let self.savedTags = &tags
        let &tags = self.link
endfunction

function! s:XRefDiskDb.mRestoreState() dict
        let &tags = self.savedTags
endfunction

function! s:XRefDiskDb.mDecodeTagEntry(tagentry) dict
        let itms = split(a:tagentry.name, "#")
        let a:tagentry.n = itms[1]
        let a:tagentry.idx = itms[0]

        " Vim taglist() drops empty fields, so need to protect
        if has_key(a:tagentry, 'c')
            let a:tagentry.c = self.maps.mTranslate(a:tagentry.c)
        else
            let a:tagentry.c = ''
        endif
        if has_key(a:tagentry, 'p')
            let a:tagentry.p = self.maps.mTranslate(a:tagentry.p)
        else
            let a:tagentry.p = ''
        endif

        return a:tagentry
endfunction

function! s:XRefDiskDb.mGetSymbolIdFromName(symname) dict
        let symtagline = taglist('\#'.a:symname.'$')
        let asym = self.mDecodeTagEntry(symtagline[0])
        return asym.idx
endfunction

function! s:XRefDiskDb.mGetSymbolFromId(symid) dict
        let symtagline = taglist('^'.a:symid.'\#')
        if empty(symtagline)
            echomsg "Failed to locate ".a:symid
        else
            return self.mDecodeTagEntry(symtagline[0])
        endif
        return {}
endfunction

function! s:XRefDiskDb.mGetSymbolIds() dict
    " illegal
    let symtaglines = taglist('^.')
    return keys(self.symidhash)
endfunction

function! s:XRefDiskDb.mGetSymbolNames(lead) dict
    if empty(a:lead)
        let symtaglines = taglist('^.')
    else
        let symtaglines = taglist('#'.a:lead)
    endif
    let alist = []
    for atag in symtaglines
        let acctreesym = self.mDecodeTagEntry(atag)
        call add(alist, acctreesym.n)
    endfor
    return alist
endfunction
" }}}
" {{{ TagFile utils
let s:CCTreeTagDbRdr = {'class': 'CCTreeXrefDb',
                    \ 'headerLines' : 4,
                    \ 'compressed' : 0,
                    \ 'opts': ['v:val !~ "^[\!]"'],
                    \ 'perl_opts': "^[^\!]",
                    \ 'mapPreKeys': {'c':'','p':''},
                    \ 'mapPostKeys': {'c':'','p':''}
                    \ }

function! s:CCTreeTagDbRdr.mCreate(fname) dict
    let cctxdbrdr = deepcopy(s:CCTreeTagDbRdr)
    unlet cctxdbrdr.mCreate

    return cctxdbrdr
endfunction

function! s:CCTreeTagDbRdr.mRequirePreProcessing() dict
    return s:CCTreeRC.False
endfunction

function! s:CCTreeTagDbRdr.mRequirePostProcessing() dict
    return s:CCTreeRC.True
endfunction

function! s:CCTreeTagDbRdr.mRequireCleanup() dict
    " Clean-up all symbols [never]
    return s:CCTreeRC.False
endfunction

function! s:CCTreeTagDbRdr.mGetPreProcessingMaps() dict
    return s:CCTreeGetXRefDbMaps('Compress', 'Alpha')
endfunction

function! s:CCTreeTagDbRdr.mGetPostProcessingMaps() dict
    return s:CCTreeGetXRefDbMaps('Uncompress', 'Alpha')
endfunction


function! s:CCTreeTagDbRdr.mParseDbHeader(hdr) dict
    " just check line 3 for sanity
    if a:hdr[2] =~ "CCTree"
        return s:CCTreeRC.Success
    endif
    return s:CCTreeRC.Error
endfunction

function! s:CCTreeTagDbRdr.mProcessingStateInit() dict
endfunction

function! s:CCTreeTagDbRdr.mProcessingStateDone() dict
endfunction

function! s:CCTreeTagDbRdr.mReadLinesFromFile(vdbFile, filtercmds) dict
    " Hard-coded assumptions here about format for performance
    if empty(get(a:vdbFile.lines, 0)) != 1 && a:vdbFile.lines[0][0] == "!"
    " filter out the first few lines starting with "!"
        call remove(a:vdbFile.lines, 0, self.headerLines-1)
    endif
    return a:vdbFile.lines
endfunction

function! s:CCTreeTagDbRdr.mProcessSymbol(xrefdb, aline) dict
    let cctreesym = self.mDecodeTagLine(a:aline)
    call a:xrefdb.mInsertSym(cctreesym.idx, cctreesym)
    " we really don't need idx any longer
    unlet cctreesym.idx
endfunction

function! s:CCTreeTagDbRdr.mDecodeTagLine(tagline) dict

        let items = split(a:tagline, "\t")
        let newsym = s:CCTreeSym.mCreate("", "")
        try
            let [newsym.idx, newsym.n] = split(items[0], '#')
        catch
            echomsg "problem decoding ". a:tagline
        endtry

        "let newsym.idx = strpart(items[0], 0, idxBr)
        "let newsym.n =  items[0][ idxBr+1 : -2] "strpart(items[0], idxBr+1, strlen(items[0])-1)
        if empty(get(items, 3)) != 1
            let newsym.c = items[3][2:]
        endif
        if empty(get(items, 4)) != 1
            let newsym.p = items[4][2:]
        endif
        return newsym
endfunction

" }}}
" {{{ Generic Db Serializer
let s:GenericDbSerializer = {}

function! s:GenericDbSerializer.mCreate(xrefdb) dict
    let gDbSerializer = deepcopy(s:GenericDbSerializer)
    let gDbSerializer.xrefdb = a:xrefdb
    return gDbSerializer
endfunction

function! s:GenericDbSerializer.mWriteXRefDbToFile(fname,
                                            \ gWriter) dict
    call s:StatusLine.mInit()
    try
        call s:StatusLine.mSetInfo('Writing XRefDb')
        let vDbFile = s:vFile.mCreate(a:fname, "w")
        call vDbFile.mWriteList(a:gWriter.mBuildHeader())
        call self.mWriteSymsToFile(vDbFile, a:gWriter)
    finally
        call vDbFile.mClose()
        call s:StatusLine.mRestore()
    endtry
endfunction

function! s:GenericDbSerializer.mWriteSymsToFile(dstVFile,
                                            \ gWriter) dict
    let pBar = s:ProgressBarNumeric.mCreate(self.xrefdb.mGetSymbolCount(),
                                                    \ "items")
    call a:gWriter.mInitWriting()
    " write syms
    for asymid in sort(self.xrefdb.mGetSymbolIds())
        let  acctreesym = self.xrefdb.mGetSymbolFromId(asymid)
        call a:dstVFile.mWriteLine(a:gWriter.mBuildTagLine(acctreesym,
                        \ asymid))
        call pBar.mTick(1)
    endfor
    call pBar.mDone()
    call a:gWriter.mDoneWriting()
endfunction
" }}}
" {{{ CCTreeTagDb Writer
let s:CCTreeTagDbWriter = {}

function! s:CCTreeTagDbWriter.mCreate(tmaps) dict
    let dbwriter = deepcopy(s:CCTreeTagDbWriter)
    unlet dbwriter.mCreate


    let dbwriter.tmaps = a:tmaps
    return dbwriter
endfunction

function! s:CCTreeTagDbWriter.mInitWriting() dict
    call self.tmaps.mInitTranslator()
endfunction

function! s:CCTreeTagDbWriter.mDoneWriting() dict
    call self.tmaps.mDoneTranslator()
endfunction

function! s:CCTreeTagDbWriter.mBuildHeader() dict
    let hdr = []
    call add(hdr, "!_TAG_FILE_FORMAT\t2\t/extended format; --format=1 will not append ;\" to lines/")
    call add(hdr, "!_TAG_FILE_SORTED\t1\t/0=unsorted, 1=sorted, 2=foldcase/")
    call add(hdr, "!_TAG_PROGRAM_NAME\t\tCCTree (Vim plugin)//")
    call add(hdr, "!_TAG_PROGRAM_URL\thttp://vim.sourceforge.net/scripts/script.php?script_id=2368\t/site/")
    return hdr
endfunction


function! s:CCTreeTagDbWriter.mBuildTagLine(sym, symid) dict
        let basetag = a:symid .'#'. a:sym.n."\t"."\t"."/^\$/".";\""
        let cm =  self.tmaps.mTranslate(a:sym.c)
        let pm =  self.tmaps.mTranslate(a:sym.p)

        let basetag .= "\tc:". self.tmaps.mTranslate(a:sym.c)
        let basetag .= "\tp:". self.tmaps.mTranslate(a:sym.p)

        return basetag
endfunction
" }}}
" {{{ CCTree constants
let s:CCTreeRC = {
                    \ 'Error' : -1,
                    \ 'True' : 1,
                    \ 'False' : 0,
                    \ 'Success' : 2
                    \ }
"}}}
" {{{ CCTree DB Obj
" Symbol definition

let s:CCTreeSym = {
                    \'k': "",
                    \'n': "",
                    \'c': "",
                    \'p': ""
                    \}

function! s:CCTreeSym.mCreate(name, kind)
    let sym = deepcopy(s:CCTreeSym)
    unlet sym.mCreate
    let sym.n = a:name
    let sym.k = a:kind
    return sym
endfunction


" }}}
" {{{ GenericXref, XrefDb
let s:GenericXRef = {}

function! s:GenericXRef.mCreate(filedb) dict
       let gxref = deepcopy(s:GenericXRef)
       return gxref
endfunction

function! s:GenericXRef.mInitState() dict
endfunction

function! s:GenericXRef.mRestoreState() dict
endfunction
" {{{ XRef Database object
let s:xRefMemDb = {
        \ 'symuniqid': 0,
        \ 'symidhash' : {},
        \ 'symnamehash' : {},
        \ 'class' : s:DBStorage.memory
        \}


function s:xRefMemDb.mCreate()   dict
        let dbObj = deepcopy(s:xRefMemDb)
        unlet dbObj.mCreate

        return dbObj
endfunction

function s:xRefMemDb.mInitState()   dict
endfunction

function s:xRefMemDb.mRestoreState()   dict
endfunction

function s:xRefMemDb.mClear()   dict
    let self.symidhash = {}
    let self.symnamehash = {}
    let self.symuniqid = 0
endfunction

function! s:xRefMemDb.mInsertSym(idx, cctreesym)  dict
    let self.symuniqid = max([self.symuniqid, a:idx])
    let self.symidhash[a:idx] = a:cctreesym
    let self.symnamehash[a:cctreesym.n] = a:idx
endfunction

function! s:xRefMemDb.mRemoveSymById(symidx)  dict
    call self.mRemoveSymByName(acctreesym.n)
    call remove(self.symidhash, a:symidx)
endfunction

function! s:xRefMemDb.mRemoveSymByName(symname)  dict
    call remove(self.symnamehash, a:symname)
endfunction

function! s:xRefMemDb.mAddSym(name, kind)    dict
    if !has_key(self.symnamehash, a:name)
        let self.symnamehash[a:name] = self.symuniqid
        let self.symidhash[self.symuniqid] =
                            \s:CCTreeSym.mCreate(a:name, a:kind)
        let self.symuniqid += 1
    endif
    let asymid = self.symnamehash[a:name]
    if a:kind != ""
        let asym = self.symidhash[asymid]
        let asym.k = a:kind
    endif
    return asymid
endfunction

function! s:xRefMemDb.mMarkXRefSyms(funcentryidx, newfuncidx) dict
    let self.symidhash[a:funcentryidx]['c'] .= (",". a:newfuncidx)
    let self.symidhash[a:newfuncidx]['p'] .= (",". a:funcentryidx)
endfunction

function! s:xRefMemDb.mGetSymbolFromName(symname) dict
    return self.symidhash[self.symnamehash[a:symname]]
endfunction

function! s:xRefMemDb.mGetSymbolIdFromName(symname) dict
    if has_key(self.symnamehash, a:symname)
        return self.symnamehash[a:symname]
    else
        return s:CCTreeRC.Error
    endif
endfunction

function! s:xRefMemDb.mGetSymbolFromId(symid) dict
    return self.symidhash[a:symid]
endfunction

function! s:xRefMemDb.mGetSymbolIds() dict
    return keys(self.symidhash)
endfunction

function! s:xRefMemDb.mGetSymbolNames(lead) dict
    let syms = keys(self.symnamehash)
    if empty(a:lead) != 1
        return filter(syms, 'v:val =~? a:lead')
    endif
    return syms
endfunction

function! s:xRefMemDb.mGetSymbolCount() dict
    return len(self.symnamehash)
endfunction

function! s:xRefMemDb.mTranslateSymbols(map, tkeys) dict
    call a:map.mInitTranslator()
    let pBar = s:ProgressBarNumeric.mCreate(len(self.symnamehash), "items")

    for asym in keys(self.symnamehash)
        let idx = self.symnamehash[asym]
        let val = self.symidhash[idx]
        if has_key(a:tkeys, 'n')
            let uncmpname = a:map.mTranslate(asym)
            if (asym != uncmpname)
                "Set up new entry
                let self.symnamehash[uncmpname] = idx
                " free the old entry
                call remove(self.symnamehash, asym)
                " Set uncompressed name
                let val.n = uncmpname
            endif
        endif
        if has_key(a:tkeys, 'p')
            let val.p = a:map.mTranslate(val.p)
        endif
        if has_key(a:tkeys, 'c')
            let val.c = a:map.mTranslate(val.c)
        endif
        call pBar.mTick(1)
    endfor
    call pBar.mDone()
    call a:map.mDoneTranslator()
endfunction

function! s:xRefMemDb.mCleanSymbols () dict
    let pBar = s:ProgressBarNumeric.mCreate(len(self.symnamehash), "items")
    for asym in keys(self.symnamehash)
        let idx = self.symnamehash[asym]
        let val = self.symidhash[idx]
        if empty(val.p) && empty(val.c)
            call remove(self.symnamehash, asym)
            call remove(self.symidhash, idx)
        else
            let val.p = s:CCTreeMakeCommaListUnique(val.p)
            let val.c = s:CCTreeMakeCommaListUnique(val.c)
        endif
        call pBar.mTick(1)
    endfor
    call pBar.mDone()
endfunction
"}}}
"}}} End of Xref
" {{{ Tracer
le