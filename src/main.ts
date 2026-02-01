import * as vscode from 'vscode'



export function activate(ctx: vscode.ExtensionContext) {
	ctx.subscriptions.push(
	)
	vscode.window.showInformationMessage("Hola from Loon")
}

export function deactivate() { }
