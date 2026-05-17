import { handleSimplifyCommand, COMMAND_NAME } from "./simplify-command.js";
export default function (pi) {
    pi.registerCommand(COMMAND_NAME, {
        description: "Review recently changed files for clarity, consistency, and maintainability improvements",
        handler: (args, ctx) => handleSimplifyCommand(args, ctx, pi),
    });
}
//# sourceMappingURL=index.js.map