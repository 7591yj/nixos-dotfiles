import { detectLanguage } from "./language-detector.js";
const FILE_PATH_RE = /(?:File|file|path)[:\s]+(\S+)/;
const TRACKED_TOOLS = new Set(["Write", "Edit"]);
function extractFilePath(result) {
    if (!result)
        return null;
    if (typeof result === "object") {
        const obj = result;
        if (typeof obj["file_path"] === "string")
            return obj["file_path"];
        if (typeof obj["path"] === "string")
            return obj["path"];
    }
    if (typeof result === "string") {
        const match = result.match(FILE_PATH_RE);
        return match?.[1] ?? null;
    }
    return null;
}
export function createEditTracker() {
    const current = new Map();
    let lastTurn = null;
    return {
        trackEdit(toolName, result) {
            if (!TRACKED_TOOLS.has(toolName))
                return;
            const path = extractFilePath(result);
            if (!path)
                return;
            const language = detectLanguage(path);
            if (!language)
                return;
            if (current.has(path))
                return;
            current.set(path, { path, language });
        },
        onTurnEnd(turnIndex) {
            if (current.size === 0) {
                lastTurn = null;
            }
            else {
                lastTurn = { files: [...current.values()], turnIndex };
            }
            current.clear();
        },
        getLastTurnEdits() {
            return lastTurn;
        },
        clearLastTurnEdits() {
            lastTurn = null;
        },
    };
}
//# sourceMappingURL=edit-tracker.js.map