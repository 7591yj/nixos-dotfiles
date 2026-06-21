---
name: linear-local-first-architecture
description: "Use when building a web app that must feel instant, when users complain about spinners or perceived slowness despite acceptable latency, or when designing a local-first sync architecture with optimistic updates."
---

# Linear Local-First Architecture

Source: https://performance.dev/how-is-linear-so-fast-a-technical-breakdown.md

## When to use this skill

- You're building a productivity tool where perceived speed is critical to user experience
- Users report the app "feels slow" despite reasonable network latency
- You need to eliminate loading spinners and skeleton states from user workflows
- You're architecting a local-first application with offline capabilities
- You want to implement optimistic updates that feel instant
- You're designing a keyboard-first interface for power users

## Core principles

1. **Eliminate network waits wherever possible.** Every request costs hundreds of milliseconds; read from local state instead.
2. **Treat the browser as each user's database.** Store the full workspace in IndexedDB and hydrate into an in-memory observable graph. UI reads from local state, not the server.
3. **Apply mutations locally first, sync asynchronously.** Update local observables immediately, then queue the transaction for background sync.
4. **Render first, authenticate second.** If local data exists, render immediately and verify the session in the background.
5. **Ship less code in more pieces.** Use aggressive code splitting, modern-only targets, and per-package vendor chunks.
6. **Animate only composited properties.** Prefer `transform` and `opacity`; avoid layout-triggering animation.

## Tactics

### Local-first data architecture

Store workspace data in IndexedDB and hydrate it into an in-memory observable store. UI queries the local store, not the server.

```typescript
// Network-bound app
async function updateIssue({ issue }) {
  showSpinner();
  const response = await fetch(`/api/issues/${issue.id}`, {
    method: "PATCH",
    body: JSON.stringify({ title: issue.title }),
  });
  const updated = await response.json();
  setIssue(updated);
  hideSpinner();
}

// Local-first app
issue.title = "Faster app launch";
issue.save();
```

The assignment updates memory synchronously; `save()` queues background sync.

### Optimistic updates with standard libraries

If not building a custom sync engine, use TanStack Query or SWR optimistic updates. The key is that responsiveness must not depend on network latency.

```typescript
mutate(
  `/api/issues/${issue.id}`,
  { ...issue, title: "Faster app launch" },
  false,
);
```

### Bundle for cache granularity

Target modern browsers, drop legacy polyfills, and split vendor code by package.

```typescript
export default defineConfig({
  build: {
    target: "esnext",
    cssMinify: "lightningcss",
    modulePreload: { polyfill: false },
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes("node_modules")) {
            const pkg = id.match(/node_modules\/([^/]+)/)?.[1];
            if (pkg) return `vendor-${pkg}`;
          }
        },
      },
    },
  },
});
```

### Preload critical chunks in parallel

Declare critical module chunks in `<head>` with matching `crossorigin` so the browser can reuse cached fetches.

```html
<script type="module" crossorigin src="/assets/app.js"></script>
<link rel="modulepreload" crossorigin href="/assets/vendor-mobx.js">
<link rel="modulepreload" crossorigin href="/assets/SyncWebSocket.js">
```

### Precache remaining assets

Use a service worker to precache route chunks, icons, fonts, and other hashed assets after first load. Subsequent navigations should skip the network.

### Inline critical CSS and boot logic

Inline enough CSS to paint a correctly themed loading shell. Restore last-known tokens such as dark mode, sidebar width, and shell colors from localStorage before paint.

### Optimize font loading

Preload variable fonts with `crossorigin="anonymous"` and use `font-display: swap`.

```html
<link rel="preload" href="/fonts/InterVariable.woff2" as="font" type="font/woff2" crossorigin="anonymous">
```

### Assume authentication, verify in background

If local workspace data exists, show it immediately. Let later sync or WebSocket requests fail with 401 and redirect only then.

### Use granular observables

Make individual model fields observable so deltas rerender only components that read the changed fields.

### Design keyboard-first interactions

Provide shortcuts for common actions and a global command palette (`⌘K`) that searches local data instantly.

### Animate composited properties only

```css
.row:hover {
  background-color: var(--color-bg-hover);
  transition: background-color 0.12s;
}
.icon-arrow {
  transform: translateX(0);
  transition: transform 0.15s;
}
```

Avoid `transition: all` and layout properties like `width`, `height`, `margin`, `padding`, `top`, or `left`.

### Keep animation durations short

Frequent interactions should generally be 100–250ms. Use asymmetric timing: instant appearance when summoned, short fade when dismissed.

## Anti-patterns

- Waiting for network requests before updating UI
- Animating layout-triggering properties
- Blocking initial render on authentication when local data exists
- Bundling all vendor code into one cache-busting chunk
- Long transitions for frequent interactions
- Fetching data on every navigation when it is already local
