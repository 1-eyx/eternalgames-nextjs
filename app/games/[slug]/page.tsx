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
