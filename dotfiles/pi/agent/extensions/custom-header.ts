import type { ExtensionAPI, Theme } from "@mariozechner/pi-coding-agent";
import { VERSION, keyHint, rawKeyHint } from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";

function buildHeader(theme: Theme): string {
  const ascii_art_2 = [
    "   ███████████████████████████╗  ",
    "   ╚══██████╔════════██████╔══╝  ",
    "      ██████║        ██████║     ",
    "      ██████║        ██████║     ",
    "      ██████║        ██████║     ",
    "      ██████║        ██████║     ",
    "      ██████║        ██████║     ",
    "      ██████║        ██████║     ",
    "   ████████████╗  ████████████╗  ",
    "   ╚═══════════╝  ╚═══════════╝  ",
  ]
    .map((line) => theme.bold(theme.fg("success", line)))
    .join("\n");

  const logo =
    "\n" +
    ascii_art_2 +
    "\n\n" +
    theme.bold(theme.fg("accent", "pi")) +
    theme.fg("dim", ` v${VERSION}`);

  return logo;
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;

    ctx.ui.setHeader((_tui, theme) => ({
      render(_width: number): string[] {
        return buildHeader(theme).split("\n");
      },
      invalidate() {},
    }));
  });

  // Command to restore the built-in header
  pi.registerCommand("builtin-header", {
    description: "Restore the built-in startup header",
    handler: async (_args, ctx) => {
      ctx.ui.setHeader(undefined);
      ctx.ui.notify("Built-in header restored", "info");
    },
  });
}
