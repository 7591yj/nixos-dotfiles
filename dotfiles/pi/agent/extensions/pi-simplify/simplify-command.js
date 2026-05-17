import { getChangedFiles } from "./git-diff.js";
import { buildSimplifyPrompt } from "./prompt-builder.js";
export const COMMAND_NAME = "simplify";
export function parseArgs(args) {
    const tokens = args.trim().split(/\s+/).filter(Boolean);
    const files = [];
    let ref = "HEAD";
    let staged = false;
    for (const token of tokens) {
        if (token === "--staged") {
            staged = true;
        }
        else if (token.startsWith("--ref=")) {
            ref = token.slice("--ref=".length);
        }
        else {
            files.push(token);
        }
    }
    return { files, ref, staged };
}
export async function handleSimplifyCommand(args, ctx, pi) {
    const options = parseArgs(args);
    const files = await getChangedFiles(pi, ctx.cwd, options);
    if (files.length === 0) {
        ctx.ui.notify("No changed files found. Specify file paths or make some changes first.", "info");
        return;
    }
    const prompt = buildSimplifyPrompt(files);
    pi.sendUserMessage(prompt, { deliverAs: "followUp" });
}
//# sourceMappingURL=simplify-command.js.map