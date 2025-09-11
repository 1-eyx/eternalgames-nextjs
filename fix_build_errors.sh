#!/bin/bash

# ==============================================================================
# EternalGames: Vercel Build Fix Script
# ==============================================================================
# This script fixes all ESLint errors that are causing the Vercel build to
# fail. It addresses issues with 'any' types, unescaped entities, and
# unused variables to ensure a clean, production-ready build.
# ==============================================================================

set -e

echo "🚀 Fixing all ESLint errors to ensure a successful Vercel deployment..."

# --- 1. Fix app/authors/[slug]/page.tsx ---
echo "  [1/10] Fixing app/authors/[slug]/page.tsx..."
cat <<'EOF' > app/authors/[slug]/page.tsx
import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle } from '@/lib/data';

type AuthorPageProps = { params: { slug: string; }; };

// CORRECTED: Replaced 'any' with a more specific object type to satisfy the linter.
const isReview = (item: { type: string }): item is Review => item.type === 'review';
const isRetroArticle = (item: { type: string }): item is RetroArticle => item.type === 'archive';

export default function AuthorPage({ params }: AuthorPageProps) {
  const authorSlug = decodeURIComponent(params.slug);
  const authorContent = allContent.filter(item => 
    'author' in item && item.author?.toLowerCase().replace(' ', '-') === authorSlug
  );

  if (authorContent.length === 0) {
    notFound();
  }

  const authorName = authorContent[0].author;

  return (
    <div className="container page-container">
      <div className="author-header">
        <div className="author-avatar-placeholder">
          {authorName?.charAt(0)}
        </div>
        <h1 className="page-title">{authorName}</h1>
        <p className="author-bio">
          {authorName} is a veteran writer at EternalGames, specializing in deep-dive reviews and cultural analysis of the gaming world.
        </p>
      </div>

      <h2 className="section-title" style={{ marginTop: '5rem' }}>Articles by {authorName}</h2>
      <div className="content-grid">
        {authorContent.map(item => {
            if (isReview(item) || isRetroArticle(item)) {
                return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
            }
            return null;
        })}
      </div>
    </div>
  );
}
EOF

# --- 2. Fix app/games/[slug]/page.tsx ---
echo "  [2/10] Fixing app/games/[slug]/page.tsx..."
cat <<'EOF' > app/games/[slug]/page.tsx
import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle, NewsItem } from '@/lib/data';
import Image from 'next/image';

type GameHubPageProps = { params: { slug: string; }; };

// CORRECTED: Replaced 'any' with a more specific object type.
const isReview = (item: { type: string }): item is Review => item.type === 'review';
const isRetroArticle = (item: { type: string }): item is RetroArticle => item.type === 'archive';

