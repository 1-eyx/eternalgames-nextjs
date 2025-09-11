#!/bin/bash

# ---
# EternalGames Feature Batch 1:
# 1. The Command Palette (Cmd/Ctrl + K)
# 2. Light/Dark Mode Theme Toggle
# 3. Advanced Search Results
# ---

echo "🚀 Starting Feature Integration Batch 1..."

# Step 1: Install new dependencies
echo "📦 Installing necessary libraries: zustand, cmdk, next-themes..."
npm install zustand cmdk next-themes

# Step 2: Create a global state management store using Zustand
echo "🧠 Setting up global state with Zustand..."
mkdir -p lib
cat <<'EOF' > lib/store.ts
import { create } from 'zustand';

// State for managing the Command Palette's open/closed status
type CommandPaletteState = {
  isOpen: boolean;
  open: () => void;
  close: () => void;
  toggle: () => void;
};

export const useCommandPaletteStore = create<CommandPaletteState>((set) => ({
  isOpen: false,
  open: () => set({ isOpen: true }),
  close: () => set({ isOpen: false }),
  toggle: () => set((state) => ({ isOpen: !state.isOpen })),
}));
EOF

# Step 3: Update CSS with styles for all new features
echo "🎨 Injecting new styles into app/globals.css for themes and components..."
cat <<'EOF' >> app/globals.css

/* --- THEME TOGGLE & DARK/LIGHT MODE VARIABLES --- */
:root {
  /* This is now our default LIGHT theme */
  --bg-primary: #F4F4F9; /* Off-white */
  --bg-secondary: #FFFFFF; /* Pure white */
  --text-primary: #0A0B0F; /* Near black */
  --text-secondary: #5B6171; /* Muted grey */
  --accent: #007BFF; /* A vibrant blue for light mode */
}

[data-theme="dark"] {
  --bg-primary: #0A0B0F;
  --bg-secondary: #14161D;
  --text-primary: #E1E1E6;
  --text-secondary: #7D808C;
  --accent: #00E5FF; /* Voltaic Teal */
}

/* Add smooth transitions for color changes */
body, .navbar.scrolled, .article-card, .news-card {
  transition: background-color 0.3s ease, color 0.3s ease;
}

/* --- ADVANCED SEARCH RESULTS STYLES --- */
.search-results {
  margin-top: 3rem;
  max-height: 50vh;
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: var(--accent) var(--bg-secondary);
}

.search-result-item a {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 1.5rem 1rem;
  margin: 0 -1rem;
  border-radius: 8px;
  color: var(--text-primary);
  transition: background-color 0.2s ease-in-out;
}

.search-result-item a:hover {
  background-color: var(--bg-secondary);
  color: var(--accent);
}

.search-result-image {
  flex-shrink: 0;
  width: 100px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
}

.search-result-details h4 {
  font-family: var(--font-ui);
  font-size: 1.6rem;
  font-weight: 500;
  line-height: 1.3;
  margin: 0;
}

.search-result-details p {
  font-family: var(--font-ui);
  font-size: 1.3rem;
  color: var(--text-secondary);
  margin: 0.5rem 0 0 0;
}

/* --- COMMAND PALETTE (CMDK) STYLES --- */
[cmdk-overlay] {
  position: fixed;
  inset: 0;
  background-color: rgba(10, 11, 15, 0.7);
  backdrop-filter: blur(8px);
  animation: fadeIn 0.2s ease;
}

[cmdk-dialog] {
  transform: translate(-50%, -50%);
  position: fixed;
  top: 40%;
  left: 50%;
  width: 90%;
  max-width: 640px;
  background: var(--bg-secondary);
  border-radius: 12px;
  box-shadow: 0 16px 70px rgba(0, 0, 0, 0.2);
  overflow: hidden;
  animation: fadeIn-scale 0.2s ease;
}

[cmdk-input] {
  width: 100%;
  font-family: var(--font-ui);
  font-size: 1.6rem;
  padding: 20px;
  border: none;
  outline: none;
  background: transparent;
  color: var(--text-primary);
  border-bottom: 1px solid var(--bg-primary);
}

[cmdk-list] {
  height: min(300px, calc(var(--cmdk-list-height)));
  max-height: 400px;
  overflow: auto;
  overscroll-behavior: contain;
  padding: 8px;
}

[cmdk-item] {
  content-visibility: auto;
  cursor: pointer;
  border-radius: 8px;
  font-size: 1.4rem;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  color: var(--text-secondary);
  user-select: none;
  will-change: background, color;
  transition: all 150ms ease;
}

[cmdk-item][aria-selected="true"] {
  background: var(--accent);
  color: var(--bg-primary);
}

[cmdk-item] svg {
  width: 1.8rem;
  height: 1.8rem;
}

@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes fadeIn-scale {
  from { opacity: 0; transform: translate(-50%, -48%) scale(0.95); }
  to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
}
EOF

