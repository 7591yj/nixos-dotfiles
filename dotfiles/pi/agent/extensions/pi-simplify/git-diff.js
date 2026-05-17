const STATUS_MAP = {
    M: "modified",
    A: "added",
    R: "renamed",
    C: "copied",
};
function parseDiffOutput(stdout) {
    const files = [];
    for (const line of stdout.split("\n")) {
        if (!line.trim())
            continue;
        const parts = line.split("\t");
        const statusCode = parts[0]?.[0];
        if (!statusCode)
            continue;
        const status = STATUS_MAP[statusCode];
        if (!status)
            continue;
        // Renamed (R100\told\tnew) and copied (C100\told\tnew) have two paths; use the new one.
        const path = (status === "renamed" || status === "copied") ? parts[2] : parts[1];
        if (path) {
            files.push({ path, status });
        }
    }
    return files;
}
export async function getChangedFiles(pi, cwd, options) {
    if (options.files.length > 0) {
        return options.files.map((path) => ({ path, status: "modified" }));
    }
    const args = ["diff", "--name-status"];
    if (options.staged) {
        args.push("--cached");
    }
    else {
        args.push(options.ref);
    }
    const result = await pi.exec("git", args, { cwd });
    if (result.code === 0) {
        const files = parseDiffOutput(result.stdout);
        if (files.length > 0)
            return files;
    }
    // Fallback: diff against previous commit
    const fallback = await pi.exec("git", ["diff", "--name-status", "HEAD~1"], { cwd });
    if (fallback.code === 0) {
        return parseDiffOutput(fallback.stdout);
    }
    return [];
}
//# sourceMappingURL=git-diff.js.map