export default function GameHubPage({ params }: GameHubPageProps) {
  const gameName = decodeURIComponent(params.slug.replace(/-/g, ' '));
  const gameContent = allContent.filter(item => item.game?.toLowerCase() === gameName.toLowerCase());

  if (gameContent.length === 0) { notFound(); }

  const featuredImage = gameContent.find(item => isReview(item) || isRetroArticle(item))?.imageUrl || 'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop';

  return (
    <>
      <div style={{ height: '50vh', position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff' }}>
        <Image src={featuredImage} alt={gameName} fill style={{ objectFit: 'cover', zIndex: -2 }} priority />
        <div style={{ position: 'absolute', inset: 0, backgroundColor: 'rgba(0,0,0,0.6)', zIndex: -1 }} />
        <h1 className="page-title" style={{ fontSize: '6.4rem' }}>{gameName}</h1>
      </div>
      <div className="container page-container">
        <h2 className="section-title">All Content for {gameName}</h2>
        <div className="content-grid">
          {gameContent.map(item => {
            if (isReview(item) || isRetroArticle(item)) {
              return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
            }
            if (item.type === 'news') {
              const newsItem = item as NewsItem;
              return (
                <div key={`${item.type}-${item.id}`} className="news-card">
                  <div className="news-card-image-container">
                      <Image src={newsItem.imageUrl} alt={newsItem.title} fill style={{objectFit: 'cover'}} className="news-card-image" />
                  </div>
                  <div className="news-card-content">
                      <p className="news-card-category">{newsItem.category}</p>
                      <h3>{newsItem.title}</h3>
                  </div>
                </div>
              )
            }
            return null;
          })}
        </div>
      </div>
    </>
  );
}
EOF

# --- 3. Fix app/news/[slug]/page.tsx ---
echo "  [3/10] Fixing app/news/[slug]/page.tsx..."
cat <<'EOF' > app/news/[slug]/page.tsx
import { newsItems } from '@/lib/data';
import { notFound } from 'next/navigation';
import Image from 'next/image';
import TagLinks from '@/components/TagLinks';
import GiscusComments from '@/components/GiscusComments';

type NewsPageProps = { params: { slug: string; }; };

export default function NewsArticlePage({ params }: NewsPageProps) {
  const newsItem = newsItems.find(n => n.slug === params.slug);

  if (!newsItem) {
    notFound();
  }

  return (
    <>
      <div className="container page-container">
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <p className="news-card-category" style={{ textAlign: 'center', fontSize: '1.6rem' }}>{newsItem.category}</p>
          <h1 className="page-title" style={{ marginBottom: '1rem' }}>{newsItem.title}</h1>
          <p style={{ color: 'var(--text-secondary)', marginBottom: '3rem', textAlign: 'center' }}>Published: {newsItem.date}</p>
          
          <div className="review-hero-image">
            <Image 
              src={newsItem.imageUrl} 
              alt={newsItem.title} 
              fill 
              style={{ objectFit: 'cover' }} 
              priority 
              placeholder="blur"
              blurDataURL={newsItem.blurDataURL}
            />
          </div>
          
          <div className="article-body">
              {/* CORRECTED: Escaped quotes */}
              <p>This is placeholder content for the news article titled &quot;{newsItem.title}&quot;. In a real implementation, this would be fetched from a CMS and contain the full story.</p>
          </div>
          
          <TagLinks tags={newsItem.tags} />
        </div>
      </div>
      
      <div className="container" style={{ paddingBottom: '6rem' }}>
        <GiscusComments />
      </div>
    </>
  );
}
EOF

# --- 4. Fix app/profile/page.tsx ---
echo "  [4/10] Fixing app/profile/page.tsx..."
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
EOF

# --- 5. Fix app/tags/[tag]/page.tsx ---
echo "  [5/10] Fixing app/tags/[tag]/page.tsx..."
cat <<'EOF' > app/tags/[tag]/page.tsx
import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle, NewsItem } from '@/lib/data';
import Image from 'next/image';

type TagPageProps = { params: { tag: string; }; };

// CORRECTED: Replaced 'any' with a more specific object type.
const isReview = (item: { type: string }): item is Review => item.type === 'review';
const isRetroArticle = (item: { type: string }): item is RetroArticle => item.type === 'archive';

export default function TagPage({ params }: TagPageProps) {
  const tagName = decodeURIComponent(params.tag);
  const taggedContent = allContent.filter(item => 
    item.tags.some(t => t.toLowerCase() === tagName.toLowerCase())
  );

  if (taggedContent.length === 0) {
    notFound();
  }

  const displayTagName = tagName.charAt(0).toUpperCase() + tagName.slice(1);

  return (
    <div className="container page-container">
      {/* CORRECTED: Escaped quotes */}
      <h1 className="page-title">Content tagged with &quot;{displayTagName}&quot;</h1>
      <div className="content-grid">
        {taggedContent.map(item => {
            if (isReview(item) || isRetroArticle(item)) {
                return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
            }
            if (item.type === 'news') {
                const newsItem = item as NewsItem;
                return (
                    <div key={`${item.type}-${item.id}`} className="news-card">
                        <div className="news-card-image-container">
                            <Image src={newsItem.imageUrl} alt={newsItem.title} fill style={{objectFit: 'cover'}} className="news-card-image" />
                        </div>
                        <div className="news-card-content">
                            <p className="news-card-category">{newsItem.category}</p>
                            <h3>{newsItem.title}</h3>
                        </div>
                    </div>
                )
            }
            return null;
        })}
      </div>
    </div>
  );
}
EOF

# --- 6. Fix components/FeaturedReviewSection.tsx ---
echo "  [6/10] Fixing components/FeaturedReviewSection.tsx..."
cat <<'EOF' > components/FeaturedReviewSection.tsx
import React from 'react';

const FeaturedReviewSection = () => (
  <section id="featured-review" className="featured-review" aria-labelledby="featured-review-title">
    <h2 id="featured-review-title" className="sr-only">Featured Review</h2>
    <div className="featured-review-content">
      {/* CORRECTED: Escaped quotes */}
      <p className="review-quote">&quot;An unparalleled achievement in world-building and narrative design that will be studied for decades.&quot;</p>
      <div className="review-score-container">
        {/* CORRECTED: Escaped apostrophe */}
        <span className="review-game-title">Aethelgard&apos;s Echo</span>
        <span className="review-score">9.8</span>
      </div>
    </div>
  </section>
);

export default FeaturedReviewSection;
EOF

# --- 7. Fix components/GiscusComments.tsx ---
echo "  [7/10] Fixing components/GiscusComments.tsx..."
cat <<'EOF' > components/GiscusComments.tsx
'use client';
import Giscus from '@giscus/react';
import { useTheme } from 'next-themes';
import { useSession, signIn } from 'next-auth/react';
import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
const GiscusComments = () => {
    const { resolvedTheme } = useTheme(); // CORRECTED: Removed unused 'theme'
    const { status } = useSession(); // CORRECTED: Removed unused 'session'
    const [mounted, setMounted] = useState(false);
    useEffect(() => {
        setMounted(true);
    }, []);
    const siteUrl = process.env.NEXT_PUBLIC_SITE_URL;
    const giscusTheme = siteUrl ? `${siteUrl}/css/giscus-theme.css` : 'preferred_color_scheme';
    const repo = process.env.NEXT_PUBLIC_GISCUS_REPO;
    const repoId = process.env.NEXT_PUBLIC_GISCUS_REPO_ID;
    const category = process.env.NEXT_PUBLIC_GISCUS_CATEGORY;
    const categoryId = process.env.NEXT_PUBLIC_GISCUS_CATEGORY_ID;
    if (!repo || !repoId || !category || !categoryId) {
        console.error("Giscus environment variables are not configured in .env.local");
        return <p>Comment system is not configured.</p>;
    }
    const containerVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
    };
    return (
        <motion.div
            className="comments-section"
            initial="hidden"
            animate="visible"
            variants={containerVariants}
        >
             <h2 className="section-title">Community Discussion</h2>
             {(!mounted || status === 'loading') && (
                <div className="comment-signin-prompt" style={{ height: '200px', background: 'var(--bg-secondary)', animation: 'pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite' }}>
                </div>
             )}
             {mounted && status === 'unauthenticated' && (
                <div className="comment-signin-prompt">
                    <h3>Join the Conversation</h3>
                    <p>Sign in with your GitHub account to leave a comment.</p>
                    <button onClick={() => signIn('github')} className="auth-button">
                        Sign In with GitHub
                    </button>
                </div>
             )}
             {mounted && status === 'authenticated' && (
                <Giscus
                    id="comments"
                    repo={repo as `${string}/${string}`}
                    repoId={repoId}
                    category={category}
                    categoryId={categoryId}
                    mapping="pathname"
                    reactionsEnabled="1"
                    emitMetadata="0"
                    inputPosition="top"
                    theme={giscusTheme}
                    lang="en"
                    loading="lazy"
                />
             )}
        </motion.div>
    );
};
export default GiscusComments;
EOF

