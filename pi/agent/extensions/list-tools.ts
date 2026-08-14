/**
 * list-tools Extension
 *
 * Canonical, verbatim dump of every tool configured in the current Pi session
 * — built-in, extension, and SDK — including the exact text the model sees
 * (descriptions, per-parameter descriptions, prompt guidelines).
 *
 * Output modes (passed as an optional argument to --list-tools):
 *   table    (default) terminal-aligned overview: Tool, Extension, Params, Description
 *   verbose  exhaustive Markdown, no tables; every string shown to the model
 *   json     exhaustive JSON (full parameter schemas + sourceInfo)
 *
 * There is no native Pi flag for this; pi.getAllTools() is the live registry.
 * Under --no-extensions the registry only contains builtin tools, so this
 * extension naturally shows only builtin tools (load it via -e in that case,
 * since --no-extensions disables settings/auto-discovered extensions).
 *
 * Usage:
 *   pi --list-tools                          # table (default), then exit
 *   pi --list-tools verbose                  # exhaustive markdown
 *   pi --list-tools json                     # exhaustive json
 *   pi --list-tools=verbose                  # (= form also works)
 *   pi --list-tools --tools-filter web,bash  # filter by name substrings
 *   pi --show-tool bash                      # verbose output for one tool
 *   /tools            /tools verbose   /tools json   /tools <substring>
 *   /show-tool <name>
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";

type ToolMeta = {
	name: string;
	description?: string;
	parameters?: unknown;
	promptGuidelines?: string[];
	sourceInfo?: {
		path?: string;
		source?: string;
		scope?: string;
		origin?: string;
		baseDir?: string;
	};
};

type Mode = "table" | "verbose" | "json";

/**
 * Human-friendly extension/package label from sourceInfo.source.
 *   "git:github.com/robobryce/pi-patty-bg-tasks" -> "pi-patty-bg-tasks (git)"
 *   "npm:pi-schedule-prompt@1.2.0"               -> "pi-schedule-prompt (npm)"
 *   "builtin" -> "(built-in)"   "sdk" -> "(sdk)"
 */
function extensionLabel(info: ToolMeta["sourceInfo"]): string {
	const source = info?.source;
	if (!source || source === "unknown") return "(unknown)";
	if (source === "builtin") return "(built-in)";
	if (source === "sdk") return "(sdk)";
	const colon = source.indexOf(":");
	const kind = colon === -1 ? "" : source.slice(0, colon);
	let rest = colon === -1 ? source : source.slice(colon + 1);
	rest = rest.replace(/@[^@/]+$/, "");
	const name = rest.split("/").filter(Boolean).pop() ?? rest;
	return kind ? `${name} (${kind})` : name;
}

type ParamInfo = {
	name: string;
	type: string;
	required: boolean;
	description?: string;
	enumValues?: unknown[];
};

function schemaTypeOf(schema: any): string {
	if (!schema || typeof schema !== "object") return "any";
	if (schema.type) return Array.isArray(schema.type) ? schema.type.join("|") : String(schema.type);
	if (schema.anyOf) return "anyOf";
	if (schema.oneOf) return "oneOf";
	if (schema.allOf) return "allOf";
	if (schema.enum) return "enum";
	return "any";
}

function collectParams(parameters: unknown): ParamInfo[] {
	const p = parameters as { properties?: Record<string, any>; required?: string[] } | undefined;
	if (!p || typeof p !== "object" || !p.properties) return [];
	const required = new Set(p.required ?? []);
	return Object.entries(p.properties).map(([name, schema]) => ({
		name,
		type: schemaTypeOf(schema),
		required: required.has(name),
		description: schema?.description,
		enumValues: schema?.enum,
	}));
}

function paramNameList(parameters: unknown): string {
	return collectParams(parameters)
		.map((pi) => (pi.required ? `${pi.name}*` : pi.name))
		.join(", ");
}

function sortTools(tools: ToolMeta[]): ToolMeta[] {
	return [...tools].sort((a, b) => a.name.localeCompare(b.name));
}

function sortToolsByExtension(tools: ToolMeta[]): ToolMeta[] {
	return [...tools].sort((a, b) => {
		const byExtension = extensionLabel(a.sourceInfo).localeCompare(extensionLabel(b.sourceInfo));
		return byExtension || a.name.localeCompare(b.name);
	});
}

function firstLine(s: string | undefined): string {
	const t = (s ?? "").trim();
	if (!t) return "";
	return t.split("\n")[0].trim();
}

