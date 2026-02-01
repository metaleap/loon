package lsp

import (
	"errors"

	lsp "loon/lsp/sdk"
	"loon/session"
	"loon/util/sl"
)

func init() {
	Server.Lang.Commands = []string{"announceLoonVscExt", "packsFsRefresh", "getSrcPacks", "getSrcFileToks", "getSrcFileAst"}
	Server.On_workspace_executeCommand = executeCommand
}

type treeNodeClientInfo struct {
	SrcFilePath string               `json:",omitempty"`
	SrcFileSpan *session.SrcFileSpan `json:",omitempty"`
	SrcFileText string               `json:",omitempty"`
}

func executeCommand(params *lsp.ExecuteCommandParams) (ret any, err error) {
	switch params.Command {

	default:
		err = errors.New("unknown command or invalid `arguments`: '" + params.Command + "'")

	case "announceLoonVscExt":
		ClientIsLoonVscExt = true

	case "packsFsRefresh":
		session.Access(func(sess session.StateAccess, _ session.Intel) {
			sess.PacksFsRefresh()
		})

	case "getSrcPacks":
		session.Access(func(sess session.StateAccess, _ session.Intel) {
			ret = sess.AllCurrentSrcPacks()
		})

	case "getSrcFileToks":
		if len(params.Arguments) == 1 {
			src_file_path, ok := params.Arguments[0].(string)
			if ok && session.IsSrcFilePath(src_file_path) {
				session.Access(func(sess session.StateAccess, _ session.Intel) {
					if src_file := sess.SrcFile(src_file_path); src_file != nil {
						ret = src_file.Src.Toks
					}
				})
			}
		}

	case "getSrcFileAst":
		if len(params.Arguments) == 1 {
			src_file_path, ok := params.Arguments[0].(string)
			if ok && session.IsSrcFilePath(src_file_path) {
				session.Access(func(sess session.StateAccess, _ session.Intel) {
					if src_file := sess.SrcFile(src_file_path); src_file != nil {
						ret = sl.SortedPer(src_file.Src.Ast, (*session.AstNode).Cmp)
					}
				})
			}
		}

	}

	return
}