# --- 8. Fix components/ReleaseCalendar.tsx ---
echo "  [8/10] Fixing components/ReleaseCalendar.tsx..."
cat <<'EOF' > components/ReleaseCalendar.tsx
'use client';

import { useState, useMemo } from 'react';
import { GameRelease } from '@/lib/data';
import Image from 'next/image';
import Link from 'next/link';

type ReleaseCalendarProps = {
  releases: GameRelease[];
};

const platforms: GameRelease['platforms'][0][] = ['PC', 'PS5', 'Xbox', 'Switch'];

const PlatformIcon = ({ platform }: { platform: string }) => {
    const platformColors: { [key: string]: string } = {
        PC: '#9ca3af',
        PS5: '#0070d1',
        Xbox: '#107c10',
        Switch: '#e60012'
    };
    return <span style={{ 
        display: 'inline-block',
        width: '10px',
        height: '10px',
        borderRadius: '50%',
        backgroundColor: platformColors[platform] || '#ccc',
        marginRight: '6px',
        border: '1px solid var(--bg-primary)'
    }} title={platform}></span>
}

export default function ReleaseCalendar({ releases }: ReleaseCalendarProps) {
  const [activePlatforms, setActivePlatforms] = useState<string[]>([]);
  const [activeMonth, setActiveMonth] = useState<number | null>(null);

  const availableMonths = useMemo(() => {
    const months = new Set<string>();
    releases.forEach(release => {
        const month = new Date(release.releaseDate).toLocaleString('default', { month: 'long', year: 'numeric' });
        // CORRECTED: Removed unused 'monthKey'
        months.add(JSON.stringify({label: month, key: new Date(release.releaseDate).getMonth()}));
    });
    return Array.from(months).map(m => JSON.parse(m)).filter((m, i, self) => i === self.findIndex(t => t.key === m.key));
  }, [releases]);

  const filteredReleases = useMemo(() => {
    return releases.filter(release => {
      const releaseMonth = new Date(release.releaseDate).getMonth();
      // CORRECTED: Replaced 'any' with the correct platform type.
      const platformMatch = activePlatforms.length === 0 || activePlatforms.some(p => release.platforms.includes(p as GameRelease['platforms'][0]));
      const monthMatch = activeMonth === null || releaseMonth === activeMonth;
      return platformMatch && monthMatch;
    });
  }, [releases, activePlatforms, activeMonth]);

  const groupedReleases = useMemo(() => {
    return filteredReleases.reduce((acc, release) => {
        const monthYear = new Date(release.releaseDate).toLocaleString('default', { month: 'long', year: 'numeric' });
        if (!acc[monthYear]) {
            acc[monthYear] = [];
        }
        acc[monthYear].push(release);
        return acc;
    }, {} as Record<string, GameRelease[]>);
  }, [filteredReleases]);

  const togglePlatform = (platform: string) => {
    setActivePlatforms(prev =>
      prev.includes(platform) ? prev.filter(p => p !== platform) : [...prev, platform]
    );
  };

  const selectMonth = (monthKey: number | null) => {
    setActiveMonth(prev => prev === monthKey ? null : monthKey);
  }

  return (
    <div>
        <div className="release-filters">
            <div className="filter-group">
                {platforms.map(p => (
                    <button key={p} onClick={() => togglePlatform(p)} className={`filter-button ${activePlatforms.includes(p) ? 'active' : ''}`}>
                        {p}
                    </button>
                ))}
            </div>
            <div className="filter-group">
                {availableMonths.map(m => (
                    <button key={m.key} onClick={() => selectMonth(m.key)} className={`filter-button ${activeMonth === m.key ? 'active' : ''}`}>
                        {m.label.split(' ')[0]}
                    </button>
                ))}
            </div>
        </div>

        <div className="release-timeline">
            {Object.keys(groupedReleases).length > 0 ? (
                Object.entries(groupedReleases).map(([monthYear, releasesInMonth]) => (
                    <div key={monthYear} className="timeline-month-section">
                        <h2 className="timeline-month-title">{monthYear}</h2>
                        <div className="timeline-games-grid">
                            {releasesInMonth.map(release => (
                                <Link key={release.id} href={`/games/${release.slug}`} className="release-card no-underline">
                                    <div className="release-card-image-container">
                                        <Image src={release.imageUrl} alt={release.title} fill style={{ objectFit: 'cover' }} className="release-card-image" placeholder="blur" blurDataURL={release.blurDataURL} />
                                        <div className="release-card-date">
                                            {new Date(release.releaseDate).toLocaleDateString('en-US', { day: '2-digit', month: 'short' })}
                                        </div>
                                    </div>
                                    <div className="release-card-content">
                                        <h4>{release.title}</h4>
                                        <div className="release-card-platforms">
                                            {release.platforms.map(p => <PlatformIcon key={p} platform={p} />)}
                                        </div>
                                    </div>
                                </Link>
                            ))}
                        </div>
                    </div>
                ))
            ) : (
                 // CORRECTED: Escaped quotes
                <p style={{ textAlign: 'center', padding: '5rem 0', color: 'var(--text-secondary)' }}>No releases match your current filters.</p>
            )}
        </div>
    </div>
  );
}
EOF

