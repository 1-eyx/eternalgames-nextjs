#!/bin/bash

# ---
# EternalGames Feature Batch 2:
# 1. "You Might Also Like..." Section
# 2. Dynamic Content Blocks in Articles
# 3. Game Hubs / The Index 2.0
# ---

echo "🚀 Starting Feature Integration Batch 2..."

# Step 1: Upgrade the data structure in lib/data.ts for new features
echo "🧠 Upgrading data structure for new features..."
cat <<'EOF' > lib/data.ts
// This file contains all the mock data for the EternalGames website.
// In a real application, this data would be fetched from a Headless CMS like Sanity.

// --- TYPE DEFINITIONS ---
// A union type for all possible content blocks in an article
export type ContentBlock = 
  | { type: 'paragraph'; content: string; }
  | { type: 'image'; src: string; alt: string; }
  | { type: 'pullquote'; content: string; };

export type Review = {
  id: number;
  slug: string; // URL-friendly identifier
  game: string; // Name of the game for the hub
  title: string;
  author: string;
  date: string;
  imageUrl: string;
  score: number;
  verdict: string;
  pros: string[];
  cons: string[];
  content: ContentBlock[]; // Rich content blocks
  relatedReviewIds: number[]; // IDs of related reviews
};

export type RetroArticle = {
  id: number;
  slug: string;
  game: string;
  title: string;
  year: number;
  imageUrl: string;
};

export type NewsItem = {
    id: number;
    slug: string;
    game: string | null; // News can be general
    title: string;
    category: string;
    date: string;
};

// --- MOCK DATA ---
export const allReviews: Review[] = [
  { 
    id: 1, 
    slug: "cybernetic-dawn-a-100-hour-descent",
    game: "Cyberpunk 2077",
    title: "Cybernetic Dawn: A 100-Hour Descent into the Neon-Soaked Abyss", 
    author: "Juno Steel", 
    date: "October 26, 2077", 
    imageUrl: "https://images.unsplash.com/photo-1604280261394-27b5de695137?q=80&w=2070&auto=format&fit=crop", 
    score: 9.3,
    verdict: "Cyberpunk 2077 has been reborn. This isn't just an expansion; it's the final piece of a masterpiece, making the entire package an absolute must-play.",
    pros: ["Gripping spy-thriller narrative", "Dogtown is a fantastic, dense new area", "Complete overhaul of core game systems", "Stunning visuals and art direction"],
    cons: ["Can be demanding on hardware", "Some old bugs still linger in the base game"],
    content: [
        { type: 'paragraph', content: "Night City has never felt more alive, or more dangerous. With the Phantom Liberty expansion and the groundbreaking 2.0 update, Cyberpunk 2077 has completed one of the most remarkable redemption arcs in gaming history." },
        { type: 'image', src: 'https://images.unsplash.com/photo-1593429337220-91a3a8f9039a?q=80&w=2070&auto=format&fit=crop', alt: 'A futuristic car driving through a neon-lit city at night.' },
        { type: 'paragraph', content: "The new district of Dogtown is a labyrinth of intrigue, and the spy-thriller narrative, anchored by a stellar performance from Idris Elba, is CD Projekt Red at its best. Revamped skill trees, vehicular combat, and a complete AI overhaul transform the core experience, making this the game we all dreamed of in 2020." },
        { type: 'pullquote', content: "This is the game we all dreamed of in 2020." }
    ],
    relatedReviewIds: [16, 19]
  },
  { 
    id: 16, 
    slug: "aethelgards-echo-a-generational-saga",
    game: "Aethelgard's Echo",
    title: "Aethelgard's Echo: A Generational Saga", 
    author: "Elara Vance", 
    date: "October 24, 2077", 
    imageUrl: "https://images.unsplash.com/photo-1534972195531-d756b9bfa9f2?q=80&w=2070&auto=format&fit=crop", 
    score: 9.8,
    verdict: "An unparalleled achievement in world-building and narrative design that will be studied for decades. Simply breathtaking.",
    pros: ["Deep, emotionally resonant story", "Revolutionary procedural generation", "Gorgeous, painterly art style"],
    cons: ["Combat can feel slow at times"],
    content: [
        { type: 'paragraph', content: "Every now and then, a game arrives that doesn't just raise the bar, but creates an entirely new one. Aethelgard's Echo is that game. It's a sprawling, generational tale set in a world so rich and detailed it feels less like a creation and more like a discovery." },
        { type: 'paragraph', content: "The core mechanic of living through successive generations, with your previous actions echoing through time, is implemented flawlessly. It creates a sense of weight and consequence that few games have ever achieved." }
    ],
    relatedReviewIds: [1, 19]
  },
  {
    id: 19,
    slug: "the-silent-bloom-hauntingly-beautiful",
    game: "The Silent Bloom",
    title: "The Silent Bloom: A Hauntingly Beautiful Puzzle", 
    author: "Maria Flores", 
    date: "October 18, 2077", 
    imageUrl: "https://images.unsplash.com/photo-1488330890490-c291ecf62571?q=80&w=2070&auto=format&fit=crop", 
    score: 9.2,
    verdict: "A masterpiece of minimalist design and emotional storytelling. The Silent Bloom will stay with you long after the final puzzle is solved.",
    pros: ["Stunning art direction", "Intelligent and rewarding puzzles", "A deeply moving, wordless narrative"],
    cons: ["Some puzzles can be obtuse", "Very short playtime"],
    content: [
      { type: 'paragraph', content: "In a world of explosive action and complex systems, The Silent Bloom is a quiet revolution. It tells its story not with words, but with light, shadow, and beautifully crafted environmental puzzles. Each solution feels like a revelation, both mechanically and emotionally." }
    ],
    relatedReviewIds: [1, 16]
  }
];

