// start.loudog.uno — the front door.
//   curl -fsSL start.loudog.uno | bash   → 302 to bootstrap.sh (curl follows with -L, fsSL includes -L)
//   a browser                            → landing page with the big buttons
const RAW = "https://raw.githubusercontent.com/loudoguno/start/main/bootstrap.sh";

const HTML = `<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1"><title>start · loudog.uno</title>
<style>
:root{--bg:#f9f9f7;--card:#fcfcfb;--ink:#0b0b0b;--ink2:#52514e;--muted:#898781;--line:rgba(11,11,11,.1);--acc:#2a78d6;--chip:#eeede9}
@media (prefers-color-scheme:dark){:root{--bg:#0d0d0d;--card:#1a1a19;--ink:#fff;--ink2:#c3c2b7;--line:rgba(255,255,255,.1);--acc:#3987e5;--chip:#262624}}
*{box-sizing:border-box;margin:0}body{font:16px/1.6 system-ui,-apple-system,sans-serif;background:var(--bg);color:var(--ink);display:grid;place-items:center;min-height:100vh;padding:24px}
main{max-width:640px;width:100%}h1{font-size:28px}p{color:var(--ink2);margin:8px 0 24px}
.card{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:20px;margin-bottom:14px}
.card h2{font-size:15px;margin-bottom:4px}.card p{font-size:14px;margin:4px 0 12px}
pre{background:var(--chip);border-radius:9px;padding:12px 14px;font:13px ui-monospace,Menlo,monospace;overflow-x:auto;cursor:pointer;position:relative}
pre:hover{outline:2px solid var(--acc)}pre::after{content:"click to copy";position:absolute;right:10px;top:10px;font-size:11px;color:var(--muted);font-family:system-ui}
a{color:var(--acc);text-decoration:none}a:hover{text-decoration:underline}
.foot{font-size:13px;color:var(--muted);margin-top:10px}
</style></head><body><main>
<h1>🖥️ → ✨ start</h1>
<p>One-touch, idempotent machine setup. Big powerful things, one curl away.</p>
<div class="card"><h2>Fresh Mac → fully configured</h2>
<p>Clones (or pulls) <a href="https://github.com/loudoguno/start">loudoguno/start</a> to <code>~/start</code> and presses the button. Safe to re-run any time.</p>
<pre onclick="navigator.clipboard.writeText(this.textContent.trim())">curl -fsSL start.loudog.uno | bash</pre></div>
<div class="card"><h2>Just read it first (wise)</h2>
<pre onclick="navigator.clipboard.writeText(this.textContent.trim())">curl -fsSL start.loudog.uno</pre>
<p class="foot">Piping strangers' URLs to bash is a bad habit — this one's yours.</p></div>
<p class="foot">More buttons will grow here. · <a href="https://github.com/loudoguno/start">repo</a> · <a href="https://github.com/loudoguno/start/blob/main/docs/DECISIONS.md">why it's built this way</a></p>
</main></body></html>`;

export default {
  async fetch(req) {
    const ua = req.headers.get("user-agent") || "";
    if (/curl|wget|fetch/i.test(ua)) return Response.redirect(RAW, 302);
    return new Response(HTML, { headers: { "content-type": "text/html; charset=utf-8" } });
  },
};
