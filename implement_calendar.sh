#!/bin/bash

# ==============================================================================
# EternalGames: Zustand State Management Implementation Script
# ==============================================================================
# This script refactors client-side state management from manual localStorage
# to a centralized Zustand store.
# Run it from the root of your 'eternalgames-next' project directory.
# Example: ./implement_zustand.sh
# ==============================================================================

set -e

echo "🚀 Starting EternalGames architectural upgrade: Implementing Zustand..."

# --- Step 1: Create the new Zustand store file ---
echo "  1/4 -> Creating new store at lib/store.ts..."
cat <<'EOF' > lib/store.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

type UserState = {
  bookmarks: number[];
  readingHistory: number[];
};

type UserActions = {
  toggleBookmark: (articleId: number) => void;
  addVisit: (articleId: number) => void;
  clearHistory: () => void;
};

export const useUserStore = create<UserState & UserActions>()(
  persist(
    (set, get) => ({
      bookmarks: [],
      readingHistory: [],
      toggleBookmark: (articleId) => {
        const currentBookmarks = get().bookmarks;
        const isBookmarked = currentBookmarks.includes(articleId);
        const newBookmarks = isBookmarked
          ? currentBookmarks.filter((id) => id !== articleId)
          : [...currentBookmarks, articleId];
        set({ bookmarks: newBookmarks });
      },
      addVisit: (articleId) => {
        const currentHistory = get().readingHistory;
        const newHistory = [articleId, ...currentHistory.filter((id) => id !== articleId)];
        const trimmedHistory = newHistory.slice(0, 50); // Keep history to a reasonable size
        set({ readingHistory: trimmedHistory });
      },
      clearHistory: () => {
        set({ readingHistory: [] });
      },
    }),
    {
      name: 'eternalgames-user-preferences', // The key in localStorage
    }
  )
);
EOF
echo "     ✅ Done."

# --- Step 2: Refactor (overwrite) components to use the new store ---
echo "  2/4 -> Refactoring components: BookmarkButton, LogVisit..."

# Refactor BookmarkButton.tsx
cat <<'EOF' > components/BookmarkButton.tsx
'use client';

import React from 'react';
import { useUserStore } from '@/lib/store';

const BookmarkIcon = ({ isBookmarked }: { isBookmarked: boolean }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24" fill={isBookmarked ? "currentColor" : "none"} stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
    </svg>
);

const BookmarkButton = ({ articleId }: { articleId: number }) => {
    const { bookmarks, toggleBookmark } = useUserStore();
    const isBookmarked = bookmarks.includes(articleId);

    const handleClick = (e: React.MouseEvent) => {
        e.preventDefault();
        e.stopPropagation();
        toggleBookmark(articleId);
    };

    return (
        <button onClick={handleClick} className="bookmark-button" aria-label="Bookmark article">
            <BookmarkIcon isBookmarked={isBookmarked} />
        </button>
    );
};

export default BookmarkButton;
EOF

# Refactor LogVisit.tsx
cat <<'EOF' > components/LogVisit.tsx
'use client';

import { useEffect } from 'react';
import { useUserStore } from '@/lib/store';

const LogVisit = ({ articleId }: { articleId: number }) => {
  const addVisit = useUserStore((state) => state.addVisit);

  useEffect(() => {
    addVisit(articleId);
  }, [articleId, addVisit]);

  return null;
};

export default LogVisit;
EOF

echo "     ✅ Done."


# --- Step 3: Refactor (overwrite) the Profile Page ---
echo "  3/4 -> Refactoring app/profile/page.tsx..."
cat <<'EOF' > app/profile/page.tsx
'use client';

import { useSession } from 'next-auth/react';
import { allContent, Review, RetroArticle } from '@/lib/data';
import ArticleCard from '@/components/ArticleCard';
import { useUserStore } from '@/lib/store';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';

export default function ProfilePage() {
    const { data: session, status } = useSession();
    const router = useRouter();

    // Zustand state
    const { bookmarks, readingHistory, clearHistory } = useUserStore();
    
    // This state ensures the component only renders after the client-side store has been hydrated from localStorage.
    const [isHydrated, setIsHydrated] = useState(false);
    useEffect(() => {
        setIsHydrated(true);
    }, []);

    useEffect(() => {
        if (status === 'unauthenticated') {
            router.push('/api/auth/signin');
        }
    }, [status, router]);

    const bookmarkedItems = allContent.filter(
        item => bookmarks.includes(item.id) && (item.type === 'review' || item.type === 'archive')
    ) as (Review | RetroArticle)[];

    const historyItems = readingHistory
        .map(id => allContent.find(item => item.id === id && (item.type === 'review' || item.type === 'archive')))
        .filter(Boolean) as (Review | RetroArticle)[];

    if (status === 'loading' || !session || !isHydrated) {
        return <div className="container page-container"><h1 className="page-title">Loading...</h1></div>;
    }

    return (
        <div className="container page-container">
            <h1 className="page-title">Welcome, {session.user?.name}</h1>
            
            <div className="profile-section">
                <h2 className="section-title" style={{textAlign: 'left'}}>Your Bookmarks</h2>
                {bookmarkedItems.length > 0 ? (
                    <div className="content-grid">
                        {bookmarkedItems.map(item => (
                            <ArticleCard 
                                key={`bookmark-${item.id}`}
                                article={item}
                                isRetro={item.type === 'archive'}
                            />
                        ))}
                    </div>
                ) : (
                    <p>You haven't bookmarked any articles yet. Start exploring and save your favorites!</p>
                )}
            </div>

            <div className="profile-section">
                <div className="profile-section-header">
                  <h2 className="section-title" style={{textAlign: 'left'}}>Your Reading History</h2>
                  {historyItems.length > 0 && (
                    <button onClick={clearHistory} className="clear-history-button">Clear History</button>
                  )}
                </div>
                {historyItems.length > 0 ? (
                    <div className="content-grid">
                        {historyItems.reverse().map(item => (
                            <ArticleCard 
                                key={`history-${item.id}`}
                                article={item}
                                isRetro={item.type === 'archive'}
                            />
                        ))}
                    </div>
                ) : (
                    <p>You haven't read any articles yet. Your history will appear here once you do.</p>
                )}
            </div>
        </div>
    );
}
EOF
echo "     ✅ Done."

# --- Step 4: Finalizing ---
echo "  4/4 -> Finalizing..."
echo "🎉 Architectural upgrade complete. Client-side state is now managed by Zustand."