export const retroArticles: RetroArticle[] = [
    { id: 5, slug: 'chronicles-of-time-retrospective', game: 'Chronicles of Time', title: "Chronicles of Time: A Retrospective", year: 1995, imageUrl: "https://picsum.photos/seed/chrono/400/300" },
    { id: 6, slug: 'super-metroid-echoes', game: 'Super Metroid', title: "Super Metroid: The Masterpiece That Still Echoes", year: 1994, imageUrl: "https://picsum.photos/seed/metroid/400/300" },
    { id: 7, slug: 'secret-of-monkey-island-revolution', game: 'The Secret of Monkey Island', title: "The Secret of Monkey Island: A Point-and-Click Revolution", year: 1990, imageUrl: "https://picsum.photos/seed/monkey/400/300" },
];

export const newsItems: NewsItem[] = [
    { id: 10, slug: 'ghibli-rpg-partnership', game: null, title: "Studio Ghibli announces partnership with indie game studio for new magical RPG.", category: "Industry", date: "October 27, 2077" },
    { id: 11, slug: 'portal-vr-headset', game: null, title: "Next-gen VR headset 'Portal' to feature full-dive sensory feedback.", category: "Hardware", date: "October 27, 2077" },
    { id: 14, slug: 'starfall-online-patch-7-2', game: 'Starfall Online', title: "Patch 7.2 for 'Starfall Online' brings massive galaxy overhaul and player-built starships.", category: "Updates", date: "October 26, 2077" },
];

// Combine all content for Game Hubs
export const allContent = [
    ...allReviews.map(item => ({ ...item, type: 'review' })),
    ...retroArticles.map(item => ({ ...item, type: 'archive' })),
    ...newsItems.map(item => ({ ...item, type: 'news' })),
];
EOF

# Step 2: Update ArticleCard to use slugs for linking
echo "🔗 Updating ArticleCard links to use slugs..."
cat <<'EOF' > components/ArticleCard.tsx
import Link from 'next/link';
import Image from 'next/image';
import { Review, RetroArticle } from '@/lib/data';

type ArticleCardProps = {
  article: Review | RetroArticle;
  isRetro?: boolean;
};

