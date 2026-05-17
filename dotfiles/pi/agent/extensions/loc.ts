import { execFile } from "node:child_process";
import { promises as fs } from "node:fs";
import path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const LANGUAGE_BY_EXTENSION: Record<string, string> = {
  ".c": "C",
  ".cc": "C++",
  ".clj": "Clojure",
  ".cljs": "Clojure",
  ".cpp": "C++",
  ".cs": "C#",
  ".css": "CSS",
  ".dart": "Dart",
  ".ex": "Elixir",
  ".exs": "Elixir",
  ".fs": "F#",
  ".fsx": "F#",
  ".go": "Go",
  ".h": "C/C++ Header",
  ".hpp": "C/C++ Header",
  ".hs": "Haskell",
  ".html": "HTML",
  ".java": "Java",
  ".js": "JavaScript",
  ".jsx": "JavaScript",
  ".kt": "Kotlin",
  ".kts": "Kotlin",
  ".lua": "Lua",
  ".m": "Objective-C",
  ".mm": "Objective-C++",
  ".nix": "Nix",
  ".php": "PHP",
  ".pl": "Perl",
  ".pm": "Perl",
  ".py": "Python",
  ".r": "R",
  ".rb": "Ruby",
  ".rs": "Rust",
  ".scala": "Scala",
  ".scss": "SCSS",
  ".sh": "Shell",
  ".sql": "SQL",
  ".svelte": "Svelte",
  ".swift": "Swift",
  ".ts": "TypeScript",
  ".tsx": "TypeScript",
  ".vue": "Vue",
  ".zig": "Zig",
};

const LANGUAGE_BY_BASENAME: Record<string, string> = {
  Dockerfile: "Dockerfile",
  Makefile: "Makefile",
};

const EXCLUDED_BASENAMES = new Set([
  "bun.lock",
  "Cargo.lock",
  "flake.lock",
  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
]);

const EXCLUDED_SUFFIXES = [".d.ts", ".generated.ts", ".generated.js", ".min.js"];

type LanguageTotal = {
  language: string;
  files: number;
  lines: number;
};

function languageFor(file: string) {
  const basename = path.basename(file);
  if (EXCLUDED_BASENAMES.has(basename)) return undefined;
  if (EXCLUDED_SUFFIXES.some((suffix) => file.endsWith(suffix))) return undefined;
  return LANGUAGE_BY_BASENAME[basename] ?? LANGUAGE_BY_EXTENSION[path.extname(file).toLowerCase()];
}

async function gitFiles(cwd: string) {
  const stdout = await new Promise<string>((resolve, reject) => {
    execFile(
      "git",
      ["-C", cwd, "ls-files", "-z"],
      { encoding: "utf8", maxBuffer: 50 * 1024 * 1024 },
      (error, out, stderr) => {
        if (error) {
          reject(new Error(String(stderr).trim() || error.message));
        } else {
          resolve(out);
        }
      },
    );
  });

  return stdout.split("\0").filter(Boolean);
}

function countLines(text: string) {
  if (text.length === 0) return 0;
  return text.endsWith("\n") ? text.split("\n").length - 1 : text.split("\n").length;
}

function formatNumber(value: number) {
  return new Intl.NumberFormat("en-US").format(value);
}

function toMarkdown(rows: LanguageTotal[]) {
  const totalFiles = rows.reduce((sum, row) => sum + row.files, 0);
  const totalLines = rows.reduce((sum, row) => sum + row.lines, 0);

  return [
    "| Language | Files | Lines | % |",
    "|---|---:|---:|---:|",
    ...rows.map((row) => {
      const percent = totalLines === 0 ? "0.0%" : `${((row.lines / totalLines) * 100).toFixed(1)}%`;
      return `| ${row.language} | ${formatNumber(row.files)} | ${formatNumber(row.lines)} | ${percent} |`;
    }),
    `| **Total** | **${formatNumber(totalFiles)}** | **${formatNumber(totalLines)}** | **100.0%** |`,
  ].join("\n");
}

async function buildLocTable(cwd: string) {
  const totals = new Map<string, LanguageTotal>();
  let skippedUnreadable = 0;

  for (const file of await gitFiles(cwd)) {
    const language = languageFor(file);
    if (!language) continue;

    try {
      const text = await fs.readFile(path.join(cwd, file), "utf8");
      const current = totals.get(language) ?? { language, files: 0, lines: 0 };
      current.files += 1;
      current.lines += countLines(text);
      totals.set(language, current);
    } catch {
      skippedUnreadable += 1;
    }
  }

  const rows = [...totals.values()].sort((a, b) => b.lines - a.lines || a.language.localeCompare(b.language));
  const table = rows.length > 0 ? toMarkdown(rows) : "No tracked source files found.";
  const note = skippedUnreadable > 0 ? `\n\nSkipped ${skippedUnreadable} unreadable source file(s).` : "";
  return `${table}${note}`;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("loc", {
    description: "Show tracked source-code lines by language, largest to smallest",
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();

      try {
        const table = await buildLocTable(process.cwd());
        pi.sendMessage({
          customType: "loc",
          content: table,
          display: true,
        });
      } catch (error) {
        ctx.ui.notify(`Failed to calculate LOC: ${error instanceof Error ? error.message : String(error)}`, "error");
      }
    },
  });
}
