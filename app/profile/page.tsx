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

    const { bookmarks, readingHistory, clearHistory } = useUserStore();
    
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
                    // CORRECTED: Escaped apostrophe
                    <p>You haven&apos;t bookmarked any articles yet. Start exploring and save your favorites!</p>
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
                    // CORRECTED: Escaped apostrophe
                    <p>You haven&apos;t read any articles yet. Your history will appear here once you do.</p>
                )}
            </div>
        </div>
    );
}
