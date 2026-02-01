package session

import (
	"time"

	"loon/util"
	"loon/util/sl"
	"loon/util/str"
)

func (me *SrcPack) treesRefresh() (encounteredDiagsRelevantChanges bool) {
	if me.treesRefreshCanSkip() {
		return
	}
	defer func(timeStarted time.Time) {
		OnLogMsg(true, "treesRefresh: %s for %s", str.DurationMs(time.Since(timeStarted).Nanoseconds()), me.DirPath)
	}(time.Now())
	return
}

func (me *SrcPack) treesRefreshCanSkip() bool {
	cur_paths := me.srcFilePaths()
	can_skip := (len(cur_paths) == len(me.Trees.last.files))
	if can_skip {
		cur_paths := cur_paths
		for _, path := range cur_paths {
			if _, ok := me.Trees.last.files[path]; !ok {
				can_skip = false
				break
			}
		}
		for path := range me.Trees.last.files {
			if can_skip && !sl.Has(cur_paths, path) {
				can_skip = false
				break
			}
		}
		for _, src_file := range me.Files {
			if can_skip && (!src_file.IsFauxFile()) && (me.Trees.last.files[src_file.FilePath] != util.ContentHash(src_file.Src.Text)) {
				can_skip = false
				break
			}
		}
	}
	if !can_skip {
		for _, src_file := range me.Files {
			if (!src_file.IsFauxFile()) && src_file.HasLexOrParseErrs() {
				can_skip = true
				break
			}
		}
	}
	if !can_skip {
		me.Trees.last.files = map[string]string{}
		for _, src_file := range me.Files {
			if !src_file.IsFauxFile() {
				me.Trees.last.files[src_file.FilePath] = util.ContentHash(src_file.Src.Text)
			}
		}
	}
	return can_skip
}