# Step 4: Create the Theme Toggle component
echo "🌞 Creating ThemeToggle component..."
mkdir -p components
cat <<'EOF' > components/ThemeToggle.tsx
'use client';

import { useTheme } from 'next-themes';
import { useEffect, useState } from 'react';

const SunIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>;
const MoonIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>;

export const ThemeToggle = () => {
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return <div style={{ width: '24px', height: '24px' }} />; // Render a placeholder to avoid layout shift
  }

  const isDark = theme === 'dark';

  return (
    <button
      className="nav-theme-toggle"
      onClick={() => setTheme(isDark ? 'light' : 'dark')}
      aria-label={isDark ? 'Activate light mode' : 'Activate dark mode'}
      title={isDark ? 'Activate light mode' : 'Activate dark mode'}
    >
      {isDark ? <SunIcon /> : <MoonIcon />}
    </button>
  );
};
EOF
# Add styling for the new button to globals.css
cat <<'EOF' >> app/globals.css

.nav-theme-toggle {
  background: none;
  border: none;
  cursor: pointer;
  color: var(--text-primary);
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-theme-toggle svg {
    width: 2.2rem;
    height: 2.2rem;
    transition: color 0.3s ease, transform 0.3s ease;
}

.nav-theme-toggle:hover svg {
    color: var(--accent);
    transform: scale(1.1) rotate(15deg);
}
EOF

# Step 5: Create the Command Palette component
echo "⌨️ Creating CommandPalette component..."
cat <<'EOF' > components/CommandPalette.tsx
'use client';

import { Command } from 'cmdk';
import React, { useEffect } from 'react';
import { useCommandPaletteStore } from '@/lib/store';
import { useRouter } from 'next/navigation';
import { useTheme } from 'next-themes';

// Icons for commands
const NavigateIcon = () => <svg fill="none" shapeRendering="geometricPrecision" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" viewBox="0 0 24 24"><path d="M5 12h14"></path><path d="M12 5l7 7-7 7"></path></svg>;
const AuthorIcon = () => <svg fill="none" shapeRendering="geometricPrecision" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>;
const ThemeIcon = () => <svg fill="none" shapeRendering="geometricPrecision" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" viewBox="0 0 24 24"><circle cx="12" cy="12" r="5"></circle><path d="M12 1v2"></path><path d="M12 21v2"></path><path d="M4.22 4.22l1.42 1.42"></path><path d="M18.36 18.36l1.42 1.42"></path><path d="M1 12h2"></path><path d="M21 12h2"></path><path d="M4.22 19.78l1.42-1.42"></path><path d="M18.36 5.64l1.42-1.42"></path></svg>;

export const CommandPalette = () => {
  const { isOpen, close } = useCommandPaletteStore();
  const router = useRouter();
  const { setTheme } = useTheme();

  // Toggle the menu when ⌘K is pressed
  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.key === 'k' && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        useCommandPaletteStore.getState().toggle();
      }
    };

    document.addEventListener('keydown', down);
    return () => document.removeEventListener('keydown', down);
  }, []);

  const runCommand = (command: () => void) => {
    close();
    command();
  };

  return (
    <Command.Dialog open={isOpen} onOpenChange={close} label="Global command menu">
      <Command.Input placeholder="Type a command or search..." />
      <Command.List>
        <Command.Empty>No results found.</Command.Empty>

        <Command.Group heading="Navigation">
          <Command.Item onSelect={() => runCommand(() => router.push('/'))}><NavigateIcon /> Go to Home</Command.Item>
          <Command.Item onSelect={() => runCommand(() => router.push('/reviews'))}><NavigateIcon /> Go to Reviews</Command.Item>
          <Command.Item onSelect={() => runCommand(() => router.push('/news'))}><NavigateIcon /> Go to News</Command.Item>
        </Command.Group>
        
        <Command.Group heading="Authors">
           <Command.Item onSelect={() => runCommand(() => alert('Navigating to Juno Steel page...'))}><AuthorIcon /> Search for Juno Steel</Command.Item>
           <Command.Item onSelect={() => runCommand(() => alert('Navigating to Ada Lovelace page...'))}><AuthorIcon /> Search for Ada Lovelace</Command.Item>
        </Command.Group>
        
        <Command.Group heading="Theme">
            <Command.Item onSelect={() => runCommand(() => setTheme('light'))}><ThemeIcon /> Change to Light Mode</Command.Item>
            <Command.Item onSelect={() => runCommand(() => setTheme('dark'))}><ThemeIcon /> Change to Dark Mode</Command.Item>
            <Command.Item onSelect={() => runCommand(() => setTheme('system'))}><ThemeIcon /> Set to System Preference</Command.Item>
        </Command.Group>

      </Command.List>
    </Command.Dialog>
  );
};
EOF

# Step 6: Upgrade the Search component with advanced results
echo "✨ Upgrading Search component with rich results..."
cat <<'EOF' > components/Search.tsx
'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { allReviews } from '@/lib/data';
import type { Review } from '@/lib/data';
import Image from 'next/image';

