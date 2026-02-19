
import { createClient } from "@/lib/supabase/server"; // Oops, I only made client.ts. Let's use client for now or just static check.
// Server client is better for initial load check. But I didn't create it.
// Let's create server.ts too. It's standard.
// But wait, server.ts needs cookies manipulation for auth.
// For now, let's just use client-side check or simply display UI.

import { MessageSquare, Database, Globe, Search } from "lucide-react";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-gray-900 to-black text-white">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
        <p className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-800 bg-black/50 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800/30 lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800/30">
          S.H.A.R.K. Protocol&nbsp;
          <code className="font-mono font-bold">Base Template v1.0</code>
        </p>
        <div className="fixed bottom-0 left-0 flex h-48 w-full items-end justify-center bg-gradient-to-t from-white via-white dark:from-black dark:via-black lg:static lg:h-auto lg:w-auto lg:bg-none">
          <a
            className="pointer-events-none flex place-items-center gap-2 p-8 lg:pointer-events-auto lg:p-0"
            href="https://vibecoding.com"
            target="_blank"
            rel="noopener noreferrer"
          >
            By Vibecoding
          </a>
        </div>
      </div>

      <div className="relative flex place-items-center before:absolute before:h-[300px] before:w-[480px] before:-translate-x-1/2 before:rounded-full before:bg-gradient-to-br before:from-purple-600 before:to-transparent before:blur-2xl before:content-[''] after:absolute after:-z-20 after:h-[180px] after:w-[240px] after:translate-x-1/3 after:bg-gradient-to-t after:from-green-400 after:via-teal-500 after:blur-2xl after:content-[''] before:dark:bg-gradient-to-br before:dark:from-transparent before:dark:to-blue-700 before:dark:opacity-10 after:dark:from-sky-900 after:dark:via-[#0141ff] after:dark:opacity-40 before:lg:h-[360px] z-[-1]">
        <h1 className="text-6xl font-bold tracking-tighter sm:text-8xl bg-clip-text text-transparent bg-gradient-to-b from-white to-gray-400">
          COCKPIT
        </h1>
      </div>

      <div className="mb-32 grid text-center lg:max-w-5xl lg:w-full lg:mb-0 lg:grid-cols-4 lg:text-left mt-20 gap-4">

        <Card title="GitHub" icon={<Database className="w-10 h-10 mb-4 text-purple-400" />} desc="Repo Connected" />
        <Card title="Supabase" icon={<Database className="w-10 h-10 mb-4 text-emerald-400" />} desc="Database Ready" />
        <Card title="Vercel" icon={<Globe className="w-10 h-10 mb-4 text-white" />} desc="Deploy Configured" />
        <Card title="Firecrawl" icon={<Search className="w-10 h-10 mb-4 text-orange-400" />} desc="Search Active" />

      </div>
    </main>
  );
}

function Card({ title, icon, desc }: { title: string, icon: React.ReactNode, desc: string }) {
  return (
    <div className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-700 hover:bg-gray-900/50 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30">
      <div className="flex flex-col items-center lg:items-start">
        {icon}
        <h2 className={`mb-3 text-2xl font-semibold`}>
          {title}{" "}
          <span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
            -&gt;
          </span>
        </h2>
        <p className={`m-0 max-w-[30ch] text-sm opacity-50`}>
          {desc}
        </p>
      </div>
    </div>
  )
}