const ArticleCard = ({ article, isRetro = false }: ArticleCardProps) => {
  const isReview = 'score' in article;
  const linkPath = isReview ? `/reviews/${article.slug}` : `/archives/${article.slug}`;
  
  return (
    <Link href={linkPath} className="no-underline">
      <div className={`article-card ${isRetro ? 'retro-card' : ''}`}>
        <div className="card-image-container">
          {isReview && article.score && (
            <div className="card-score">{article.score.toFixed(1)}</div>
          )}
          <Image
            src={article.imageUrl}
            alt={article.title}
            fill
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
            style={{ objectFit: 'cover' }}
            className="card-image"
          />
        </div>
        <div className="card-content">
          <h3>{article.title}</h3>
          <p className="card-metadata">
            {isRetro && 'year' in article ? `Released: ${article.year}` : ''}
            {isReview && 'author' in article ? `${article.author} • ${article.date}` : ''}
          </p>
        </div>
      </div>
    </Link>
  );
};

export default ArticleCard;
EOF

# Step 3: Create the new component for Dynamic Content Blocks
echo "🧱 Creating ArticleBody component for rich content..."
cat <<'EOF' > components/ArticleBody.tsx
import React from 'react';
import Image from 'next/image';
import { ContentBlock } from '@/lib/data';

type ArticleBodyProps = {
  content: ContentBlock[];
};

const ArticleBody = ({ content }: ArticleBodyProps) => {
  return (
    <div className="article-body">
      {content.map((block, index) => {
        switch (block.type) {
          case 'paragraph':
            return <p key={index}>{block.content}</p>;
          case 'image':
            return (
              <div key={index} className="article-image-wrapper">
                <Image 
                  src={block.src} 
                  alt={block.alt} 
                  width={800} 
                  height={450} 
                  style={{ width: '100%', height: 'auto', borderRadius: '8px' }}
                />
              </div>
            );
          case 'pullquote':
            return <blockquote key={index}>{block.content}</blockquote>;
          default:
            return null;
        }
      })}
    </div>
  );
};

export default ArticleBody;
EOF

# Step 4: Add new styles for Dynamic Content Blocks and You Might Also Like
echo "🎨 Injecting new styles into globals.css..."
cat <<'EOF' >> app/globals.css

/* --- ARTICLE BODY & DYNAMIC CONTENT BLOCKS --- */
.article-body p {
  margin-bottom: 2rem;
  color: var(--text-secondary);
}
[data-theme="dark"] .article-body p {
    color: color-mix(in srgb, var(--text-primary) 80%, transparent);
}
.article-body .article-image-wrapper {
  margin: 3rem 0;
}
.article-body blockquote {
  margin: 4rem 0;
  padding-left: 2rem;
  border-left: 4px solid var(--accent);
  font-family: var(--font-heading), sans-serif;
  font-size: 2.4rem;
  font-style: italic;
  color: var(--text-primary);
}

/* --- "YOU MIGHT ALSO LIKE" SECTION --- */
.related-articles-section {
  margin-top: 8rem;
  padding-top: 4rem;
  border-top: 1px solid var(--border-color);
}
EOF

# Step 5: Upgrade the review page to use dynamic content, slugs, and related articles
echo "📄 Upgrading dynamic review page..."
# First, rename the old dynamic route folder
mv app/reviews/[id] app/reviews/[slug]
# Then, update the page file
cat <<'EOF' > app/reviews/[slug]/page.tsx
import { allReviews } from '@/lib/data';
import Image from 'next/image';
import ScoreBox from '@/components/ScoreBox';
import ArticleBody from '@/components/ArticleBody';
import ArticleCard from '@/components/ArticleCard';
import { notFound } from 'next/navigation';

type ReviewPageProps = {
  params: {
    slug: string;
  };
};

export default function ReviewPage({ params }: ReviewPageProps) {
  const review = allReviews.find(r => r.slug === params.slug);

  if (!review) {
    notFound(); // Use Next.js's built-in 404 handler
  }

  const relatedReviews = allReviews.filter(r => review.relatedReviewIds.includes(r.id));

  return (
    <div className="container page-container">
      <div style={{ maxWidth: '800px', margin: '0 auto' }}>
        <h1 className="page-title" style={{ textAlign: 'left', marginBottom: '1rem', fontSize: '4.8rem' }}>
          {review.title}
        </h1>
        <p style={{ color: 'var(--text-secondary)', marginBottom: '3rem', fontSize: '1.6rem', fontFamily: 'var(--font-ui), sans-serif' }}>
          By {review.author} • {review.date}
        </p>
        <div style={{ position: 'relative', width: '100%', height: '450px', marginBottom: '3rem', borderRadius: '12px', overflow: 'hidden' }}>
          <Image 
            src={review.imageUrl} 
            alt={review.title} 
            fill 
            style={{ objectFit: 'cover' }}
            priority
          />
        </div>
        
        <ArticleBody content={review.content} />
        
        <ScoreBox review={review} />

        <div className="related-articles-section">
            <h2 className="section-title">You Might Also Like</h2>
            <div className="content-grid">
                {relatedReviews.map(related => (
                    <ArticleCard key={related.id} article={related} />
                ))}
            </div>
        </div>

      </div>
    </div>
  );
}
EOF

