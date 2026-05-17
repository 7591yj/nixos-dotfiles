const VALID_SEVERITIES = new Set(["CRITICAL", "HIGH", "MEDIUM", "INFO"]);
const SEVERITY_ORDER = {
    CRITICAL: 0,
    HIGH: 1,
    MEDIUM: 2,
    INFO: 3,
};
function stripCodeFences(text) {
    return text.replace(/^```(?:json)?\s*\n?/gm, "").replace(/\n?```\s*$/gm, "");
}
function isValidFinding(obj) {
    return (typeof obj["severity"] === "string" &&
        VALID_SEVERITIES.has(obj["severity"]) &&
        typeof obj["file"] === "string" &&
        typeof obj["category"] === "string" &&
        typeof obj["message"] === "string");
}
function toFinding(item) {
    return {
        severity: item["severity"],
        file: item["file"],
        category: item["category"],
        message: item["message"],
        ...(typeof item["line"] === "number" ? { line: item["line"] } : {}),
        ...(typeof item["suggestion"] === "string" ? { suggestion: item["suggestion"] } : {}),
    };
}
export function parseReviewFindings(text) {
    const cleaned = stripCodeFences(text.trim());
    try {
        const parsed = JSON.parse(cleaned);
        if (!parsed || typeof parsed !== "object") {
            return makeFallback(text);
        }
        const obj = parsed;
        if (!Array.isArray(obj["findings"])) {
            return makeFallback(text);
        }
        const findings = [];
        for (const item of obj["findings"]) {
            const raw = item;
            if (isValidFinding(raw)) {
                findings.push(toFinding(raw));
            }
        }
        return findings;
    }
    catch {
        return makeFallback(text);
    }
}
function makeFallback(text) {
    return [
        {
            severity: "INFO",
            file: "",
            category: "parse-error",
            message: `Could not parse structured review. Raw response: ${text.slice(0, 200)}`,
        },
    ];
}
export function formatFindings(findings) {
    if (findings.length === 0) {
        return "Code review complete: no issues found. Code looks clean.";
    }
    const sorted = [...findings].sort((a, b) => SEVERITY_ORDER[a.severity] - SEVERITY_ORDER[b.severity]);
    const lines = sorted.map((f) => {
        const location = f.line ? `${f.file}:${f.line}` : f.file;
        const suggestion = f.suggestion ? `\n  Suggestion: ${f.suggestion}` : "";
        return `- **${f.severity}** [${f.category}] ${location}: ${f.message}${suggestion}`;
    });
    const counts = findings.reduce((acc, f) => {
        acc[f.severity] = (acc[f.severity] ?? 0) + 1;
        return acc;
    }, {});
    const summary = Object.entries(counts)
        .sort(([a], [b]) => SEVERITY_ORDER[a] - SEVERITY_ORDER[b])
        .map(([sev, count]) => `${count} ${sev}`)
        .join(", ");
    return `## Code Review Findings (${summary})\n\n${lines.join("\n")}`;
}
//# sourceMappingURL=review-parser.js.map