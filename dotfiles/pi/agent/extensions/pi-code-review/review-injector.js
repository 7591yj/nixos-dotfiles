import { buildLanguageSection } from "./language-detector.js";
export function buildReviewInjectionBlock(edits) {
    if (edits.files.length === 0)
        return null;
    const fileList = edits.files.map((f) => f.path).join(", ");
    const languages = [
        ...new Set(edits.files.map((f) => f.language).filter((l) => l !== null)),
    ];
    const checklist = buildLanguageSection(languages);
    return `\n\n## Code Review

You edited: ${fileList}. Before proceeding, briefly verify:${checklist}

Fix any issues found, then continue.`;
}
export function handleBeforeAgentStart(event, edits) {
    const block = buildReviewInjectionBlock(edits);
    if (!block)
        return undefined;
    return { systemPrompt: event.systemPrompt + block };
}
//# sourceMappingURL=review-injector.js.map