# Step 6: Create the dynamic Game Hub pages
echo "🎮 Building Game Hub dynamic pages..."
mkdir -p app/games/[slug]
cat <<'EOF' > app/games/[slug]/page.tsx
import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle, NewsItem } from '@/lib/data';

type GameHubPageProps = {
  params: {
    slug: string;
  };
};

// Helper function for type guarding
const isReview = (item: any): item is Review => item.type === 'review';
const isRetroArticle = (item: any): item is RetroArticle => item.type === 'archive';

export default function GameHubPage({ params }: GameHubPageProps) {
  const gameName = decodeURIComponent(params.slug.replace(/-/g, ' '));
  const gameContent = allContent.filter(item => item.game?.toLowerCase() === gameName.toLowerCase());

  if (gameContent.length === 0) {
    notFound();
  }
  
  const featuredImage = gameContent.find(item => isReview(item) || isRetroArticle(item))?.imageUrl 
                       || 'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop';

  return (
    <>
        <div style={{ height: '50vh', position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff' }}>
             <Image src={featuredImage} alt={gameName} fill style={{objectFit: 'cover', zIndex: -2}} />
             <div style={{position: 'absolute', inset: 0, backgroundColor: 'rgba(0,0,0,0.6)', zIndex: -1}} />
             <h1 className="page-title" style={{fontSize: '6.4rem'}}>{gameName}</h1>
        </div>
        <div className="container page-container">
            <h2 className="section-title">All Content</h2>
            <div className="content-grid">
                {gameContent.map(item => {
                    if (isReview(item) || isRetroArticle(item)) {
                        return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
                    }
                    if (item.type === 'news') {
                        return (
                            <div key={`${item.type}-${item.id}`} className="news-card">
                                <h3>{item.title}</h3>
                                <p>{item.category} • {item.date}</p>
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

# Step 7: Update other pages to link to Game Hubs
echo "🔗 Adding links to Game Hubs from other components..."
# We will create a small, reusable component for this
cat <<'EOF' > components/GameLink.tsx
import Link from 'next/link';
import React from 'react';

type GameLinkProps = {
  gameName: string;
};

const GameLink = ({ gameName }: GameLinkProps) => {
  if (!gameName) return null;
  const slug = gameName.replace(/\s+/g, '-').toLowerCase();
  
  return (
    <Link href={`/games/${slug}`} className="game-link no-underline">
      {gameName}
    </Link>
  );
};

export default GameLink;
EOF

# Add style for the GameLink
cat <<'EOF' >> app/globals.css

.game-link {
    display: inline-block;
    background-color: color-mix(in srgb, var(--accent) 15%, transparent);
    color: var(--accent);
    padding: 0.4rem 1rem;
    border-radius: 999px;
    font-family: var(--font-ui), sans-serif;
    font-size: 1.4rem;
    font-weight: 500;
    margin-bottom: 1rem;
    transition: background-color 0.2s ease, color 0.2s ease;
}
.game-link:hover {
    background-color: var(--accent);
    color: #fff;
}
[data-theme="dark"] .game-link:hover {
    color: var(--bg-primary);
}
EOF

# Update the review page to include the GameLink
# This uses sed to insert the component into the page.
sed -i "/<h1 className=\"page-title\"/i \ \ \ \ \ \ \ \ <GameLink gameName={review.game} />" app/reviews/[slug]/page.tsx
sed -i "/import Image from 'next\/image';/a import GameLink from '@/components/GameLink';" app/reviews/[slug]/page.tsx

echo "✅ Batch 2 Complete! All files have been created or updated."
echo "👉 Now, run 'npm run dev' to see your new features in action!"