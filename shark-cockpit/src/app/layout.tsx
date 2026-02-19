import type { Metadata } from "next";
import { Outfit, JetBrains_Mono } from "next/font/google";
import "./globals.css";
import { cn } from "@/lib/utils";

const outfit = Outfit({ subsets: ["latin"], variable: "--font-outfit" });
const jetbrains = JetBrains_Mono({ subsets: ["latin"], variable: "--font-mono" });

export const metadata: Metadata = {
  title: "S.H.A.R.K. Cockpit",
  description: "Advanced Agentic Coding Environment",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-br" className="dark">
      <body className={cn(
        "min-h-screen bg-background font-sans antialiased",
        outfit.variable,
        jetbrains.variable
      )}>
        {children}
      </body>
    </html>
  );
}
