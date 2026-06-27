import { spawn, spawnSync } from "node:child_process";
import path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "typebox";

type FallowParams = {
  command?: "audit" | "health" | "dead-code" | "dupes" | "fix" | "full";
  args?: string[];
  cwd?: string;
  json?: boolean;
};

const DEFAULT_TIMEOUT_MS = 120_000;
const MAX_OUTPUT_CHARS = 60_000;

function truncate(text: string) {
  if (text.length <= MAX_OUTPUT_CHARS) return text;
  return `${text.slice(0, MAX_OUTPUT_CHARS)}\n\n[truncated ${text.length - MAX_OUTPUT_CHARS} chars]`;
}

function fallowArgs(params: FallowParams) {
  const command = params.command ?? "audit";
  const args = command === "full" ? [] : [command];
  args.push(...(params.args ?? []));

  if (params.json ?? true) {
    const hasFormat = args.some((arg, index) => arg === "--format" || arg.startsWith("--format=") || args[index - 1] === "--format");
    if (!hasFormat) args.push("--format", "json");
  }

  return args;
}

function commandExists(command: string) {
  return spawnSync(command, ["--version"], { stdio: "ignore" }).status === 0;
}

function runner() {
  if (commandExists("pnpm")) {
    return { bin: "pnpm", args: ["dlx", "fallow"], display: "pnpm dlx fallow" };
  }
  return { bin: "npx", args: ["--yes", "fallow"], display: "npx --yes fallow" };
}

function runFallow(params: FallowParams, signal: AbortSignal) {
  const cwd = params.cwd ? path.resolve(params.cwd) : process.cwd();
  const args = fallowArgs(params);
  const selected = runner();

  return new Promise<{ exitCode: number | null; stdout: string; stderr: string; commandLine: string }>((resolve, reject) => {
    const child = spawn(selected.bin, [...selected.args, ...args], {
      cwd,
      stdio: ["ignore", "pipe", "pipe"],
      env: { ...process.env, NO_COLOR: "1" },
    });

    let stdout = "";
    let stderr = "";
    const timer = setTimeout(() => {
      child.kill("SIGTERM");
      setTimeout(() => child.kill("SIGKILL"), 2_000).unref();
    }, DEFAULT_TIMEOUT_MS);

    const onAbort = () => child.kill("SIGTERM");
    signal.addEventListener("abort", onAbort, { once: true });

    child.stdout.on("data", (chunk) => {
      stdout += chunk.toString();
    });
    child.stderr.on("data", (chunk) => {
      stderr += chunk.toString();
    });
    child.on("error", reject);
    child.on("close", (exitCode) => {
      clearTimeout(timer);
      signal.removeEventListener("abort", onAbort);
      resolve({
        exitCode,
        stdout: truncate(stdout),
        stderr: truncate(stderr),
        commandLine: `${selected.display} ${args.map((arg) => JSON.stringify(arg)).join(" ")}`,
      });
    });
  });
}

function summarizeJson(stdout: string) {
  try {
    const parsed = JSON.parse(stdout) as Record<string, unknown>;
    const bits: string[] = [];
    if (typeof parsed.verdict === "string") bits.push(`verdict=${parsed.verdict}`);
    if (typeof parsed.score === "number") bits.push(`score=${parsed.score}`);
    if (typeof parsed.issue_count === "number") bits.push(`issues=${parsed.issue_count}`);
    if (typeof parsed.issues === "object" && Array.isArray(parsed.issues)) bits.push(`issues=${parsed.issues.length}`);
    return bits.join(" ");
  } catch {
    return "";
  }
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "fallow",
    label: "Fallow",
    description:
      "Run fallow codebase intelligence for JavaScript/TypeScript projects. Useful for changed-code audit, dead code, duplication, complexity, health scores, and safe cleanup evidence. Uses `pnpm dlx fallow` when pnpm is available, otherwise falls back to `npx --yes fallow`.",
    promptSnippet:
      "Use fallow for JS/TS repo intelligence: audit changed code, find dead code, duplication, complexity hotspots, and read machine-actionable JSON findings.",
    parameters: Type.Object({
      command: Type.Optional(
        Type.Union([
          Type.Literal("audit"),
          Type.Literal("health"),
          Type.Literal("dead-code"),
          Type.Literal("dupes"),
          Type.Literal("fix"),
          Type.Literal("full"),
        ], { description: "Fallow subcommand. `full` runs `fallow` without a subcommand." }),
      ),
      args: Type.Optional(Type.Array(Type.String(), { description: "Additional CLI args, e.g. [\"--changed-since\", \"main\"] or [\"--dry-run\"]." })),
      cwd: Type.Optional(Type.String({ description: "Working directory. Defaults to the current pi process cwd." })),
      json: Type.Optional(Type.Boolean({ description: "Append `--format json` when no format is supplied. Defaults to true." })),
    }),
    async execute(_toolCallId, params, signal) {
      const result = await runFallow(params as FallowParams, signal);
      const summary = summarizeJson(result.stdout);
      const text = [
        `$ ${result.commandLine}`,
        `exit: ${result.exitCode}${summary ? ` (${summary})` : ""}`,
        result.stdout ? `\nstdout:\n${result.stdout}` : "",
        result.stderr ? `\nstderr:\n${result.stderr}` : "",
      ].filter(Boolean).join("\n");

      return {
        content: [{ type: "text" as const, text }],
        details: { exitCode: result.exitCode, command: result.commandLine, summary },
      };
    },
  });

  pi.registerCommand("fallow", {
    description: "Run `fallow audit --format json` and send the result into the conversation",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();
      const cliArgs = args.trim() ? args.trim().split(/\s+/) : [];
      const result = await runFallow({ command: "audit", args: cliArgs, json: true }, new AbortController().signal);
      pi.sendMessage({
        customType: "fallow",
        content: `$ ${result.commandLine}\nexit: ${result.exitCode}\n\n${result.stdout}${result.stderr ? `\n\nstderr:\n${result.stderr}` : ""}`,
        display: true,
      });
    },
  });
}
