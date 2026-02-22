export default function App() {
  return (
    <div className="min-h-screen bg-slate-950 text-slate-100">
      <div className="mx-auto max-w-5xl p-6">
        <header className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-semibold tracking-tight">Bridge</h1>
            <p className="mt-1 text-sm text-slate-400">
              Your homepage for apps, feeds, and quick status.
            </p>
          </div>
          <div className="text-xs text-slate-400">v0</div>
        </header>

        <main className="mt-8 grid grid-cols-1 gap-4 md:grid-cols-3">
          <Card title="Apps" desc="Launch your homelab services" />
          <Card title="Feeds" desc="RSS / YouTube / Twitch" />
          <Card title="Layout" desc="Drag & drop editor (soon)" />
        </main>
      </div>
    </div>
  )
}

function Card({ title, desc }: { title: string; desc: string }) {
  return (
    <section className="rounded-xl border border-slate-800 bg-slate-900/40 p-4">
      <h2 className="text-sm font-medium text-slate-200">{title}</h2>
      <p className="mt-2 text-sm text-slate-400">{desc}</p>
      <div className="mt-4 h-24 rounded-lg bg-slate-900" />
    </section>
  )
}
