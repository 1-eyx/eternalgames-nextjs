#!/bin/bash

# ---
# EternalGames Feature Batch 5:
# 1. Implement Reading History functionality.
# 2. Add a "Clear History" button.
# 3. Update the Review & Article pages to log history.
# ---

echo "🚀 Starting Reading History Implementation..."

# Step 1: Upgrade the Profile Page to manage and display history
echo "👤 Upgrading the Profile Page with Reading History logic..."
cat <<'EOF' > app/profile/page.tsx
'use client';

import { useSession } from 'next-auth/react';
import { allContent, Review, RetroArticle } from '@/lib/data';
import ArticleCard from '@/components/ArticleCard';
import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';

export default function ProfilePage() {
    const { data: session, status } = useSession();
    const router = useRouter();
    const [bookmarkedItems, setBookmarkedItems] = useState<(Review | RetroArticle)[]>([]);
    const [historyItems, setHistoryItems] = useState<(Review | RetroArticle)[]>([]);

    const loadDataFromStorage = useCallback(() => {
        if (typeof window !== 'undefined') {
            const bookmarks: number[] = JSON.parse(localStorage.getItem('bookmarks') || '[]');
            const history: number[] = JSON.parse(localStorage.getItem('readingHistory') || '[]');
            
            const bookmarked = allContent.filter(
                item => bookmarks.includes(item.id) && (item.type === 'review' || item.type === 'archive')
            ) as (Review | RetroArticle)[];
            
            const visited = history
                .map(id => allContent.find(item => item.id === id && (item.type === 'review' || item.type === 'archive')))
                .filter(Boolean) as (Review | RetroArticle)[];

            setBookmarkedItems(bookmarked);
            setHistoryItems(visited);
        }
    }, []);

    useEffect(() => {
        loadDataFromStorage();
        window.addEventListener('bookmarksUpdated', loadDataFromStorage);
        window.addEventListener('historyUpdated', loadDataFromStorage);

        return () => {
            window.removeEventListener('bookmarksUpdated', loadDataFromStorage);
            window.removeEventListener('historyUpdated', loadDataFromStorage);
        };
    }, [loadDataFromStorage]);

    useEffect(() => {
        if (status === 'unauthenticated') {
            router.push('/api/auth/signin');
        }
    }, [status, router]);

    const clearHistory = () => {
        if (typeof window !== 'undefined') {
            localStorage.setItem('readingHistory', '[]');
            window.dispatchEvent(new Event('historyUpdated'));
        }
    };
    
    if (status === 'loading' || !session) {
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
                        {historyItems.map(item => (
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

# Step 2: Create a component to log visits
echo "📝 Creating a 'LogVisit' component to track history..."
# This is a "client" component that will do the work of saving to localStorage.
cat <<'EOF' > components/LogVisit.tsx
'use client';

import { useEffect } from 'react';

const LogVisit = ({ articleId }: { articleId: number }) => {
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const history: number[] = JSON.parse(localStorage.getItem('readingHistory') || '[]');
      
      // Remove the ID if it already exists to move it to the front
      const newHistory = history.filter(id => id !== articleId);
      
      // Add the new ID to the beginning of the array (most recent)
      newHistory.unshift(articleId);
      
      // Keep the history to a reasonable size, e.g., the latest 50 articles
      const trimmedHistory = newHistory.slice(0, 50);
      
      localStorage.setItem('readingHistory', JSON.stringify(trimmedHistory));
      
      // Dispatch an event so the profile page knows to update if it's open
      window.dispatchEvent(new Event('historyUpdated'));
    }
  }, [articleId]);

  return null; // This component renders nothing visible
};

export default LogVisit;
EOF

# Step 3: Integrate the LogVisit component into the article pages
echo "🔗 Integrating LogVisit into Review and Article pages..."

# Add LogVisit to the dynamic Review page
sed -i "/import Link from 'next\/link';/a import LogVisit from '@/components/LogVisit';" app/reviews/[slug]/page.tsx
sed -i "/return (/a \ \ \ \ <LogVisit articleId={review.id} />" app/reviews/[slug]/page.tsx

# Add LogVisit to the dynamic Article page
sed -i "/import TagLinks from/a import LogVisit from '@/components/LogVisit';" app/articles/[slug]/page.tsx
sed -i "/return (/a \ \ \ \ <LogVisit articleId={article.id} />" app/articles/[slug]/page.tsx

# Step 4: Add CSS for the new "Clear History" button
echo "🎨 Adding styles for the 'Clear History' button..."
cat <<'EOF' >> app/globals.css

/* --- PROFILE PAGE ENHANCEMENTS --- */
.profile-section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: -2rem; /* Pull the grid closer */
}
.clear-history-button {
    background: transparent;
    border: 1px solid var(--border-color);
    color: var(--text-secondary);
    padding: 0.8rem 1.5rem;
    border-radius: 5px;
    font-family: var(--font-ui), sans-serif;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
}
.clear-history-button:hover {
    border-color: var(--accent);
    color: var(--accent);
    background-color: color-mix(in srgb, var(--accent) 10%, transparent);
}
EOF

echo "✅ Reading History implementation complete."
echo "👉 Please restart your dev server ('npm run dev')."