function plainCell(s: string): string {
	return s.replace(/\r?\n/g, " ").replace(/\s+/g, " ").trim();
}

function terminalWidth(): number {
	const stdoutWidth = process.stdout.columns;
	const envWidth = Number.parseInt(process.env.COLUMNS ?? "", 10);
	const width = Number.isFinite(stdoutWidth) && stdoutWidth > 0 ? stdoutWidth : envWidth;
	if (Number.isFinite(width) && width >= 60) return width;
	return 120;
}

function wrapCell(value: string, width: number): string[] {
	const text = plainCell(value);
	if (!text) return [""];
	const lines: string[] = [];
	let line = "";
	for (let word of text.split(/\s+/)) {
		if (word.length > width) {
			if (line) {
				lines.push(line);
				line = "";
			}
			while (word.length > width) {
				lines.push(word.slice(0, width));
				word = word.slice(width);
			}
		}
		if (!word) continue;
		if (!line) {
			line = word;
		} else if (line.length + 1 + word.length <= width) {
			line += ` ${word}`;
		} else {
			lines.push(line);
			line = word;
		}
	}
	if (line) lines.push(line);
	return lines.length ? lines : [""];
}

function padRight(value: string, width: number): string {
	return value + " ".repeat(Math.max(0, width - value.length));
}

function renderTerminalRow(cells: string[], widths: number[]): string[] {
	const wrapped = cells.map((cell, i) => wrapCell(cell, widths[i] ?? cell.length));
	const height = Math.max(...wrapped.map((lines) => lines.length));
	const lines: string[] = [];
	for (let row = 0; row < height; row++) {
		lines.push(
			wrapped
				.map((linesForCell, i) => padRight(linesForCell[row] ?? "", widths[i] ?? 0))
				.join("  ")
				.trimEnd(),
		);
	}
	return lines;
}

function tableWidths(rows: Array<{ tool: string; extension: string; params: string; description: string }>): number[] {
	const maxLen = (values: string[], fallback: string) =>
		Math.max(fallback.length, ...values.map((value) => plainCell(value).length));
	const tool = Math.min(maxLen(rows.map((row) => row.tool), "Tool"), 32);
	const extension = Math.min(maxLen(rows.map((row) => row.extension), "Extension"), 28);
	let params = Math.min(maxLen(rows.map((row) => row.params), "Params"), 42);
	let desc = Math.max(maxLen(rows.map((row) => row.description), "Description"), 24);
	const totalGap = 6;
	const target = terminalWidth();
	desc = Math.min(desc, Math.max(24, target - totalGap - tool - extension - params));
	while (target - totalGap - tool - extension - params < 32 && params > 16) params--;
	desc = Math.max(24, target - totalGap - tool - extension - params);
	return [tool, extension, params, desc];
}

/** TABLE mode: terminal-aligned overview — Tool, Extension, Params, Description (first line). */
function renderTable(tools: ToolMeta[]): string {
	const rows = sortToolsByExtension(tools).map((t) => ({
		tool: t.name,
		extension: extensionLabel(t.sourceInfo),
		params: paramNameList(t.parameters) || "-",
		description: firstLine(t.description) || "-",
	}));
	const widths = tableWidths(rows);
	const lines: string[] = [];
	lines.push(`Pi tools (${rows.length})`);
	lines.push("");
	lines.push(...renderTerminalRow(["Tool", "Extension", "Params", "Description"], widths));
	lines.push(widths.map((width) => "-".repeat(width)).join("  "));
	for (const row of rows) {
		lines.push(...renderTerminalRow([row.tool, row.extension, row.params, row.description], widths));
	}
	lines.push("");
	lines.push("* marks required parameters. Use --list-tools verbose or --show-tool <name> for full detail.");
	return lines.join("\n") + "\n";
}

