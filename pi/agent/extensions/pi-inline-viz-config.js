import { realpathSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

// Configure wrapper before pi-inline-viz constructs its Mermaid adapter.
export default function configurePiInlineViz() {
	if (process.env.PI_INLINE_VIZ_MMDC_COMMAND) return;

	const extensionPath = realpathSync(fileURLToPath(import.meta.url));
	process.env.PI_INLINE_VIZ_MMDC_COMMAND = join(dirname(extensionPath), "pi-inline-viz-mmdc");
}