type SearchProps = {
  isOpen: boolean;
  onClose: () => void;
};

const CrossIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>;

const Search = ({ isOpen, onClose }: SearchProps) => {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<Review[]>([]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [onClose]);

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newQuery = event.target.value;
    setQuery(newQuery);

    if (newQuery.length > 2) {
      const filteredResults = allReviews.filter(review =>
        review.title.toLowerCase().includes(newQuery.toLowerCase())
      );
      setResults(filteredResults);
    } else {
      setResults([]);
    }
  };
  
  const handleClose = () => {
    setQuery('');
    setResults([]);
    onClose();
  };

  if (!isOpen) {
    return null;
  }

  return (
    <div className="search-overlay" onClick={handleClose}>
      <div className="search-modal" onClick={(e) => e.stopPropagation()}>
        <button className="search-close-button" onClick={handleClose}>
          <CrossIcon />
        </button>
        <input 
          type="search" 
          className="search-input" 
          placeholder="Search for reviews..."
          autoFocus
          value={query}
          onChange={handleSearch}
        />

        <div className="search-results">
          {query.length > 2 && results.length > 0 && (
            <ul>
              {results.map(result => (
                <li key={result.id} className="search-result-item">
                  <Link href={`/reviews/${result.id}`} onClick={handleClose}>
                    <Image 
                      src={result.imageUrl} 
                      alt={result.title}
                      width={100}
                      height={60}
                      className="search-result-image"
                    />
                    <div className="search-result-details">
                      <h4>{result.title}</h4>
                      <p>{result.author} • {result.date}</p>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          )}
          {query.length > 2 && results.length === 0 && (
            <p style={{color: 'var(--text-secondary)', marginTop: '3rem'}}>No results found for "{query}"</p>
          )}
        </div>

      </div>
    </div>
  );
};

export default Search;
EOF

# Step 7: Update Navbar to include ThemeToggle
echo " Navbar receiving the ThemeToggle..."
cat <<'EOF' > components/Navbar.tsx
'use client'; 

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import Search from './Search';
import { ThemeToggle } from './ThemeToggle'; // Import the ThemeToggle

const SearchIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
);

const Navbar = () => {
    const [scrolled, setScrolled] = useState(false);
    const [isSearchOpen, setIsSearchOpen] = useState(false);

    useEffect(() => {
        const handleScroll = () => {
            setScrolled(window.scrollY > 50);
        };
        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);

    const openSearch = () => setIsSearchOpen(true);
    const closeSearch = () => setIsSearchOpen(false);

    return (
        <>
            <header className={`navbar ${scrolled ? 'scrolled' : ''}`}>
                <div className="container nav-container">
                    <Link href="/" className="nav-logo no-underline">∞</Link>
                    <nav>
                        <ul className="nav-links">
                            <li><Link href="/reviews">Reviews</Link></li>
                            <li><Link href="/news">News</Link></li>
                            <li><Link href="/archives">Archives</Link></li>
                        </ul>
                    </nav>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '2rem' }}>
                        <ThemeToggle />
                        <button className="nav-search" onClick={openSearch} aria-label="Open search">
                            <SearchIcon />
                        </button>
                    </div>
                </div>
            </header>
            
            <Search isOpen={isSearchOpen} onClose={closeSearch} />
        </>
    );
};

export default Navbar;
EOF

# Step 8: Update main layout to tie everything together
echo "🧬 Updating app/layout.tsx to integrate providers and components..."
cat <<'EOF' > app/layout.tsx
import { Poppins, Lora, Inter } from 'next/font/google';
import './globals.css';
import Navbar from '@/components/Navbar';
import Footer from '@/components/Footer';
import { ThemeProvider } from '@/components/ThemeProvider'; // Import our new provider
import { CommandPalette } from '@/components/CommandPalette'; // Import the command palette

const poppins = Poppins({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-heading',
  weight: ['700', '800'],
});

const lora = Lora({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-body',
  style: ['normal', 'italic'],
});

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-ui',
});

export const metadata = {
  title: 'EternalGames',
  description: 'Games Are Forever.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${poppins.variable} ${lora.variable} ${inter.variable}`} suppressHydrationWarning>
      <body>
        <ThemeProvider
          attribute="data-theme"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <Navbar />
          <main>{children}</main>
          <Footer />
          <CommandPalette />
        </ThemeProvider>
      </body>
    </html>
  );
}
EOF

# Step 9: Create the ThemeProvider component required by next-themes
echo "💡 Creating ThemeProvider wrapper component..."
cat <<'EOF' > components/ThemeProvider.tsx
'use client';

import * as React from 'react';
import { ThemeProvider as NextThemesProvider } from 'next-themes';
import { type ThemeProviderProps } from 'next-themes/dist/types';

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>;
}
EOF

echo "✅ Batch 1 Complete! All files have been created or updated."
echo "👉 Now, run 'npm run dev' to see your new features in action!"