/** Verbose block for a single tool: exhaustive markdown, everything the model sees. */
function renderVerboseTool(t: ToolMeta): string[] {
	const lines: string[] = [];
	lines.push(`## \`${t.name}\``);
	lines.push("");
	lines.push(`- **Extension:** ${extensionLabel(t.sourceInfo)}`);
	if (t.sourceInfo?.source) lines.push(`- **Source id:** \`${t.sourceInfo.source}\``);
	if (t.sourceInfo?.scope) lines.push(`- **Scope:** ${t.sourceInfo.scope}`);
	if (t.sourceInfo?.origin) lines.push(`- **Origin:** ${t.sourceInfo.origin}`);
	if (t.sourceInfo?.path) lines.push(`- **Path:** \`${t.sourceInfo.path}\``);
	lines.push("");

	lines.push("**Description (verbatim):**");
	lines.push("");
	const desc = (t.description ?? "").trim();
	if (desc) {
		for (const dl of desc.split("\n")) lines.push(`> ${dl}`);
	} else {
		lines.push("> _(no description)_");
	}
	lines.push("");

	const params = collectParams(t.parameters);
	if (params.length) {
		lines.push("**Parameters:**");
		lines.push("");
		for (const p of params) {
			const req = p.required ? " _(required)_" : "";
			lines.push(`- \`${p.name}\` — \`${p.type}\`${req}`);
			if (p.description) {
				for (const dl of String(p.description).split("\n")) lines.push(`  - ${dl.trim()}`);
			}
			if (p.enumValues?.length) {
				lines.push(`  - allowed: ${p.enumValues.map((v) => `\`${JSON.stringify(v)}\``).join(", ")}`);
			}
		}
		lines.push("");
	} else {
		lines.push("**Parameters:** _(none)_");
		lines.push("");
	}

	if (t.promptGuidelines?.length) {
		lines.push("**Prompt guidelines (verbatim):**");
		lines.push("");
		for (const g of t.promptGuidelines) lines.push(`- ${g}`);
		lines.push("");
	}
	return lines;
}

/** VERBOSE mode: full exhaustive markdown for all tools, grouped by extension. */
function renderVerbose(tools: ToolMeta[]): string {
	const rows = sortTools(tools);
	const lines: string[] = [];
	lines.push(`# Pi tool registry — ${rows.length} tool(s)`);
	lines.push("");
	lines.push("Exhaustive dump of every string presented to the model.");
	lines.push("");

	// Group by extension label for readability.
	const byExt = new Map<string, ToolMeta[]>();
	for (const t of rows) {
		const key = extensionLabel(t.sourceInfo);
		if (!byExt.has(key)) byExt.set(key, []);
		byExt.get(key)!.push(t);
	}
	const order = (k: string) => (k === "(built-in)" ? 0 : k === "(sdk)" ? 1 : 2);
	const exts = [...byExt.keys()].sort((a, b) => order(a) - order(b) || a.localeCompare(b));

	for (const ext of exts) {
		const group = byExt.get(ext)!;
		lines.push(`# ${ext} — ${group.length} tool(s)`);
		lines.push("");
		for (const t of group) lines.push(...renderVerboseTool(t));
	}
	return lines.join("\n").replace(/\n+$/, "\n");
}

function filterTools(tools: ToolMeta[], needle: string | undefined): ToolMeta[] {
	if (!needle) return tools;
	const parts = needle
		.split(",")
		.map((s) => s.trim().toLowerCase())
		.filter(Boolean);
	if (!parts.length) return tools;
	return tools.filter((t) => parts.some((p) => t.name.toLowerCase().includes(p)));
}

function asMode(token: string | undefined): Mode | undefined {
	const m = String(token ?? "").trim().toLowerCase();
	if (m === "verbose" || m === "json" || m === "table") return m;
	return undefined;
}

/**
 * The mode is an OPTIONAL argument to --list-tools. Because Pi's registerFlag
 * only supports bare booleans or value-required strings (a bare string flag
 * errors with "requires a value"), we register --list-tools as a boolean and
 * read its optional mode argument directly from argv:
 *   --list-tools               -> table
 *   --list-tools verbose       -> verbose   (space form)
 *   --list-tools=json          -> json      (equals form)
 * Anything that isn't a known mode is left alone (treated by Pi as a prompt,
 * which never runs because we exit first).
 */
function modeFromArgv(): Mode {
	const argv = process.argv;
	for (let i = 0; i < argv.length; i++) {
		const a = argv[i];
		if (a === "--list-tools") {
			return asMode(argv[i + 1]) ?? "table";
		}
		if (a.startsWith("--list-tools=")) {
			return asMode(a.slice("--list-tools=".length)) ?? "table";
		}
	}
	return "table";
}

function render(tools: ToolMeta[], mode: Mode): string {
	if (mode === "json") return JSON.stringify(sortTools(tools), null, 2) + "\n";
	if (mode === "verbose") return renderVerbose(tools);
	return renderTable(tools);
}

/** Verbose output for exactly one tool by exact name (case-insensitive). */
function renderShowTool(tools: ToolMeta[], name: string): string {
	const target = tools.find((t) => t.name.toLowerCase() === name.toLowerCase());
	if (!target) {
		const suggestions = tools
			.filter((t) => t.name.toLowerCase().includes(name.toLowerCase()))
			.map((t) => t.name);
		const hint = suggestions.length ? ` Did you mean: ${suggestions.join(", ")}?` : "";
		return `Tool "${name}" not found.${hint}\n`;
	}
	return renderVerboseTool(target).join("\n").replace(/\n+$/, "\n");
}

function writeOut(s: string): void {
	// Write directly to fd 1 (real stdout). Pi intercepts process.stdout and
	// routes it to stderr, which breaks `pi --list-tools | grep|less`. Writing to
	// the file descriptor bypasses that so the dump is properly pipeable.
	//
	// fs.writeSync on a pipe can do a PARTIAL write when the payload exceeds the
	// pipe buffer (~64KB), so loop until every byte is flushed or we'd truncate
	// large output (e.g. json mode).
	const buf = Buffer.from(s.endsWith("\n") ? s : s + "\n", "utf8");
	let offset = 0;
	while (offset < buf.length) {
		try {
			offset += fs.writeSync(1, buf, offset, buf.length - offset);
		} catch (err: any) {
			// Retry on EAGAIN (non-blocking pipe not ready); rethrow anything else.
			if (err && err.code === "EAGAIN") continue;
			throw err;
		}
	}
}

export default function listToolsExtension(pi: ExtensionAPI) {
	pi.registerFlag("list-tools", {
		description: "Print all configured tools and exit. Optional mode arg: table (default), verbose, or json",
		type: "boolean",
		default: false,
	});
	pi.registerFlag("tools-filter", {
		description: "With --list-tools: only tools whose name matches (comma-separated substrings)",
		type: "string",
	});
	pi.registerFlag("show-tool", {
		description: "Print exhaustive (verbose) output for a single tool by name, then exit",
		type: "string",
	});

	// Flags are only resolved once the session starts.
	pi.on("session_start", async (_event, _ctx) => {
		const all = pi.getAllTools() as ToolMeta[];

		const showTool = pi.getFlag("show-tool") as string | undefined;
		if (showTool && showTool.trim()) {
			writeOut(renderShowTool(all, showTool.trim()));
			process.exit(0);
		}

		if (!pi.getFlag("list-tools")) return;

		const filtered = filterTools(all, pi.getFlag("tools-filter") as string | undefined);
		const mode = modeFromArgv();
		writeOut(render(filtered, mode));
		process.exit(0);
	});

	// Interactive equivalents usable inside a running session.
	pi.registerCommand("tools", {
		description: "List configured tools (args: 'table'|'verbose'|'json' and/or a name substring)",
		getArgumentCompletions: (prefix: string) => {
			const modes = ["table", "verbose", "json"];
			const f = modes.filter((m) => m.startsWith(prefix.toLowerCase()));
			return f.length ? f.map((m) => ({ value: m, label: m })) : null;
		},
		handler: async (args: string, ctx: any) => {
			const all = pi.getAllTools() as ToolMeta[];
			const tokens = (args ?? "").trim().split(/\s+/).filter(Boolean);
			let mode: Mode = "table";
			const rest: string[] = [];
			for (const tok of tokens) {
				if (tok === "table" || tok === "verbose" || tok === "json") mode = tok;
				else rest.push(tok);
			}
			const needle = rest.length ? rest.join(",") : undefined;
			const filtered = filterTools(all, needle);
			const out = render(filtered, mode);
			if (ctx.mode === "tui" && ctx.hasUI) {
				await ctx.ui.select(`Tools (${filtered.length})`, out.split("\n"));
			} else {
				writeOut(out);
			}
		},
	});

	pi.registerCommand("show-tool", {
		description: "Show exhaustive verbose output for one tool by name",
		getArgumentCompletions: (prefix: string) => {
			const all = pi.getAllTools() as ToolMeta[];
			const f = all.map((t) => t.name).filter((n) => n.startsWith(prefix));
			return f.length ? f.map((n) => ({ value: n, label: n })) : null;
		},
		handler: async (args: string, ctx: any) => {
			const all = pi.getAllTools() as ToolMeta[];
			const name = (args ?? "").trim();
			if (!name) {
				ctx.ui?.notify?.("Usage: /show-tool <name>", "info");
				return;
			}
			const out = renderShowTool(all, name);
			if (ctx.mode === "tui" && ctx.hasUI) {
				await ctx.ui.select(name, out.split("\n"));
			} else {
				writeOut(out);
			}
		},
	});
}