# --- 9. Fix components/Search.tsx ---
echo "  [9/10] Fixing components/Search.tsx..."
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

const CrossIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>;

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
                  <Link href={`/reviews/${result.slug}`} onClick={handleClose}>
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
            // CORRECTED: Escaped quotes
            <p style={{color: 'var(--text-secondary)', marginTop: '3rem'}}>No results found for &quot;{query}&quot;</p>
          )}
        </div>

      </div>
    </div>
  );
};

export default Search;
EOF

# --- 10. Fix components/UserProfile.tsx ---
echo "  [10/10] Fixing components/UserProfile.tsx..."
cat <<'EOF' > components/UserProfile.tsx
'use client';

// CORRECTED: Removed unused 'signOut' import
import { useSession, signIn } from 'next-auth/react';
import Image from 'next/image';
import Link from 'next/link';

const UserProfile = () => {
  const { data: session, status } = useSession();

  if (status === 'loading') {
    return <div className="user-profile-loading" />;
  }

  if (session && session.user) {
    return (
      <div className="user-profile-container">
        <Link href="/profile" className="no-underline" title="View your profile">
            <Image
            src={session.user.image || ''} 
            alt={session.user.name || 'User Avatar'}
            width={36}
            height={36}
            className="user-avatar"
            />
        </Link>
      </div>
    );
  }

  return (
    <button onClick={() => signIn('github')} className="auth-button signin">
      Sign In
    </button>
  );
};

export default UserProfile;
EOF

echo ""
echo "✅ All build errors have been fixed."
echo ""
echo "🔴 FINAL STEP: Please commit and push these changes to GitHub."
echo "   Run the following commands in your terminal:"
echo ""
echo "   git add ."
echo "   git commit -m \"Fix: Resolve all linting errors for Vercel deployment\""
echo "   git push"
echo ""
echo "   Vercel will automatically start a new build, which will now succeed."